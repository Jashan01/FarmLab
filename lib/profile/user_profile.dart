import 'dart:io';

import 'package:farm_lab/custom_widgets/custom_error_dialog.dart';
import 'package:farm_lab/model/profile.dart';
import 'package:farm_lab/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
class UserProfile extends StatefulWidget {
  //const UserProfile({Key? key}) : super(key: key);
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  String _imageUrl;
  File _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Edit Profile")),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator(),) : _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: (
        Column(
          children: [
            TextField(
              style: (TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400
              )),
              decoration: InputDecoration(
                labelText: 'Name',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide( width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
              controller: _nameController,
            ),
            SizedBox(height: 15,),
            TextField(
              style: (TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400
              )),
              decoration: InputDecoration(
                labelText: 'Phone Number',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide( width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
              controller: _phoneController,
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              child: Text('Take an image', style: TextStyle(color: Colors.white),),
              onPressed: captureImage,
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              child: Text('Select an image', style: TextStyle(color: Colors.white)),
              onPressed: pickImage,
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () => _submit(context),
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        )
        ),
      ),
    );
  }

  String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

  Future<void> captureImage() async{
    final img = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(img.path);
    });
  }

  Future<void> pickImage() async{
    final img = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(img.path);
    });
  }
  Future<bool> _uploadReportImage(Database database) async {
    setState(() {
      _isLoading = true;
    });
    final Database database = Provider.of<Database>(context, listen: false);
    Reference storageReference = FirebaseStorage.instance.ref().child(
        'user/$database.uid/${documentIdFromCurrentDate()}');
    UploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.then((TaskSnapshot snapshot) async {
      _imageUrl = await storageReference.getDownloadURL();
      print(' Photo Uploaded');
    }).catchError((Object e) {
      print(e); // FirebaseException
      return false;
    });
    return true;
  }

  Future<void>_submit(BuildContext context) async{
    final Database database = Provider.of<Database>(context, listen: false);
    if(_nameController.text.isNotEmpty){
      if(_phoneController.text.isNotEmpty){
        if(await _uploadReportImage(database)){
          final profile = Profile(
            name: _nameController.text,
            phoneNumber: _phoneController.text,
            image: _imageUrl,
          );
          try{
            await database.createProfile(profile);
            setState(() {
              _isLoading = false;
            });
            await CustomErrorDialog.show(
                context: context,
                title: 'Profile Editted Successfully',
                message: 'Successful');
          } catch(e){
            CustomErrorDialog.show(
                context: context,
                title: 'Upload Failed',
                message: e.toString());
          }
        } else{
          CustomErrorDialog.show(
              context: context,
              title: 'Upload Failed',
              message: 'please upload image');
        }
      } else{
        CustomErrorDialog.show(
          context: context,
          title: 'uplaod failed',
          message: 'Please enter phone number',
        );
      }
    } else{
      CustomErrorDialog.show(
        context: context,
        title: 'uplaod failed',
        message: 'Please enter name',
      );
    }
  }

}
