import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/models/user.dart';

const String user_Collection_Ref = 'users';

class dbService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _userRef;

  dbService() {
    _userRef = _firestore.collection(user_Collection_Ref).withConverter<dbUser>(
        fromFirestore: (snapshots, _) => dbUser.fromJson(
              snapshots.data()!,
            ),
        toFirestore: (user, _) => user.toJson());
  }

  // CRUD Controllers
  Stream<QuerySnapshot> getUsers() {
    return _userRef.snapshots();
  }

  void addUser(dbUser user) async {
    _userRef.add(user);
  }

  void updateUser(String uid, dbUser user) async {
    _userRef.doc(uid).update(user.toJson());
  }

  void deleteUser(String uid) async {
    _userRef.doc(uid).delete();
  }

  Future<bool> checkUser(String? email) async {
    try {
      var user = await _userRef.where('email', isEqualTo: email).get();
      return user.docs.isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }
}
