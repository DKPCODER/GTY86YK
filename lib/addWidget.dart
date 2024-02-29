import 'dart:ffi';

import 'package:assgn1/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddWidget extends StatefulWidget {
  AddWidget({super.key});

  @override
  State<AddWidget> createState() => _AddWidgetState();
}

class _AddWidgetState extends State<AddWidget> {
  HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(120, 160, 131, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(65, 75, 68, 1),
        title: Text('Add Widget', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(() => Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                CheckboxListTile(
                  title: Text('Add TextBox',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                  value: controller.checkbox1.value,
                  onChanged: (value) {
                    controller.text(value);
                  },
                ),
                CheckboxListTile(
                  title: Text('Add ImageWidget',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                  value: controller.checkbox2.value,
                  onChanged: (value) {
                    controller.imagewidget(value);
                  },
                ),
                CheckboxListTile(
                  title: Text('Add SaveButton',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                  value: controller.checkbox3.value,
                  onChanged: (value) {
                    controller.savebutton(value);
                  },
                ),
                SizedBox(height: size.height * 0.4),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue, width: 2)),
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                    child: Text("Add",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
