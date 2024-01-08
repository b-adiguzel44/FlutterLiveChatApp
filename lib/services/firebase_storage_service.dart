import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_munasaka/services/storage_base.dart';

class FirebaseStorageService implements StorageBase {

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  var _storageReference;


  @override
  Future<String> uploadFile(String userID, String fileType, File uploadedFile) async {

    _storageReference = _firebaseStorage.ref()
        .child(userID)
        .child(fileType)
        .child("profile_photo");
    var uploadTask = _storageReference.putFile(uploadedFile, SettableMetadata(
      contentType: "image/jpeg",));

    var url=await uploadTask.then((a) =>
        a.ref.getDownloadURL());


    return url;
  }


}