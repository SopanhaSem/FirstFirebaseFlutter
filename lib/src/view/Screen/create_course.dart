import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_setup/src/widget/textfield_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddEditCourseScreen extends StatefulWidget {
  AddEditCourseScreen({super.key, this.courseData, this.refId});
  Map? courseData;
  String? refId;

  @override
  State<AddEditCourseScreen> createState() => _AddEditCourseScreenState();
}

class _AddEditCourseScreenState extends State<AddEditCourseScreen> {
  File? imagFile;

  CollectionReference dataRef =
      FirebaseFirestore.instance.collection("Courses");
  TextEditingController courseNameController = TextEditingController();
  TextEditingController coursePriceController = TextEditingController();
  TextEditingController courseImageLinkController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  initData() {
    setState(() {
      courseNameController.text = widget.courseData!['course_name'];
      coursePriceController.text = widget.courseData!['price'].toString();
      courseImageLinkController.text = widget.courseData!['image'];
      userNameController.text = widget.courseData!['user_name'];
    });
  }

  clearData() {
    setState(() {
      courseNameController.text = '';
      coursePriceController.text = '';
      courseImageLinkController.text = '';
      userNameController.text = '';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.courseData == null) {
      clearData();
    } else {
      initData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Course'),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Course Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextFielWidget(
              hintText: 'Course name',
              controller: courseNameController,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Course Price',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextFielWidget(
              hintText: 'Course price',
              controller: coursePriceController,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Course Image',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                TextFielWidget(
                  isReadonly: true,
                  width: 300,
                  hintText: 'Link Image',
                  controller: courseImageLinkController,
                  onChanged: (link) {
                    setState(() {
                      courseImageLinkController.text = link;
                    });
                  },
                ),
                FloatingActionButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: SizedBox(
                              height: 140,
                              child: Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      openCamera();
                                    },
                                    title: const Text('Camera'),
                                  ),
                                  const Divider(),
                                  ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      openGallary();
                                    },
                                    title: const Text('Gallary'),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Icon(Icons.image_rounded))
              ],
            ),
            if (courseImageLinkController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(courseImageLinkController.text))),
                ),
              ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'User Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextFielWidget(
              hintText: 'User Name',
              controller: userNameController,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () async {
            if (widget.courseData == null) {
              await dataRef.add({
                'id': DateTime.now().microsecondsSinceEpoch,
                'course_name': courseNameController.text,
                'date': DateTime.now(),
                'price': coursePriceController.text,
                'image': courseImageLinkController.text,
                'user_name': userNameController.text
              }).whenComplete(() => Navigator.pop(context));
            } else {
              await dataRef.doc(widget.refId).set({
                'id': widget.courseData!['id'],
                'course_name': courseNameController.text,
                'date': DateTime.now(),
                'price': double.parse(coursePriceController.text),
                'image': courseImageLinkController.text,
                'user_name': userNameController.text
              }).whenComplete(() => Navigator.pop(context));
            }
          },
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueAccent),
            child: Center(
              child: Text(
                'Create'.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getDownloadImage() async {
    final storageRef = FirebaseStorage.instance.ref();
    const mainPath = 'images';
    String imageName = DateTime.now().microsecondsSinceEpoch.toString();
    // Upload Image
    storageRef
        .child(mainPath)
        .child("/$imageName.png")
        .putFile(File(imagFile!.path))
        .then((p0) async {
      FirebaseStorage.instance
          .ref()
          .child(mainPath)
          .child("$imageName.png")
          .getDownloadURL()
          .then((value) {
        setState(() {
          courseImageLinkController.text = value;
        });
      });
    });
  }

  void openGallary() async {
    var getImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imagFile = File(getImage!.path);
    });
    getDownloadImage();
  }

  void openCamera() async {
    var getImage = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      imagFile = File(getImage!.path);
    });
    getDownloadImage();
  }
}
