import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_munasaka/common_widget/platform_specific_alert_dialog.dart';
import 'package:flutter_munasaka/common_widget/social_login_in_button.dart';
import 'package:flutter_munasaka/viewmodel/user_viewmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  File? _profilePhoto;
  final ImagePicker _picker = ImagePicker();
  late TextEditingController _controllerUsername;


  _addNewPhoto(ImageSource source) async {
    var _pickedPhoto = await _picker.pickImage(source: source);
    setState(() {
      _profilePhoto = File(_pickedPhoto!.path);
      Navigator.of(context).pop();
    });
  }


  @override
  void initState() {
    super.initState();
    _controllerUsername = TextEditingController();
    //_controllerEmail = TextEditingController();
    //_checkControllers();
  }

  @override
  void dispose() {
    _controllerUsername.dispose();
    //_controllerEmail.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    FUserModel _userModel = Provider.of<FUserModel>(context, listen: false);
    _controllerUsername.text = _userModel.user!.userName.toString();
    print("Profil sayfasındaki user değerleri :\n ${_userModel.user.toString()}");

    return Scaffold(
      appBar: AppBar(title: Text("Profil"),
        actions: <Widget>[
        TextButton(
          onPressed: () => _askPermissionForLogOut(context),
          child: Text(
            "Çıkış",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(

            children: <Widget>[

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {

                    showModalBottomSheet(context: context, builder: (context){
                      return Container(
                        height: 160,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.camera),
                              title: Text("Kameradan Aç"),
                              onTap: () {
                                _addNewPhoto(ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.image),
                              title: Text("Galeriden Seç"),
                              onTap: () {
                                _addNewPhoto(ImageSource.gallery);
                              },
                            ),
                          ],
                        ),
                      );
                    });
                  },
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.white,
                    backgroundImage: _profilePhoto == null
                        ? NetworkImage(_userModel.user!.profileURL.toString())
                        : FileImage(File(_profilePhoto!.path)) as ImageProvider,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _userModel.user?.email,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Emailiniz",
                    hintText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerUsername,
                  decoration: InputDecoration(
                    labelText: "Kullanıcı Adı",
                    hintText: "Kullanıcı Adı",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SocialLoginButton(
                  buttonText: "Değişiklikleri Kaydet",
                  onPressed: () {
                    _updateUsername(context);
                    _updateProfilePhoto(context);
                  },
                ),
              ),

            ],

          ),
        ),
      ),
    );
  }

  Future<bool?> _logOut(BuildContext context) async {
    final  _userModel = Provider.of<FUserModel>(context, listen: false);
    bool? result = await _userModel.signOut();
    return result;
  }

  Future _askPermissionForLogOut(BuildContext context) async {
    final result = await PlatformSpecificAlertDialog(
      label: "Emin misiniz?",
      description: "Çıkış yapmak istediğinize emin misiniz?",
      mainButtonLabel: "Evet",
      cancelButtonLabel: "Vazgeç",
    ).show(context);

    if(result==true) {
      _logOut(context);
    }
  }

  void _updateUsername(BuildContext context) async {
    final _userModel = Provider.of<FUserModel>(context, listen: false);

    if(_userModel.user!.userName! != _controllerUsername.text) {
     var updateResult = await _userModel.updateUserName(_userModel.user!.userID,
          _controllerUsername.text);

      if(updateResult == true) {
        //_userModel.user!.userName = _controllerUsername.text;
        PlatformSpecificAlertDialog(
          label: "Başarılı",
          description: "Kullanıcı adınız değiştirildi",
          mainButtonLabel: "Tamam",
        ).show(context);
      } else {
        _controllerUsername.text = _userModel.user!.userName.toString();
        PlatformSpecificAlertDialog(
          label: "Hata",
          description: "Bu kullanıcı adı zaten kullanılıyor",
          mainButtonLabel: "Tamam",
        ).show(context);
      }
    }
  }

  void _updateProfilePhoto(BuildContext context) async {
    final _userModel = Provider.of<FUserModel>(context, listen: false);

    if(_profilePhoto != null ) {
       var url = await _userModel.uploadFile(_userModel.user!.userID, "profile_photo",
           _profilePhoto!);

      if(url != null) {
        PlatformSpecificAlertDialog(
          label: "Başarılı",
          description: "Profil fotoğrafınız güncellendi",
          mainButtonLabel: "Tamam",
        ).show(context);
      }
    }
  }


}