import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class WalletService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String get _uid => _auth.currentUser?.uid ?? '';
  String? get currentUserId => _auth.currentUser?.uid;

  CollectionReference get _walletCollection => _firestore.collection('wallet');

  /// Upload withdrawal receipt image
  Future<String?> uploadWithdrawalReceipt(File imageFile, String requestId) async {
    try {
      final ref = _storage.ref().child('withdrawal_receipts/$requestId.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading withdrawal receipt: $e');
      return null;
    }
  }

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

  /// Submit a withdrawal request
  Future<bool> requestWithdrawal({
    required double amount,
    required String method,
    required String bank,
    required String accountNumber,
  }) async {
    if (_uid.isEmpty) return false;
    final userUid = _uid;

    try {
      final walletDoc = _walletCollection.doc(userUid);
      final withdrawalRef = walletDoc.collection('withdrawals').doc();

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(walletDoc);
        
        double currentBalance = 0.0;
        double currentEscrow = 0.0;
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          currentBalance = (data['balance'] ?? 0.0).toDouble();
          currentEscrow = (data['escrowBalance'] ?? 0.0).toDouble();
        }

        if (currentBalance < amount) {
          throw Exception('Insufficient balance');
        }

        final newBalance = currentBalance - amount;
        final newEscrow = currentEscrow + amount;

        // 1. Move from balance to escrowBalance
        transaction.update(walletDoc, {
          'balance': newBalance,
          'escrowBalance': newEscrow,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // 2. Create withdrawal record
        transaction.set(withdrawalRef, {
          'id': withdrawalRef.id,
          'uid': userUid,
          'amount': amount,
          'method': method,
          'bank': bank,
          'accountNumber': accountNumber,
          'status': 'Pending',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // 3. Add to transactions as an escrow hold
        final transactionRef = walletDoc.collection('transactions').doc();
        transaction.set(transactionRef, {
          'id': transactionRef.id,
          'title': 'Withdrawal Requested (Locked)',
          'description': 'SAR ${amount.toStringAsFixed(2)} moved to escrow until approval',
          'amount': amount,
          'type': 'debit_to_escrow',
          'status': 'pending',
          'withdrawalId': withdrawalRef.id,
          'createdAt': FieldValue.serverTimestamp(),
        });
      });

      return true;
    } catch (e) {
      print('Error requesting withdrawal: $e');
      return false;
    }
  }

  /// Refund dispute to requester (96% refund) and 1% to helper
  Future<Map<String, dynamic>> refundDisputeToRequester({
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
        final requesterSnapshot = await transaction.get(requesterWalletDoc);
        final helperSnapshot = await transaction.get(helperWalletDoc);

        if (!requesterSnapshot.exists) {
          return {'success': false, 'message': 'Requester wallet not found'};
        }

        final requesterData = requesterSnapshot.data() as Map<String, dynamic>;
        double currentEscrow = (requesterData['escrowBalance'] ?? 0.0).toDouble();
        double currentReqBalance = (requesterData['balance'] ?? 0.0).toDouble();

        double refundAmount = totalAmount * 0.96;
        double helperAmount = totalAmount * 0.01;

        double currentHelperBalance = 0.0;
        if (helperSnapshot.exists) {
          currentHelperBalance = (helperSnapshot.data() as Map<String, dynamic>)['balance'] ?? 0.0;
        }

        // Update requester wallet
        transaction.update(requesterWalletDoc, {
          'escrowBalance': currentEscrow - totalAmount,
          'balance': currentReqBalance + refundAmount,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Update helper wallet
        transaction.set(
          helperWalletDoc,
          {
            'balance': currentHelperBalance + helperAmount,
            'uid': helperUid,
            'updatedAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );

        // Transaction records
        final reqTransRef = requesterWalletDoc.collection('transactions').doc();
        transaction.set(reqTransRef, {
          'id': reqTransRef.id,
          'title': 'Dispute Refund',
          'description': 'Refund (96%) for task "$taskTitle"',
          'amount': refundAmount,
          'type': 'credit',
          'status': 'completed',
          'taskId': taskId,
          'createdAt': FieldValue.serverTimestamp(),
        });

        final helpTransRef = helperWalletDoc.collection('transactions').doc();
        transaction.set(helpTransRef, {
          'id': helpTransRef.id,
          'title': 'Dispute Payment - Partial',
          'description': 'Payment (1%) for task "$taskTitle"',
          'amount': helperAmount,
          'type': 'credit',
          'status': 'completed',
          'taskId': taskId,
          'createdAt': FieldValue.serverTimestamp(),
        });

        return {
          'success': true,
          'refundAmount': refundAmount,
          'helperAmount': helperAmount,
        };
      });

      return result;
    } catch (e) {
      print('Error refunding dispute: $e');
      return {'success': false, 'message': 'An error occurred while refunding: ${e.toString()}'};
    }
  }

  /// Dismiss dispute with split (85% to Helper, 7.5% to Requester)
  Future<Map<String, dynamic>> dismissDisputeWithSplit({
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
        final requesterSnapshot = await transaction.get(requesterWalletDoc);
        final helperSnapshot = await transaction.get(helperWalletDoc);

        if (!requesterSnapshot.exists) {
          return {'success': false, 'message': 'Requester wallet not found'};
        }

        final requesterData = requesterSnapshot.data() as Map<String, dynamic>;
        double currentEscrow = (requesterData['escrowBalance'] ?? 0.0).toDouble();
        double currentReqBalance = (requesterData['balance'] ?? 0.0).toDouble();

        double helperAmount = totalAmount * 0.85;
        double requesterRefund = totalAmount * 0.075;
        double feeAmount = totalAmount - helperAmount - requesterRefund; // 7.5% fee

        double currentHelperBalance = 0.0;
        if (helperSnapshot.exists) {
          currentHelperBalance = (helperSnapshot.data() as Map<String, dynamic>)['balance'] ?? 0.0;
        }

        // Update requester wallet (Subtract from escrow, add 7.5% refund)
        transaction.update(requesterWalletDoc, {
          'escrowBalance': currentEscrow - totalAmount,
          'balance': currentReqBalance + requesterRefund,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Update helper wallet (Add 85%)
        transaction.set(
          helperWalletDoc,
          {
            'balance': currentHelperBalance + helperAmount,
            'uid': helperUid,
            'updatedAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );

        // Transaction records
        final reqTransRef = requesterWalletDoc.collection('transactions').doc();
        transaction.set(reqTransRef, {
          'id': reqTransRef.id,
          'title': 'Dispute Dismissed - Partial Refund',
          'description': 'Refund (7.5%) for task "$taskTitle"',
          'amount': requesterRefund,
          'type': 'credit',
          'status': 'completed',
          'taskId': taskId,
          'createdAt': FieldValue.serverTimestamp(),
        });

        final helpTransRef = helperWalletDoc.collection('transactions').doc();
        transaction.set(helpTransRef, {
          'id': helpTransRef.id,
          'title': 'Dispute Dismissed - Payment',
          'description': 'Payment (85%) for task "$taskTitle"',
          'amount': helperAmount,
          'type': 'credit',
          'status': 'completed',
          'taskId': taskId,
          'createdAt': FieldValue.serverTimestamp(),
        });

        return {
          'success': true,
          'helperAmount': helperAmount,
          'requesterRefund': requesterRefund,
        };
      });

      return result;
    } catch (e) {
      print('Error dismissing dispute with split: $e');
      return {'success': false, 'message': 'An error occurred: ${e.toString()}'};
    }
  }

  /// Get withdrawal requests stream
  Stream<List<Map<String, dynamic>>> getWithdrawalRequestsStream() {
    if (_uid.isEmpty) return Stream.value([]);

    return _walletCollection
        .doc(_uid)
        .collection('withdrawals')
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

  /// Process escrow adjustment when offer is accepted
  Future<Map<String, dynamic>> adjustEscrowAfterOfferAcceptance({
    required String taskId,
    required double taskBudget,
    required double offerPrice,
    required String taskTitle,
  }) async {
    if (_uid.isEmpty) return {'success': false, 'message': 'User not logged in'};

    try {
      final walletDoc = _walletCollection.doc(_uid);

      final result = await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(walletDoc);

        // 1. Get current balances
        double currentBalance = 0.0;
        double currentEscrow = 0.0;
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          currentBalance = (data['balance'] ?? 0.0).toDouble();
          currentEscrow = (data['escrowBalance'] ?? 0.0).toDouble();
        }

        double difference = 0.0;

        // 2. Logic based on user request
        if (offerPrice > taskBudget) {
          // Offer is higher: Add difference to escrow, deduct from wallet
          difference = offerPrice - taskBudget;

          if (currentBalance < difference) {
            return {
              'success': false,
              'message': 'Insufficient wallet balance for price difference',
            };
          }

          transaction.set(
            walletDoc,
            {
              'balance': currentBalance - difference,
              'escrowBalance': currentEscrow + difference,
              'updatedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          );

          // Add transaction record
          final transactionRef = walletDoc.collection('transactions').doc();
          transaction.set(transactionRef, {
            'id': transactionRef.id,
            'title': 'Escrow Adjustment (Top-up)',
            'description': 'Offer accepted is higher than budget for "$taskTitle"',
            'amount': difference,
            'type': 'debit',
            'status': 'completed',
            'taskId': taskId,
            'createdAt': FieldValue.serverTimestamp(),
          });
        } else if (offerPrice < taskBudget) {
          // Offer is lower: Deduct difference from escrow, add back to wallet
          difference = taskBudget - offerPrice;

          transaction.set(
            walletDoc,
            {
              'balance': currentBalance + difference,
              'escrowBalance': currentEscrow - difference,
              'updatedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          );

          // Add transaction record
          final transactionRef = walletDoc.collection('transactions').doc();
          transaction.set(transactionRef, {
            'id': transactionRef.id,
            'title': 'Escrow Adjustment (Refund)',
            'description': 'Offer accepted is lower than budget for "$taskTitle"',
            'amount': difference,
            'type': 'credit',
            'status': 'completed',
            'taskId': taskId,
            'createdAt': FieldValue.serverTimestamp(),
          });
        } else {
          // Equal: No changes needed
          return {'success': true, 'message': 'No adjustment needed'};
        }

        return {
          'success': true,
          'message': 'Escrow adjusted successfully',
          'currentBalance': currentBalance,
          'currentEscrow': currentEscrow,
        };
      });

      return result;
    } catch (e) {
      print('Error adjusting escrow: $e');
      return {'success': false, 'message': 'An error occurred: ${e.toString()}'};
    }
  }

  /// Refund escrow with 4% tax deduction
  Future<Map<String, dynamic>> refundEscrowWithTax({
    required String taskId,
    required double budget,
    required String taskTitle,
  }) async {
    if (_uid.isEmpty) return {'success': false, 'message': 'User not logged in'};

    try {
      final walletDoc = _walletCollection.doc(_uid);

      final result = await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(walletDoc);

        if (!snapshot.exists) {
          return {'success': false, 'message': 'Wallet not found'};
        }

        final data = snapshot.data() as Map<String, dynamic>;
        double currentBalance = (data['balance'] ?? 0.0).toDouble();
        double currentEscrow = (data['escrowBalance'] ?? 0.0).toDouble();

        double refundAmount = budget * 0.96;
        double taxAmount = budget * 0.04;

        transaction.update(walletDoc, {
          'balance': currentBalance + refundAmount,
          'escrowBalance': (currentEscrow - budget).clamp(0.0, double.infinity),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Add transaction record
        final transactionRef = walletDoc.collection('transactions').doc();
        transaction.set(transactionRef, {
          'id': transactionRef.id,
          'title': 'Task Deleted - Refund',
          'description': '96% Refund for "$taskTitle" (4% Tax deducted)',
          'amount': refundAmount,
          'tax': taxAmount,
          'type': 'credit',
          'status': 'completed',
          'taskId': taskId,
          'createdAt': FieldValue.serverTimestamp(),
        });

        return {
          'success': true,
          'message': 'Refund processed with 4% tax',
          'refundAmount': refundAmount,
          'taxAmount': taxAmount,
        };
      });

      return result;
    } catch (e) {
      print('Error refunding escrow with tax: $e');
      return {'success': false, 'message': 'An error occurred: ${e.toString()}'};
    }
  }
  /// Distribute funds after validation consensus (Requester Win vs Helper Win)
  Future<Map<String, dynamic>> distributeValidationFunds({
    required String validationId,
    required String taskId,
    required String winner, // 'helper' or 'requester'
    required List<String> winnerVoterUids,
    required double totalAmount,
    required String taskTitle,
    required String helperUid,
    required String requesterUid,
  }) async {
    try {
      if (helperUid.isEmpty || requesterUid.isEmpty) {
        return {'success': false, 'message': 'Missing Helper or Requester UID'};
      }

      final validationRef = _firestore.collection('validations').doc(validationId);
      final requesterWalletRef = _walletCollection.doc(requesterUid);
      final helperWalletRef = _walletCollection.doc(helperUid);

      final result = await _firestore.runTransaction((transaction) async {
        // 1. Mark validation as distributed to prevent double payment
        final vSnap = await transaction.get(validationRef);
        if (vSnap.exists && (vSnap.data() as Map<String, dynamic>)['isFundsDistributed'] == true) {
          return {'success': false, 'message': 'Funds already distributed'};
        }

        // 2. Fetch wallets (ALL READS MUST BE FIRST)
        final reqSnap = await transaction.get(requesterWalletRef);
        final helpSnap = await transaction.get(helperWalletRef);
        
        // 🔥 Pre-fetch ALL voter wallets before any writes
        final Map<String, DocumentSnapshot> voterSnaps = {};
        for (var vUid in winnerVoterUids) {
          voterSnaps[vUid] = await transaction.get(_walletCollection.doc(vUid));
        }

        double winnerShare = 0;
        double platformShare = 0;
        double voterPoolShare = 0;

        // 3. Perform Writes
        if (winner == 'requester') {
          // Requester wins (Refund)
          winnerShare = totalAmount * 0.96;
          voterPoolShare = totalAmount * 0.02;
          platformShare = totalAmount * 0.02;

          double currentReqBal = (reqSnap.data() as Map<String, dynamic>?)?['balance'] ?? 0.0;
          double currentEscrow = (reqSnap.data() as Map<String, dynamic>?)?['escrowBalance'] ?? 0.0;

          // Refund Requester (add to balance, deduct from escrow)
          transaction.set(requesterWalletRef, {
            'balance': currentReqBal + winnerShare,
            'escrowBalance': (currentEscrow - totalAmount).clamp(0.0, double.infinity),
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

          // Requester Transaction
          final transRef = requesterWalletRef.collection('transactions').doc();
          transaction.set(transRef, {
            'id': transRef.id,
            'title': 'Validation Win - Refund',
            'description': 'Refund (96%) for task "$taskTitle"',
            'amount': winnerShare,
            'type': 'credit',
            'status': 'completed',
            'taskId': taskId,
            'createdAt': FieldValue.serverTimestamp(),
          });

        } else {
          // Helper wins (Payment)
          winnerShare = totalAmount * 0.85;
          voterPoolShare = totalAmount * 0.075;
          platformShare = totalAmount * 0.075;

          double currentHelpBal = (helpSnap.data() as Map<String, dynamic>?)?['balance'] ?? 0.0;
          double currentEscrow = (reqSnap.data() as Map<String, dynamic>?)?['escrowBalance'] ?? 0.0;

          // Pay Helper
          transaction.set(helperWalletRef, {
            'balance': currentHelpBal + winnerShare,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

          // Clean Requester Escrow
          transaction.set(requesterWalletRef, {
            'escrowBalance': (currentEscrow - totalAmount).clamp(0.0, double.infinity),
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

          // Helper Transaction
          final transRef = helperWalletRef.collection('transactions').doc();
          transaction.set(transRef, {
            'id': transRef.id,
            'title': 'Validation Win - Payment',
            'description': 'Payment (85%) for task "$taskTitle"',
            'amount': winnerShare,
            'type': 'credit',
            'status': 'completed',
            'taskId': taskId,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        // 4. Voter Distribution Writes
        if (winnerVoterUids.isNotEmpty) {
          double sharePerVoter = voterPoolShare / winnerVoterUids.length;
          for (var voterUid in winnerVoterUids) {
            final voterSnap = voterSnaps[voterUid];
            double currentVoterBal = (voterSnap?.data() as Map<String, dynamic>?)?['balance'] ?? 0.0;

            final voterWalletRef = _walletCollection.doc(voterUid);
            transaction.set(voterWalletRef, {
              'balance': currentVoterBal + sharePerVoter,
              'updatedAt': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));

            // Voter Transaction
            final transRef = voterWalletRef.collection('transactions').doc();
            transaction.set(transRef, {
              'id': transRef.id,
              'title': 'Validation Reward',
              'description': 'Reward for correct vote on "$taskTitle"',
              'amount': sharePerVoter,
              'type': 'credit',
              'status': 'completed',
              'taskId': taskId,
              'createdAt': FieldValue.serverTimestamp(),
            });
          }
        }

        // 5. Update Validation Doc
        transaction.update(validationRef, {
          'isFundsDistributed': true,
          'fundsDistributedAt': FieldValue.serverTimestamp(),
          'platformFee': platformShare,
          'voterPoolReward': voterPoolShare,
        });

        return {
          'success': true,
          'winnerAmount': winnerShare,
          'voterShareTotal': voterPoolShare,
          'platformFee': platformShare,
        };
      });

      return result;
    } catch (e) {
      print('Error distributing validation funds: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Get all withdrawal requests for admin
  Stream<List<Map<String, dynamic>>> getAllWithdrawalRequestsStream() {
    return _firestore
        .collectionGroup('withdrawals')
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

  /// Process withdrawal request (Approve/Reject)
  Future<Map<String, dynamic>> processWithdrawalRequest({
    required String requestId,
    required String userUid,
    required String status, // 'Completed' or 'Rejected'
    String? receiptUrl,
  }) async {
    try {
      final walletDoc = _walletCollection.doc(userUid);
      final withdrawalRef = walletDoc.collection('withdrawals').doc(requestId);

      final result = await _firestore.runTransaction((transaction) async {
        // 1. Read necessary docs
        final walletSnap = await transaction.get(walletDoc);
        final withdrawalSnap = await transaction.get(withdrawalRef);

        if (!walletSnap.exists || !withdrawalSnap.exists) {
          return {'success': false, 'message': 'Wallet or Request not found'};
        }

        final walletData = walletSnap.data() as Map<String, dynamic>;
        final withdrawalData = withdrawalSnap.data() as Map<String, dynamic>;
        
        if (withdrawalData['status'] != 'Pending') {
          return {'success': false, 'message': 'Request already processed'};
        }

        double amount = (withdrawalData['amount'] ?? 0.0).toDouble();
        double currentBalance = (walletData['balance'] ?? 0.0).toDouble();
        double currentEscrow = (walletData['escrowBalance'] ?? 0.0).toDouble();

        if (status == 'Completed') {
          // APPROVAL: Deduct from escrowBalance
          if (currentEscrow < amount) {
             // Safety check, though it should be there as we moved it during request
             amount = currentEscrow; 
          }

          transaction.update(walletDoc, {
            'escrowBalance': currentEscrow - amount,
            'updatedAt': FieldValue.serverTimestamp(),
          });

          // Update withdrawal record with receipt
          transaction.update(withdrawalRef, {
            'status': 'Completed',
            'receiptUrl': receiptUrl,
            'processedAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });

          // Add completion transaction record
          final transRef = walletDoc.collection('transactions').doc();
          transaction.set(transRef, {
            'id': transRef.id,
            'title': 'Withdrawal Completed',
            'description': 'Funds released from escrow to your bank',
            'amount': amount,
            'type': 'debit', // Final debit from the user's total wealth
            'status': 'completed',
            'receiptUrl': receiptUrl,
            'withdrawalId': requestId,
            'createdAt': FieldValue.serverTimestamp(),
          });

        } else if (status == 'Rejected') {
          // REJECTION: Move back from escrowBalance to balance
          if (currentEscrow < amount) {
             amount = currentEscrow;
          }

          transaction.update(walletDoc, {
            'balance': currentBalance + amount,
            'escrowBalance': currentEscrow - amount,
            'updatedAt': FieldValue.serverTimestamp(),
          });

          // Update withdrawal record
          transaction.update(withdrawalRef, {
            'status': 'Rejected',
            'processedAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });

          // Add rejection transaction record
          final transRef = walletDoc.collection('transactions').doc();
          transaction.set(transRef, {
            'id': transRef.id,
            'title': 'Withdrawal Rejected',
            'description': 'Funds returned to your wallet balance',
            'amount': amount,
            'type': 'credit',
            'status': 'completed',
            'withdrawalId': requestId,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        return {'success': true, 'amount': amount};
      });

      return result;
    } catch (e) {
      print('Error processing withdrawal: $e');
      return {'success': false, 'message': e.toString()};
    }
  }
}
