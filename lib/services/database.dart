import 'package:farm_lab/model/profile.dart';
import 'package:farm_lab/services/firesrore_service.dart';
import 'package:flutter/material.dart';

import 'api_path.dart';

abstract class Database{
  Future<void> createProfile(Profile profile);
}
class FirestoreDatabase implements Database{
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;
  Future<void> createProfile(Profile profile) async{
    await _service.setData(
      path: APIpath.profile(uid),
      data: profile.toMap(),
    );
  }
}
