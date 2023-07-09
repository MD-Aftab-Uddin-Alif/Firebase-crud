import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/add_student.dart';
import 'package:firebase_crud/student.dart';
import 'package:firebase_crud/update_student.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final CollectionReference _reference=FirebaseFirestore.instance.collection('students');
  // List<Student> students=[
  //   Student(id: 'id', rollno: 1, name: 'Name 1', marks: 32),
  //   Student(id: 'id', rollno: 1, name: 'Name 2', marks: 36),
  //   Student(id: 'id', rollno: 1, name: 'Name 3', marks: 82),
  // ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase CRUD'),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _reference.get(),
          builder: (context, snapshot){
          if(snapshot.hasError){
            return const Center(
              child: Text('Something went wrong.'),
            );
          }
          if(snapshot.hasData){
            QuerySnapshot querySnapshot=snapshot.data!;
            List<QueryDocumentSnapshot>documents=querySnapshot.docs;
            List<Student>students=documents.map((e) => Student(id: e['id'], rollno: e['rollno'], name: e['name'], marks: e['marks'])).toList();
            return _getBody(students);
          }
          else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          },
          //child: _getBody()
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ((){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context)=>const AddStudent(),
            ));
        }),
        child: const Icon(Icons.add),
      ),
    );
  }

 Widget _getBody(students) {
    return students.isEmpty?
    Center(
      child: Text('No Student Yet\nClick * to start adding',
        textAlign: TextAlign.center,
      ),
    ):ListView.builder(
        itemCount:students.length,
        itemBuilder: (context, index)=>Card(
          color: students[index].marks<33
              ?Colors.red.shade100
              :students[index].marks<65
              ?Colors.yellow.shade100
              :Colors.green.shade100,
          child: ListTile(
            title: Text(students[index].name),
            subtitle: Text('Rollno: ${students[index].rollno}'),
            leading: CircleAvatar(
              radius: 25,
              child: Text('${students[index].marks}'),
            ),
            trailing: SizedBox(
              width: 60,
              child: Row(
                children: [
                  InkWell(child: const Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context)=>UpdateStudent(student: students[index])));
                    },
                  ),
                  InkWell(child: const Icon(
                    Icons.delete,
                  ),
                    onTap: (){
                      _reference.doc(students[index].id).delete();
                      Navigator.pushReplacement(
                          context,
                        MaterialPageRoute(
                            builder: (context)=>HomePage())
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
 }
}
