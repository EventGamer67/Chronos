import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zameny_flutter/domain/Providers/adaptive.dart';
import 'package:zameny_flutter/domain/Services/Data.dart';
import 'package:zameny_flutter/domain/Services/tools.dart';
import 'package:zameny_flutter/domain/Providers/schedule_provider.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/CourseTile.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/dayschedule_header.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:zameny_flutter/domain/Models/models.dart';

class DayScheduleWidget extends StatefulWidget {
  final DateTime startDate;
  final int currentDay;
  final int currentWeek;
  final int todayWeek;
  final Data data;
  final Function refresh;
  final int day;
  final List<Zamena> dayZamenas;
  final List<Lesson> lessons;

  const DayScheduleWidget(
      {super.key,
      required this.day,
      required this.refresh,
      required this.dayZamenas,
      required this.lessons,
      required this.startDate,
      required this.currentDay,
      required this.currentWeek,
      required this.todayWeek,
      required this.data});

  @override
  State<DayScheduleWidget> createState() => _DayScheduleWidgetState();
}

class _DayScheduleWidgetState extends State<DayScheduleWidget> {
  bool obed = false;

  toggleObed() {
    obed = !obed;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      if (widget.day == widget.currentDay &&
          widget.currentWeek == widget.todayWeek && !Adaptive.isDesktop(context)) {
        Scrollable.ensureVisible(context,
            duration: const Duration(milliseconds: 500), alignment: 0.5);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isToday = (widget.day == widget.currentDay &&
            widget.todayWeek == widget.currentWeek
        ? true
        : false);
    //ScheduleProvider provider = context.watch<ScheduleProvider>();
    SearchType type = context.watch<ScheduleProvider>().searchType;
    bool fullSwap = false;
    int searchDay = widget.startDate.add(Duration(days: widget.day - 1)).day;
    int searchMonth =
        widget.startDate.add(Duration(days: widget.day - 1)).month;
    int searchYear = widget.startDate.add(Duration(days: widget.day - 1)).year;
    if (widget.lessons.isNotEmpty) {
      if (type == SearchType.group) {
        fullSwap = GetIt.I
            .get<Data>()
            .zamenasFull
            .where((element) =>
                (element.group == widget.lessons[0].group) &&
                (element.date.day == searchDay) &&
                (element.date.month == searchMonth) &&
                (element.date.year == searchYear))
            .toSet()
            .isNotEmpty;
      }
    }
    List<Widget> tiles = newMethod(fullSwap, type, searchYear, searchMonth,
        searchDay, GetIt.I.get<Data>().seekGroup!);
    List<CourseTile> courseTiles = [];
    for (Widget i in tiles) {
      if (i is CourseTile) {
        courseTiles.add(i);
      }
    }
    bool needObedSwitch = courseTiles.any((element) =>
        element.lesson.number == 4 ||
        element.lesson.number == 5 ||
        element.lesson.number == 6 ||
        element.lesson.number == 7);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: isToday
          ? BoxDecoration(
              border: Border.all(
                  strokeAlign: BorderSide.strokeAlignOutside,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(20)))
          : null,
      child: Column(
        children: [
          Column(
            children: [
              DayScheduleHeader(
                  day: widget.day,
                  startDate: widget.startDate,
                  isToday: isToday,
                  fullSwap: fullSwap),
              //isToday
              courseTiles.isNotEmpty && needObedSwitch && (widget.day != 6)
                  ? Row(
                      children: [
                        SizedBox(
                          height: 38,
                          child: FittedBox(
                            child: Switch(
                                value: obed,
                                onChanged: (value) => toggleObed()),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Без обеда",
                          style: TextStyle(
                              fontFamily: 'Ubuntu',
                              color: Theme.of(context)
                                  .colorScheme
                                  .inverseSurface
                                  .withOpacity(0.6)),
                        )
                      ],
                    )
                  : Adaptive.isDesktop(context) ? const SizedBox(height: 38,) : const SizedBox()
            ],
          ),
          courseTiles.isNotEmpty
              ? Column(children: courseTiles)
              : Container(
                  height: 110,
                  margin: const EdgeInsets.only(top: 20, bottom: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.transparent,
                      border: DashedBorder.all(
                          dashLength: 10,
                          width: 1,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.6))),
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                          child: Text(
                        "Нет пар",
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 20,
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
                      ))),
                )
        ],
      ),
    );
  }

  List<Widget> newMethod(bool fullSwap, SearchType type, int todayYear,
      int todayMonth, int todayDay, int group) {
    Data data = GetIt.I.get<Data>();

    Holiday? holiday = data.holidays
        .where((element) =>
            element.date == DateTime(todayYear, todayMonth, todayDay))
        .firstOrNull;
    if (holiday != null) {
      return [
        Container(
          height: 110,
          margin: const EdgeInsets.only(top: 20, bottom: 10),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Colors.transparent,
              border: DashedBorder.all(
                  dashLength: 10,
                  width: 1,
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.6))),
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                  child: Text(
                holiday.name,
                style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.inversePrimary),
              ))),
        )
      ];
    }
    Liquidation? liquidation = data.liquidations
        .where((element) =>
            DateTime(todayYear, todayMonth, todayDay) == element.date &&
            element.group == group)
        .firstOrNull;

    if (liquidation != null) {
      return [
        Container(
          height: 110,
          margin: const EdgeInsets.only(top: 20, bottom: 10),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Colors.transparent,
              border: DashedBorder.all(
                  dashLength: 10,
                  width: 1,
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.6))),
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                  child: Text(
                "Ликвидация задолженностей",
                style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.inversePrimary),
              ))),
        )
      ];
    }
    return widget.data.timings.map((para) {
      if (fullSwap) {
        // Lesson? removedPara = lessons
        //     .where((element) => element.number == para.number)
        //     .firstOrNull;
        // if (removedPara != null) {
        //   return const SizedBox();
        // }
        Zamena? zamena = widget.dayZamenas
            .where((element) => element.lessonTimingsID == para.number)
            .firstOrNull;
        if (zamena != null) {
          final course = getCourseById(zamena.courseID) ??
              Course(id: -1, name: "err2", color: "100,0,0,0");
          return CourseTile(
            short: false,
            type: type,
            obedTime: obed,
            course: course,
            refresh: widget.refresh,
            swaped: null,
            saturdayTime: widget.day == 6,
            lesson: Lesson(
                id: -1,
                course: course.id,
                cabinet: zamena.cabinetID,
                number: zamena.lessonTimingsID,
                teacher: zamena.teacherID,
                group: zamena.groupID,
                date: zamena.date),
          );
        }
        return const SizedBox();
      } else {
        if (widget.dayZamenas
            .any((element) => element.lessonTimingsID == para.number)) {
          Lesson? swapedPara = widget.lessons
              .where((element) => element.number == para.number)
              .firstOrNull;
          Zamena zamena = widget.dayZamenas
              .where((element) => element.lessonTimingsID == para.number)
              .first;
          final course = getCourseById(zamena.courseID) ??
              Course(id: -1, name: "err2", color: "100,0,0,0");

          return CourseTile(
            needZamenaAlert: true,
            short: false,
            type: type,
            obedTime: obed,
            course: course,
            refresh: widget.refresh,
            saturdayTime: widget.day == 6,
            lesson: Lesson(
                id: -1,
                course: course.id,
                cabinet: zamena.cabinetID,
                number: zamena.lessonTimingsID,
                teacher: zamena.teacherID,
                group: zamena.groupID,
                date: zamena.date),
            swaped: swapedPara,
          );
        } else {
          if (widget.lessons.any((element) => element.number == para.number)) {
            Lesson lesson = widget.lessons
                .where((element) => element.number == para.number)
                .first;
            final course = getCourseById(lesson.course) ??
                Course(id: -1, name: "err3", color: "50,0,0,1");
                //дефолтное
            return CourseTile(
              short: false,
              saturdayTime: widget.day == 6,
              type: type,
              obedTime: obed,
              course: course,
              lesson: lesson,
              swaped: null,
              refresh: widget.refresh,
            );
          }
        }
      }
      return const SizedBox();
    }).toList();
  }
}
