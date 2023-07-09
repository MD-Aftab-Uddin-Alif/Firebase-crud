// To parse this JSON data, do
//
//     final student = studentFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Student studentFromJson(String str) => Student.fromJson(json.decode(str));

String studentToJson(Student data) => json.encode(data.toJson());

class Student {
  String? id;
  final int rollno;
  final String name;
  final num marks;

  Student({
    this.id,
    required this.rollno,
    required this.name,
    required this.marks,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    id: json["id"],
    rollno: json["rollno"],
    name: json["name"],
    marks: json["marks"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "rollno": rollno,
    "name": name,
    "marks": marks,
  };
}
