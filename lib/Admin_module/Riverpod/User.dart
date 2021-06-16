


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paldes/modal/User.dart';


var userProvider = ChangeNotifierProvider<UserProvider>((ref)=>UserProvider(ref));

class UserProvider extends ChangeNotifier{

  ProviderReference ref;
  UserProvider(this.ref);
  List<UserDetails> userDetailList=[];
  UserDetails details = UserDetails();

  Future<List<UserDetails>> getUserList()async{
    userDetailList.clear();
    QuerySnapshot query = await FirebaseFirestore.instance.collection("Users").get();
    for(int i=0;i<query.docs.length;i++){
      details = details.fromMap(query.docs[i]);
      userDetailList.add(details);
    }
  return userDetailList;
  }

}
