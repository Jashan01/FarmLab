import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService{
  FirestoreService._();
  static final instance = FirestoreService._();
  Future<void> setData({
    @required String path,
    @required Map<String, dynamic> data,
}) async {
    final documentReference = FirebaseFirestore.instance.doc(path);
    await documentReference.set(data);
  }
}
