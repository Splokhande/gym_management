import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDb {

  FirebaseFirestore firebase = FirebaseFirestore.instance;
  static const String user = "Users";

  register(id,data) async {
    print(data);

    return await firebase.collection(user)
                  .doc(id)
                  .set(data);
  }

  updateUser(id,data) async {
    print(data);

    return await firebase.collection(user)
                  .doc(id)
                  .update(data);
  }

  login(id) async {
     return await firebase.collection(user)
                    .doc(id)
                    .get();
    }




}