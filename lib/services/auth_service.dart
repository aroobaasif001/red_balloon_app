import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:red_balloon_app/model/auth_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // final FirestoreService _firestoreService = FirestoreService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collection reference
  CollectionReference get usersCollection => _firestore.collection('users');

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with Google
  Future<AuthModel?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final authModel = AuthModel.fromFirebaseUser(userCredential.user!, 'google');
        
        // Save user data to Firestore
        await saveUserFromModel(authModel);
        
        return authModel;
      }

      return null;
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  // Sign in with Apple
  Future<AuthModel?> signInWithApple() async {
    try {
      // Request credential for the currently signed in Apple account
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create an OAuth credential
      final oAuthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in to Firebase with the Apple credential
      final UserCredential userCredential = await _auth.signInWithCredential(oAuthCredential);

      // Update display name if available from Apple (first time only)
      if (userCredential.additionalUserInfo?.isNewUser == true) {
        final fullName = appleCredential.givenName != null || appleCredential.familyName != null
            ? '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'.trim()
            : null;

        if (fullName != null && fullName.isNotEmpty) {
          await userCredential.user?.updateDisplayName(fullName);
        }
      }

      if (userCredential.user != null) {
        final authModel = AuthModel.fromFirebaseUser(userCredential.user!, 'apple');
        
        // Save user data to Firestore
        await saveUserFromModel(authModel);
        
        return authModel;
      }

      return null;
    } catch (e) {
      print('Error signing in with Apple: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      final uid = currentUser?.uid;
      if (uid != null) {
        // Delete user data from Firestore first
        await deleteUserData(uid);
      }
      // Then delete the auth account
      await currentUser?.delete();
    } catch (e) {
      print('Error deleting account: $e');
      rethrow;
    }
  }

  // Convert current Firebase user to AuthModel
  AuthModel? getCurrentUserModel() {
    final user = currentUser;
    if (user == null) return null;

    // Determine provider
    String provider = 'email';
    if (user.providerData.isNotEmpty) {
      final providerId = user.providerData.first.providerId;
      if (providerId.contains('google')) {
        provider = 'google';
      } else if (providerId.contains('apple')) {
        provider = 'apple';
      }
    }

    return AuthModel.fromFirebaseUser(user, provider);
  }


  // Generate unique userId (RB-001, RB-002, etc.)
  Future<String> _generateUserId() async {
    try {
      // Get all users to find the highest userId number
      final snapshot = await usersCollection.get();
      
      int maxNumber = 0;
      
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('userId')) {
          final userId = data['userId'] as String;
          // Extract number from "RB-001" format
          if (userId.startsWith('RB-')) {
            final numberStr = userId.substring(3); // Remove "RB-"
            final number = int.tryParse(numberStr) ?? 0;
            if (number > maxNumber) {
              maxNumber = number;
            }
          }
        }
      }
      
      // Increment and format as RB-XXX
      final nextNumber = maxNumber + 1;
      final userId = 'RB-${nextNumber.toString().padLeft(3, '0')}';
      
      print('🔥 Generated userId: $userId');
      return userId;
    } catch (e) {
      print('❌ Error generating userId: $e');
      // Fallback to RB-001 if error
      return 'RB-001';
    }
  }

  // Create or update user document
  Future<void> saveUserData({
    required String uid,
    required String email,
    required String provider,
    String? displayName,
    String? photoURL,
  }) async {
    try {
      // Check if user already exists
      final userDoc = await usersCollection.doc(uid).get();
      final isNewUser = !userDoc.exists;
      
      final userData = {
        'uid': uid,
        'email': email,
        'provider': provider,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Add optional fields only if they are not null
      if (displayName != null && displayName.isNotEmpty) {
        userData['displayName'] = displayName;
      }

      if (photoURL != null && photoURL.isNotEmpty) {
        userData['photoURL'] = photoURL;
      }

      // 🔥 Generate and assign userId for new users only
      if (isNewUser) {
        final userId = await _generateUserId();
        userData['userId'] = userId;
        userData['willLogin'] = true; // Default to true for new users
        print('✅ Assigned userId: $userId and willLogin: true to new user: $uid');
      }

      // Use set with merge to create or update the document
      await usersCollection.doc(uid).set(
        userData,
        SetOptions(merge: true),
      );

      print('User data saved successfully for uid: $uid');
    } catch (e) {
      print('Error saving user data: $e');
      rethrow;
    }
  }

  // Save user from AuthModel
  Future<void> saveUserFromModel(AuthModel user) async {
    await saveUserData(
      uid: user.uid,
      email: user.email ?? '',
      provider: user.provider,
      displayName: user.displayName,
      photoURL: user.photoURL,
    );
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await usersCollection.doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String uid,
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (displayName != null) {
        updateData['displayName'] = displayName;
      }

      if (photoURL != null) {
        updateData['photoURL'] = photoURL;
      }

      await usersCollection.doc(uid).update(updateData);
      print('User profile updated successfully');
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  // Delete user data
  Future<void> deleteUserData(String uid) async {
    try {
      await usersCollection.doc(uid).delete();
      print('User data deleted successfully');
    } catch (e) {
      print('Error deleting user data: $e');
      rethrow;
    }
  }

  // Check if user exists
  Future<bool> userExists(String uid) async {
    try {
      final doc = await usersCollection.doc(uid).get();
      return doc.exists;
    } catch (e) {
      print('Error checking user existence: $e');
      return false;
    }
  }

  // Stream user data
  Stream<DocumentSnapshot> streamUserData(String uid) {
    return usersCollection.doc(uid).snapshots();
  }

  // Upload profile image to Firebase Storage
  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      if (currentUser == null) {
        print('User not authenticated');
        return null;
      }

      final uid = currentUser!.uid;
      final fileName = 'profile_${uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('profiles/$uid/$fileName');

      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();

      print('Profile image uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }

  // Update user profile with multiple fields
  Future<void> updateUserProfileWithFields({
    required String uid,
    required Map<String, dynamic> updateData,
  }) async {
    try {
      await usersCollection.doc(uid).update(updateData);
      print('User profile updated successfully with all fields');
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }
}
