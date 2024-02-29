import 'dart:io';
import 'package:assgn1/addWidget.dart';
import 'package:assgn1/controller/home_controller.dart';
import 'package:assgn1/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController controller = Get.put(HomeController());

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        controller.image.value = File(pickedImage.path);
      });
    }
  }

  var data;
  @override
  void initState() {
    data = controller.fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color.fromRGBO(120, 160, 131, 1),
        // rgb(120, 160, 131)
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(65, 75, 68, 1),
          title: Text('Assignment',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                controller.dispose();
                Get.offAll(LoginPage());
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.exit_to_app, color: Colors.white, size: 30),
            ),
          ],
          leading: SizedBox(),
        ),
        body: Obx(() {
          if (controller.isloading.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text('Your Image',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      SizedBox(height: 20),
                      controller.checkbox2.value == true ||
                              controller.data.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor:
                                          const Color.fromRGBO(7, 15, 43, 1),
                                      title: Text('Choose Image',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.image_rounded,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                GestureDetector(
                                                  child: Text('Gallery',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                  onTap: () {
                                                    _pickImage(
                                                        ImageSource.gallery);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(Icons.camera_alt,
                                                    color: Colors.white,
                                                    size: 30),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                GestureDetector(
                                                  child: Text('Camera',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                  onTap: () {
                                                    _pickImage(
                                                        ImageSource.camera);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                  width: size.width * 0.7,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: controller.image.value.path != ''
                                        ? Image.file(
                                            controller.image.value,
                                            fit: BoxFit.fill,
                                          )
                                        : controller.networkImage.value == ''
                                            ? Icon(
                                                Icons.camera_alt,
                                                size: 50,
                                                color: Colors.white,
                                              )
                                            : Image.network(
                                                controller.networkImage.value,
                                                fit: BoxFit.fill,
                                                frameBuilder: (
                                                  BuildContext context,
                                                  Widget child,
                                                  int? frame,
                                                  bool wasSynchronouslyLoaded,
                                                ) {
                                                  if (wasSynchronouslyLoaded)
                                                    return child;
                                                  return AnimatedOpacity(
                                                    opacity:
                                                        frame == null ? 0 : 1,
                                                    duration:
                                                        Duration(seconds: 5),
                                                    curve: Curves.easeOut,
                                                    child: child,
                                                  );
                                                },
                                                loadingBuilder: (
                                                  BuildContext context,
                                                  Widget child,
                                                  ImageChunkEvent?
                                                      loadingProgress,
                                                ) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes!
                                                          : null,
                                                    ),
                                                  );
                                                },
                                                errorBuilder: (
                                                  BuildContext context,
                                                  Object error,
                                                  StackTrace? stackTrace,
                                                ) {
                                                  return Text(
                                                      'Failed to load image');
                                                },
                                              ),
                                  )),
                            )
                          : SizedBox(),
                      SizedBox(height: 20),
                      controller.image.value.path != '' ||
                              controller.networkImage.value != '' ||
                              controller.data.isNotEmpty
                          ? InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor:
                                          const Color.fromRGBO(7, 15, 43, 1),
                                      title: Text('Choose Image',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.image_rounded,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                GestureDetector(
                                                  child: Text('Gallery',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                  onTap: () {
                                                    _pickImage(
                                                        ImageSource.gallery);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(Icons.camera_alt,
                                                    color: Colors.white,
                                                    size: 30),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                GestureDetector(
                                                  child: Text('Camera',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                  onTap: () {
                                                    _pickImage(
                                                        ImageSource.camera);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text("Change",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            )
                          : SizedBox(),
                      SizedBox(height: 20),
                      // Container(
                      //   child: Text('Your Title',
                      //       style: TextStyle(
                      //         fontSize: 20,
                      //         color: Colors.white,
                      //         fontWeight: FontWeight.bold,
                      //       )),
                      // ),
                      SizedBox(height: 20),
                      controller.checkbox1.value || controller.data.isNotEmpty
                          ? Container(
                              height: 60,
                              width: size.width * 0.8,
                              child: TextField(
                                style: TextStyle(color: Colors.white),
                                controller: controller.Textbox.value,
                                decoration: InputDecoration(
                                  hintText: 'Enter text',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2),
                                  ),
                                  label: Text('Title'),
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 1),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                      SizedBox(height: size.height * 0.1),
                      controller.checkbox3.value || controller.data.isNotEmpty
                          ? InkWell(
                              onTap: () {
                                if (controller.checkbox1.value == true ||
                                    controller.checkbox2.value == true) {
                                  if (controller.image.value.path != '' ||
                                      controller.networkImage.value != '' ||
                                      data != {} ||
                                      controller.Textbox.value.text != '') {
                                    controller
                                        .createUser(controller.image.value);
                                  } else {
                                    Get.snackbar(
                                        'Error', 'Please fill all the fields');
                                  }
                                } else {
                                  Get.snackbar(
                                      'Error', 'Select atleast one widget');
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 80, vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 1,
                                  ),
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: controller.Saving.value != true
                                    ? Text(
                                        "Save",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18,
                                        ),
                                      )
                                    : CircularProgressIndicator(
                                        color: Colors.blue,
                                      ),
                              ),
                            )
                          : SizedBox(),
                      InkWell(
                        onTap: () {
                          Get.to(AddWidget());
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          padding: EdgeInsets.symmetric(
                              horizontal: 60, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Add Widget",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      )
                    ]),
              ),
            );
          }
        }));
  }
}
