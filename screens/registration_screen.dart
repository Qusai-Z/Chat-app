import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chat_mobile/screens/chat_screen.dart';
import 'package:chat_mobile/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/my_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class RegistrationScreen extends StatefulWidget {
  static const String ScreenRoute = 'register';
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late String my_email, my_password;

  bool isLoading = false;
  final _auth = FirebaseAuth.instance;
  late File pickedFile;
  late File file;

  var image_Picker = ImagePicker();

  UploadImage() async {
    var image_Picked =
        await image_Picker.pickImage(source: ImageSource.gallery);
    if (image_Picked != null) {
      file = File(image_Picked.path);
      var image_name = image_Picked.path;
      print(image_name);
      final f_storage = await FirebaseStorage.instance.ref('imgs/$image_name');

      f_storage.putFile(file);

      var url = await f_storage.getDownloadURL();

      print('URL : $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              SizedBox(
                height: 90,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        UploadImage();
                      },
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey[100],
                        child: Text(
                          'Choose image',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      my_email = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your Email',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orange,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      my_password = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orange,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  MyButton(
                    color: Colors.blue[800]!,
                    title: 'register',
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        final user = await _auth.createUserWithEmailAndPassword(
                            email: my_email, password: my_password);

                        Navigator.pushNamed(context, SignInScreen.ScreenRoute);
                      } catch (e) {
                        print(e);
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
