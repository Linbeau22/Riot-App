import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password); //try to sign in with existing account
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> register(String email, String password) async {
  try {
    print('yeti1');
    await FirebaseAuth
        .instance //try to create a user with given email and password
        .createUserWithEmailAndPassword(email: email, password: password);
    print('yeti2');
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak!');
    } else if (e.code == 'email-already-in-use') {
      print('The email already exists!');
    }
    return false;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future<bool> addAmount(String id, String amount) async {
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid; //uid is user id
    var value = double.parse(amount);
    DocumentReference documentReference = FirebaseFirestore
        .instance //grabbing the document from firestore
        .collection(
            'Users') //This is the area that creates the stuff on Firebase
        .doc(uid)
        .collection('Coins')
        .doc(id); //id is Dallas
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set({'Amount': value});
        return true;
      }
      double newAmount = snapshot['Amount'] + value;
      transaction.update(documentReference, {'Amount': newAmount});
      return true;
    });
    return true;
  } catch (e) {
    return false;
  }
}
