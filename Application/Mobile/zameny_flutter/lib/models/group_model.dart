import 'dart:convert';

import 'package:zameny_flutter/models/lesson_model.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/schedule_turbo_search.dart';

class Group extends SearchItem {
  Group({required this.id, required this.name, required this.department});

  int id;
  String name;
  int department;
  List<Lesson> lessons = [];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Group.fromMap(final Map<String, dynamic> map) {
    return Group(
      id: map['id'] as int,
      name: map['name'] as String,
      department: map['department'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Group.fromJson(final String source) =>
      Group.fromMap(json.decode(source) as Map<String, dynamic>);
}
