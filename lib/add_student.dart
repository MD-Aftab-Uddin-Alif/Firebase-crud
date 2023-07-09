import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crud/home_page.dart';
import 'package:firebase_crud/student.dart';
import 'package:flutter/material.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final TextEditingController rollController=TextEditingController();
  final TextEditingController nameController=TextEditingController();
  final TextEditingController marksController=TextEditingController();
  final FocusNode focusNode=FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            getMyfield(focusNode: focusNode, hintText: 'Rollno', textInputType: TextInputType.number, controller: rollController),
            getMyfield(hintText: 'Name', controller: nameController),
            getMyfield(hintText: 'Marks', textInputType: TextInputType.number, controller: marksController),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: (){
                  Student student=Student(
                      rollno: int.parse(rollController.text),
                      name: nameController.text,
                      marks: double.parse(marksController.text),
                  );
                  addStudentAndNavigateToHome(student, context);

                }, child: const Text('Add')),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    ),
                    onPressed: (){
                      rollController.text='';
                      nameController.text='';
                      marksController.text='';
                      focusNode.requestFocus();
                }, child: const Text('Reset')),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget getMyfield({
    required String hintText,
    TextInputType textInputType=TextInputType.name,
    required TextEditingController controller,
    FocusNode? focusNode
  }){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
          hintText: 'Enter $hintText',
          labelText: hintText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
      ),
    );
  }

  void addStudentAndNavigateToHome(Student student, BuildContext context) {
    final studentRef=FirebaseFirestore.instance.collection('students').doc();
    student.id=studentRef.id;
    final data=student.toJson();
    studentRef.set(data).whenComplete((){
      log('User inserted.');
      Navigator.pushAndRemoveUntil(
          context,
        MaterialPageRoute(
            builder: (context)=>HomePage(),
        ),
          (route)=>false,
      );
    });
  }
}
