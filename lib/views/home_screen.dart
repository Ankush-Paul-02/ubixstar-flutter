import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'my_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> selectedOptions = [];
  bool showWidgets = false;
  TextEditingController textEditingController = TextEditingController();
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  Widget _buildWidgetForOption(String option) {
    if (option == 'Text Field') {
      return TextFormField(
        controller: textEditingController,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 3.w),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide(
              color: Colors.amber,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.amber,
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.amber,
              width: 2.0,
            ),
          ),
          labelText: 'Enter Text',
          labelStyle: const TextStyle(color: Colors.black),
        ),
      )
          .pSymmetric(h: 3.w)
          .box
          .margin(EdgeInsets.symmetric(vertical: 2.5.h))
          .make();
    } else if (option == 'Image') {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 2.5.h),
        width: 100.w,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.amber, width: 2.0),
        ),
        child: selectedImage != null
            ? Image.file(selectedImage!, fit: BoxFit.cover)
            : 'Upload Image'.text.semiBold.make().centered().onTap(() async {
                final pickedImage =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  setState(() {
                    selectedImage = File(pickedImage.path);
                  });
                }
              }),
      ).pSymmetric(h: 3.w);
    } else if (option == 'Save') {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
        ),
        child: 'Save'.text.black.semiBold.make(),
        onPressed: () {
          if (selectedOptions.length == 1) {
            VxToast.show(context,
                msg: 'At least one widget to be selected!',
                position: VxToastPosition.center);
          } else {
            _uploadTextImage();
          }
        },
      ).box.size(100.w, 8.h).make().pSymmetric(h: 3.w);
    }
    return const SizedBox.shrink();
  }

  //! Upload Image or text
  void _uploadTextImage() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;

      DocumentReference docRef = firestore.collection('user').doc();

      await docRef.set({
        'text': textEditingController.text,
      });

      if (selectedImage != null) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        firebase_storage.Reference ref =
            storage.ref().child('images/$fileName');
        await ref.putFile(selectedImage!);
        String downloadURL = await ref.getDownloadURL();

        await docRef.update({
          'imageURL': downloadURL,
        });
      }
      VxToast.show(context, msg: 'Uploaded successfully');
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget;
    if (showWidgets && selectedOptions.isNotEmpty) {
      bodyWidget = Column(
        children: selectedOptions
            .map((option) => _buildWidgetForOption(option))
            .toList(),
      );
    } else {
      bodyWidget = 'No widgets added'.text.semiBold.size(20).make().centered();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: 'Widgets'.text.make().centered(),
      ),
      body: bodyWidget.box.make(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        shape: const CircleBorder(),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => MyBottomSheet(
              selectedOptions: selectedOptions,
              onChanged: (options) {
                setState(() {
                  selectedOptions = options;
                });
              },
              onImportPressed: () {
                setState(() {
                  showWidgets = true;
                });
              },
            ),
          );
        },
        child: const Icon(
          Icons.widgets,
          color: Colors.black,
        ),
      ),
    );
  }
}
