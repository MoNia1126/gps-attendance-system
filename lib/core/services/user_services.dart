import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gps_attendance_system/core/models/user_model.dart';

class UserService {
  //--------- Firebase auth feature --------//
  static FirebaseAuth authInstance = FirebaseAuth.instance;

  //--- Sign in with email and password method ---//
  static Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credentials = await authInstance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credentials.user;
  }

  //--- Create user with email and password ---//
  static Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await authInstance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  // Log out from firebase auth
  static Future<void> signOut() async => authInstance.signOut();

  //-------- Firebase firestore feature --------//

  // database instance
  static FirebaseFirestore db = FirebaseFirestore.instance;

  // create a collection called users
  static CollectionReference<Map<String, dynamic>> users =
      db.collection('users');

  // Add user document to the collection users in database
  // After adding an user, from the admin side.
  static Future<void> addUser(String uid, UserModel user) async {
    try {
      await users.doc(uid).set(user.toJson());
      print('User added successfully.');
    } catch (e) {
      throw Exception('Error adding user: $e');
    }
  }

  // Get user data from firestore
  static Future<UserModel?> getUserData(String uid) async {
    try {
      final DocumentSnapshot<Object?> docSnapshot = await users.doc(uid).get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        return UserModel.fromFirestore(
          docSnapshot as DocumentSnapshot<Map<String, dynamic>>,
        );
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error getting user data: $e');
    }
  }

  // Update user data
  static Future<void> updateUserData({
    required UserModel user,
    required String userId,
  }) async {
    await users.doc(userId).update(user.toJson());
  }

  //-- Get all users data from firestore --//
  static Future<List<UserModel>> getAllUsers() async {
    final snapshot = await users.get();
    List<UserModel> usersData = [];
    snapshot.docs.forEach((doc) {
      usersData.add(
        UserModel.fromFirestore(
          doc as DocumentSnapshot<Map<String, dynamic>>,
        ),
      );
    });
    return usersData;
  }

  static String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

//method to retrieve the contact number of current user
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference<Map<String, dynamic>> _usersCollection =
      _firestore.collection('users');

  // Fetch the current user's contact number
  static Future<String?> getCurrentUserContactNumber() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    print("Current user ID: $userId"); // Debug log
    if (userId != null) {
      final userDoc = await _usersCollection.doc(userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>?;
        final contactNumber = userData?['contactNumber'] as String?;
        print("Fetched contact number: $contactNumber"); // Debug log
        return contactNumber;
      }
    }
    return null;
  }
}
