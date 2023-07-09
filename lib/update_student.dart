import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/student.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class UpdateStudent extends StatelessWidget {
  final Student student;
  final TextEditingController rollController=TextEditingController();
  final TextEditingController nameController=TextEditingController();
  final TextEditingController marksController=TextEditingController();
  final FocusNode focusNode=FocusNode();

  UpdateStudent({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    rollController.text='${student.rollno}';
    nameController.text='${student.name}';
    marksController.text='${student.marks}';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Student'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            getMyfield(focusNode: focusNode, hintText: 'Rollno', textInputType: TextInputType.number, controller: rollController),
            getMyfield(hintText: 'Name', controller: nameController),
            getMyfield(hintText: 'Marks', textInputType: TextInputType.number, controller: marksController),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: (){
                  Student updateStudent=Student(
                      id: student.id,
                      rollno: int.parse(rollController.text),
                      name: nameController.text,
                      marks: double.parse(marksController.text),
                  );
                  final collectionReference=
                      FirebaseFirestore.instance.collection('students');
                  collectionReference
                      .doc(updateStudent.id)
                      .update(updateStudent.toJson())
                      .whenComplete((){
                    //log('Student updated');
                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>HomePage()));
                      });
                }, child: const Text('Update')),
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
}


