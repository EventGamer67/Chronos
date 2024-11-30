import 'dart:convert';

class Lesson {
  int id;
  int number;
  int group;
  DateTime date;
  int course;
  int teacher;
  int cabinet;

  Lesson({
    required this.id,
    required this.number,
    required this.group,
    required this.date,
    required this.course,
    required this.teacher,
    required this.cabinet,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'group': group,
      'date': date,
      'course': course,
      'teacher': teacher,
      'cabinet': cabinet,
    };
  }

  factory Lesson.fromMap(final Map<String, dynamic> map) {
    return Lesson(
      id: map['id'] as int,
      number: map['number'] as int,
      group: map['group'] as int,
      date: DateTime.parse(map['date']),
      course: map['course'] as int,
      teacher: map['teacher'] as int,
      cabinet: map['cabinet'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Lesson.fromJson(final String source) =>
      Lesson.fromMap(json.decode(source) as Map<String, dynamic>);

  Lesson copyWith({
    final int? id,
    final int? number,
    final int? group,
    final DateTime? date,
    final int? course,
    final int? teacher,
    final int? cabinet,
  }) {
    return Lesson(
      id: id ?? this.id,
      number: number ?? this.number,
      group: group ?? this.group,
      date: date ?? this.date,
      course: course ?? this.course,
      teacher: teacher ?? this.teacher,
      cabinet: cabinet ?? this.cabinet,
    );
  }
}