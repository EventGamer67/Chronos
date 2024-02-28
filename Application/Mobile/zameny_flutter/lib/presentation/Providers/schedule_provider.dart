import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bl;
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/Services/Models/group.dart';
import 'package:zameny_flutter/Services/tools.dart';
import 'package:zameny_flutter/presentation/Providers/bloc/schedule_bloc.dart';
import 'package:zameny_flutter/presentation/Widgets/CourseTile.dart';

class ScheduleProvider extends ChangeNotifier {
  int groupIDSeek = -1;
  int teacherIDSeek = -1;
  int cabinetIDSeek = -1;

  DateTime navigationDate = DateTime.now();
  DateTime septemberFirst = DateTime(2023, 9, 1); // 1 сентября
  int currentWeek = 1;
  int todayWeek = 1;

  ScheduleProvider(BuildContext context) {
    groupIDSeek = GetIt.I.get<Data>().seekGroup ?? -1;
    teacherIDSeek = GetIt.I.get<Data>().teacherGroup ?? -1;

    currentWeek = ((navigationDate.difference(septemberFirst).inDays +
                septemberFirst.weekday) ~/
            7) +
        1;

    todayWeek = currentWeek;
  }

  void toggleWeek(int days, BuildContext context) {
    currentWeek += days;
    if (currentWeek < 1) {
      currentWeek = 1;
    } else {
      navigationDate = navigationDate.add(Duration(days: days > 0 ? 7 : -7));
    }
    dateSwitched(context);
  }

  DateTime getStartOfWeek(DateTime week) {
    DateTime monday = week.subtract(Duration(days: week.weekday - 1));
    return DateTime(monday.year, monday.month, monday.day);
  }

  DateTime getEndOfWeek(DateTime week) {
    DateTime sunday = week
        .subtract(Duration(days: week.weekday - 1))
        .add(const Duration(days: 6));
    return DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);
  }

  void groupSelected(int groupID, BuildContext context) {
    final data = GetIt.I.get<Data>();
    GetIt.I.get<SharedPreferences>().setInt('SelectedGroup', groupID);
    groupIDSeek = groupID;
    data.seekGroup = groupID;
    data.latestSearch = CourseTileType.group;
    loadWeekSchedule(context);
  }

  void loadWeekSchedule(BuildContext context) async {
    DateTime monday =
        navigationDate.subtract(Duration(days: navigationDate.weekday - 1));
    DateTime sunday = monday.add(const Duration(days: 6));

    // Устанавливаем время для понедельника и воскресенья
    DateTime startOfWeek = DateTime(monday.year, monday.month, monday.day);
    DateTime endOfWeek =
        DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);

    context.read<ScheduleBloc>().add(FetchData(
        groupID: groupIDSeek,
        dateStart: startOfWeek,
        dateEnd: endOfWeek,
        context: context));
    notifyListeners();
  }

  void teacherSelected(int teacherID, BuildContext context) {
    final data = GetIt.I.get<Data>();
    GetIt.I.get<SharedPreferences>().setInt('SelectedTeacher', teacherID);
    teacherIDSeek = teacherID;
    data.teacherGroup = teacherID;
    data.latestSearch = CourseTileType.teacher;
    loadWeekTeahcerSchedule(context);
  }

  void cabinetSelected(int cabinetID, BuildContext context) {
    final data = GetIt.I.get<Data>();
    GetIt.I.get<SharedPreferences>().setInt('SelectedCabinet', cabinetID);
    cabinetIDSeek = cabinetID;
    data.seekCabinet = cabinetID;
    data.latestSearch = CourseTileType.cabinet;
    loadCabinetWeekSchedule(context);
  }

  void loadCabinetWeekSchedule(BuildContext context) async {
    DateTime monday =
        navigationDate.subtract(Duration(days: navigationDate.weekday - 1));
    DateTime sunday = monday.add(const Duration(days: 6));

    DateTime startOfWeek = DateTime(monday.year, monday.month, monday.day);
    DateTime endOfWeek =
        DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);

    context.read<ScheduleBloc>().add(LoadCabinetWeek(
          cabinetID: cabinetIDSeek,
          dateStart: startOfWeek,
          dateEnd: endOfWeek,
        ));
    notifyListeners();
  }

  void loadWeekTeahcerSchedule(BuildContext context) async {
    DateTime monday =
        navigationDate.subtract(Duration(days: navigationDate.weekday - 1));
    DateTime sunday = monday.add(const Duration(days: 6));

    DateTime startOfWeek = DateTime(monday.year, monday.month, monday.day);
    DateTime endOfWeek =
        DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);

    context.read<ScheduleBloc>().add(LoadTeacherWeek(
          teacherID: teacherIDSeek,
          dateStart: startOfWeek,
          dateEnd: endOfWeek,
        ));
    notifyListeners();
  }

  void dateSwitched(context) async {
    final Data dat = GetIt.I.get<Data>();
    if (dat.latestSearch == CourseTileType.teacher) {
      teacherSelected(dat.teacherGroup!, context);
    }
    if (dat.latestSearch == CourseTileType.cabinet) {
      cabinetSelected(dat.seekCabinet!, context);
    }
    if (dat.latestSearch == CourseTileType.group) {
      groupSelected(dat.seekGroup!, context);
    }
    notifyListeners();
  }

  String searchDiscribtion() {
    final Data dat = GetIt.I.get<Data>();
    if (dat.latestSearch == CourseTileType.teacher) {
      Teacher? teacher = getTeacherById(dat.teacherGroup!);
      return teacher == null ? "Error" : teacher.name;
    }
    if (dat.latestSearch == CourseTileType.cabinet) {
      Cabinet? cabinet = getCabinetById(dat.seekCabinet!);
      return cabinet == null ? "Error" : cabinet.name;
    }
    if (dat.latestSearch == CourseTileType.group) {
      Group? group = getGroupById(dat.seekGroup!);
      return group == null ? "Error" : group.name;
    }
    return "Not found";
  }

  String getSearchTypeNamed() {
    final Data dat = GetIt.I.get<Data>();
    if (dat.latestSearch == CourseTileType.teacher) {
      return "Препод";
    }
    if (dat.latestSearch == CourseTileType.cabinet) {
      return "Кабинет";
    }
    if (dat.latestSearch == CourseTileType.group) {
      return "Группа";
    }
    return "Not found";
  }
}