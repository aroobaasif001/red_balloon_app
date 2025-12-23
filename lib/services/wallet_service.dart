import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WalletService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser?.uid ?? '';

  CollectionReference get _walletCollection => _firestore.collection('wallet');

  /// Get current wallet balance
  Stream<double> getWalletBalance() {
    if (_uid.isEmpty) return Stream.value(0.0);
    
    return _walletCollection.doc(_uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return (data['balance'] ?? 0.0).toDouble();
      }
      return 0.0;
    });
  }

  /// Get current locked balance (escrow)
  Stream<double> getLockedBalance() {
    if (_uid.isEmpty) return Stream.value(0.0);
    
    return _walletCollection.doc(_uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return (data['escrowBalance'] ?? 0.0).toDouble();
      }
      return 0.0;
    });
  }

  /// Get current balance (one-time fetch)
  Future<double> getCurrentBalance() async {
    if (_uid.isEmpty) return 0.0;
    
    try {
      final snapshot = await _walletCollection.doc(_uid).get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return (data['balance'] ?? 0.0).toDouble();
      }
      return 0.0;
    } catch (e) {
      print('Error getting current balance: $e');
      return 0.0;
    }
  }

  /// Deduct funds for escrow when posting a task
  Future<Map<String, dynamic>> deductForEscrow({
    required double amount,
    required String taskId,
    required String taskTitle,
  }) async {
    if (_uid.isEmpty) {
      return {'success': false, 'message': 'User not logged in'};
    }

    try {
      final walletDoc = _walletCollection.doc(_uid);

      final result = await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(walletDoc);

        double currentBalance = 0.0;
        double currentEscrowBalance = 0.0;
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          currentBalance = (data['balance'] ?? 0.0).toDouble();
          currentEscrowBalance = (data['escrowBalance'] ?? 0.0).toDouble();
        }

        // Check if sufficient balance
        if (currentBalance < amount) {
          return {
            'success': false,
            'message': 'Insufficient balance',
            'currentBalance': currentBalance,
            'required': amount,
          };
        }

        final newBalance = currentBalance - amount;
        final newEscrowBalance = currentEscrowBalance + amount;

        // Update wallet balance and total escrow
        transaction.set(
          walletDoc,
          {
            'balance': newBalance,
            'escrowBalance': newEscrowBalance,
            'uid': _uid,
            'updatedAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );

        // Add to transactions subcollection
        final transactionRef = walletDoc.collection('transactions').doc();
        transaction.set(transactionRef, {
          'id': transactionRef.id,
          'title': 'Task Posted - Escrow',
          'description': taskTitle,
          'amount': amount,
          'type': 'debit',
          'status': 'completed',
          'taskId': taskId,
          'createdAt': FieldValue.serverTimestamp(),
        });

        return {
          'success': true,
          'message': 'Funds locked in escrow',
          'newBalance': newBalance,
          'escrowBalance': newEscrowBalance,
        };
      });

      return result;
    } catch (e) {
      print('Error deducting for escrow: $e');
      return {'success': false, 'message': 'An error occurred: ${e.toString()}'};
    }
  }

  /// Add funds to wallet
  Future<bool> addFunds(double amount) async {
    if (_uid.isEmpty) return false;

    try {
      final walletDoc = _walletCollection.doc(_uid);
      
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(walletDoc);
        
        double currentBalance = 0.0;
        if (snapshot.exists) {
          currentBalance = (snapshot.data() as Map<String, dynamic>)['balance'] ?? 0.0;
        }

        final newBalance = currentBalance + amount;

        transaction.set(walletDoc, {
          'balance': newBalance,
          'uid': _uid,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        // Add to transactions subcollection
        final transactionRef = walletDoc.collection('transactions').doc();
        transaction.set(transactionRef, {
          'id': transactionRef.id,
          'title': 'Funds Added',
          'description': 'Added via App',
          'amount': amount,
          'type': 'credit',
          'status': 'completed',
          'createdAt': FieldValue.serverTimestamp(),
        });
      });

      return true;
    } catch (e) {
      print('Error adding funds: $e');
      return false;
    }
  }

  /// Get transaction history
  Stream<List<Map<String, dynamic>>> getTransactions() {
    if (_uid.isEmpty) return Stream.value([]);

    return _walletCollection
        .doc(_uid)
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  /// Get selected badges stream
  Stream<List<String>> getSelectedBadgesStream() {
    if (_uid.isEmpty) return Stream.value([]);
    return _walletCollection.doc(_uid).snapshots().map((snapshot) {
      if (!snapshot.exists) return [];
      final data = snapshot.data() as Map<String, dynamic>;
      return List<String>.from(data['selectedBadges'] ?? []);
    });
  }

  /// Toggle badge selection (Max 2)
  Future<Map<String, dynamic>> toggleBadgeSelection(List<String> selectedTitles) async {
    if (_uid.isEmpty) return {'success': false, 'message': 'User not logged in'};

    try {
      await _walletCollection.doc(_uid).update({
        'selectedBadges': selectedTitles,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return {'success': true, 'message': 'Badges updated successfully'};
    } catch (e) {
      print('Error toggling badge selection: $e');
      return {'success': false, 'message': 'An error occurred while updating selection'};
    }
  }

  /// Get owned badges by UID
  Stream<List<Map<String, dynamic>>> getOwnedBadgesStreamByUid(String uid) {
    if (uid.isEmpty) return Stream.value([]);

    return _walletCollection
        .doc(uid)
        .collection('badges')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  /// Get owned badges
  Stream<List<Map<String, dynamic>>> getOwnedBadgesStream() {
    if (_uid.isEmpty) return Stream.value([]);

    return _walletCollection
        .doc(_uid)
        .collection('badges')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  /// Purchase a badge
  Future<Map<String, dynamic>> purchaseBadge(String title, double price) async {
    if (_uid.isEmpty) return {'success': false, 'message': 'User not logged in'};

    try {
      final walletDoc = _walletCollection.doc(_uid);
      final badgeDoc = walletDoc.collection('badges').doc(title);

      final result = await _firestore.runTransaction((transaction) async {
        final walletSnapshot = await transaction.get(walletDoc);
        final badgeSnapshot = await transaction.get(badgeDoc);

        if (badgeSnapshot.exists) {
          return {'success': false, 'message': 'You already own this badge'};
        }

        double currentBalance = 0.0;
        if (walletSnapshot.exists) {
          final data = walletSnapshot.data() as Map<String, dynamic>;
          currentBalance = (data['balance'] ?? 0.0).toDouble();
        }

        if (currentBalance < price) {
          return {'success': false, 'message': 'Insufficient balance'};
        }

        final newBalance = currentBalance - price;

        // Update balance
        transaction.update(walletDoc, {
          'balance': newBalance,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Add badge to owned list
        transaction.set(badgeDoc, {
          'title': title,
          'purchasedAt': FieldValue.serverTimestamp(),
          'price': price,
        });

        // Add to transactions
        final transactionRef = walletDoc.collection('transactions').doc();
        transaction.set(transactionRef, {
          'id': transactionRef.id,
          'title': 'Badge Purchased',
          'description': title,
          'amount': price,
          'type': 'debit',
          'status': 'completed',
          'createdAt': FieldValue.serverTimestamp(),
        });

        return {'success': true, 'message': 'Badge purchased successfully'};
      });

      return result;
    } catch (e) {
      print('Error purchasing badge: $e');
      return {'success': false, 'message': 'An error occurred during purchase'};
    }
  }

  /// Release escrow to helper after task completion
  Future<Map<String, dynamic>> releaseEscrowToHelper({
    required String taskId,
    required String requesterUid,
    required String helperUid,
    required double totalAmount,
    required String taskTitle,
  }) async {
    try {
      final requesterWalletDoc = _walletCollection.doc(requesterUid);
      final helperWalletDoc = _walletCollection.doc(helperUid);

      final result = await _firestore.runTransaction((transaction) async {
        // 1. Read all needed documents FIRST
        final requesterSnapshot = await transaction.get(requesterWalletDoc);
        final helperSnapshot = await transaction.get(helperWalletDoc);

        // 2. Validate requester wallet
        if (!requesterSnapshot.exists) {
          return {'success': false, 'message': 'Requester wallet not found'};
        }

        final requesterData = requesterSnapshot.data() as Map<String, dynamic>;
        double currentEscrow = (requesterData['escrowBalance'] ?? 0.0).toDouble();

        // 3. Calculate amounts
        double helperAmount = totalAmount * 0.85;
        double escrowFee = totalAmount * 0.075;
        double platformFee = totalAmount * 0.075;

        // 4. Prepare helper data
        double currentHelperBalance = 0.0;
        if (helperSnapshot.exists) {
          currentHelperBalance = (helperSnapshot.data() as Map<String, dynamic>)['balance'] ?? 0.0;
        }

        // 5. PERFORM ALL WRITES AFTER ALL READS

        // Update requester wallet (Subtract from escrowBalance)
        transaction.update(requesterWalletDoc, {
          'escrowBalance': currentEscrow - totalAmount,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Update helper wallet (Add to balance)
        transaction.set(
          helperWalletDoc,
          {
            'balance': currentHelperBalance + helperAmount,
            'uid': helperUid,
            'updatedAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );

        // Add transaction records
        // Requester Transaction (Escrow Released)
        final reqTransRef = requesterWalletDoc.collection('transactions').doc();
        transaction.set(reqTransRef, {
          'id': reqTransRef.id,
          'title': 'Escrow Released',
          'description': 'Task "$taskTitle" completed',
          'amount': totalAmount,
          'type': 'debit_escrow',
          'status': 'completed',
          'taskId': taskId,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Helper Transaction (Payment Received)
        final helpTransRef = helperWalletDoc.collection('transactions').doc();
        transaction.set(helpTransRef, {
          'id': helpTransRef.id,
          'title': 'Payment Received',
          'description': 'For task "$taskTitle" (85% after fees)',
          'amount': helperAmount,
          'type': 'credit',
          'status': 'completed',
          'taskId': taskId,
          'createdAt': FieldValue.serverTimestamp(),
          'feesDeducted': escrowFee + platformFee,
          'escrowFee': escrowFee,
          'platformFee': platformFee,
        });

        return {
          'success': true,
          'helperAmount': helperAmount,
          'fees': escrowFee + platformFee,
          'escrowFee': escrowFee,
          'platformFee': platformFee,
        };
      });

      return result;
    } catch (e) {
      print('Error releasing escrow: $e');
      return {'success': false, 'message': 'An error occurred while releasing escrow: ${e.toString()}'};
    }
  }
}
