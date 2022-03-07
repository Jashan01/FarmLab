import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
class Profile {
  Profile({
    @required this.name,
    @required this.phoneNumber,
    this.image,
  });
  String name;
  String phoneNumber;
  String image;
  factory Profile.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String image = data['image'];
    final String name = data['name'];
    final String phoneNumber = data['phoneNumber'];
    return Profile(
      name: name,
      image: image,
      phoneNumber: phoneNumber,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'name' : name,
      'phoneNumber' : phoneNumber,
    };
  }
}
