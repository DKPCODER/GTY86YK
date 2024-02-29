import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxMap data = {}.obs;
  Rx<File> image = File('').obs;
  RxString networkImage = ''.obs;
  RxBool checkbox1 = false.obs;
  RxBool checkbox2 = false.obs;
  RxBool checkbox3 = false.obs;
  void text(value) => checkbox1.value = value;
  void imagewidget(value) => checkbox2.value = value;
  void savebutton(value) => checkbox3.value = value;
  RxBool Saving = false.obs;
  Rx<TextEditingController> Textbox = TextEditingController().obs;
  Future<void> createUser(File file) async {
    Saving.value = true;
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final ext = file.path.split('.').last;
    log('Extension: $ext');
    final ref =
        storage.ref().child('profile_pictures/${auth.currentUser!.email}.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    String image = await ref.getDownloadURL();
    log('txt: ${Textbox.value.text}');
    await firestore.collection('user').doc(auth.currentUser!.email).set({
      'text': Textbox.value.text,
      'image': image,
    });
    Saving.value = false;
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      content: Text("Data Saved Successfully"),
    ));
  }

  RxBool isloading = false.obs;
  // RxMap data = {}.obs;
  Future<Map<String, dynamic>> fetchData() async {
    isloading.value = true;
    log(auth.currentUser!.email.toString());
    final doc =
        await firestore.collection('user').doc(auth.currentUser!.email).get();
    if (doc.exists) {
      data.value = doc.data() as Map<String, dynamic>;
      isloading.value = false;
      // image.value = File(data['image']);
      networkImage.value = data['image'];
      Textbox.value.text = data['text'];
      if (data != {}) {
        checkbox1.value = true;
        checkbox2.value = true;
        checkbox3.value = true;
      }
      // data.value = doc.data() as Map<String, dynamic>;
      return doc.data() as Map<String, dynamic>;
    } else {
      print('No data found');
      isloading.value = false;
      data.value = {};
      print('Data: $data');
      log(checkbox1.value.toString());
      log(checkbox2.value.toString());
      log(checkbox3.value.toString());
      return {};
    }
  }
}
