import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zameny_flutter/domain/Models/models.dart';
import 'package:zameny_flutter/domain/Services/tools.dart';
import 'package:zameny_flutter/presentation/Screens/zamena_screen/providers/zamena_provider.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/CourseTile.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/schedule_date_header_toggle_week_button.dart';
import 'package:zameny_flutter/presentation/Widgets/shared/failed_load_widget.dart';
import 'package:zameny_flutter/presentation/Widgets/shared/loading_widget.dart';

class ZamenaScreen extends ConsumerStatefulWidget {
  const ZamenaScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ZamenaScreenState();
}

class _ZamenaScreenState extends ConsumerState<ZamenaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Замены",
                  style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Ubuntu'),
                ),
              ],
            ),
            // const DateHeader(),
            const SizedBox(height: 10),
            const ZamenaDateNavigation(),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withOpacity(0.2),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("⚠️ Фича в деве",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Ubuntu',
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.inverseSurface)),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Данные могут быть некорректны, для уверенности свертесь с файлом замен",
                    style: TextStyle(
                        fontFamily: 'Ubuntu', fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const ZamenaFileBlock(),
            const SizedBox(height: 10),
            const ZamenaView(),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}

class ZamenaView extends ConsumerStatefulWidget {
  const ZamenaView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ZamenaViewState();
}

class _ZamenaViewState extends ConsumerState<ZamenaView> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: ref.watch(zamenasListProvider).when(
        data: (data) {
          if (data.$1.isEmpty) {
            return const Center(
              key: ValueKey('noData'),
              child: Text("Нет замен"),
            );
          }
          return ZamenaViewGroup(
            key: const ValueKey('data'),
            zamenas: data.$1,
            fullZamenas: data.$2,
          );
        },
        error: (error, trace) {
          return Center(
            key: const ValueKey('error'),
            child: FailedLoadWidget(error: error.toString()),
          );
        },
        loading: () {
          return const LoadingWidget(
            key: ValueKey('loading'),
          );
        },
      ),
    );
  }
}

class ZamenaFileBlock extends ConsumerWidget {
  const ZamenaFileBlock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(zamenasListProvider).when(data: (data) {
      if(data.$3.isEmpty) {
        return const SizedBox();
      }
      return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.open_in_new,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Column(
                  children: data.$3.map((link) {
                return Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => launchUrl(Uri.parse(link.link)),
                        child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Ссылка:",
                                  style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inverseSurface),
                                ),
                                Text(link.link,
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontSize: 10,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inverseSurface
                                            .withOpacity(0.6))),
                                            const SizedBox(height: 5,),
                                Text(
                                  "Время добавления в систему:",
                                  style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inverseSurface),
                                ),
                                Text(
                                  "${link.created}",
                                  style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      fontSize: 10,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inverseSurface
                                          .withOpacity(0.6)),
                                ),
                              ],
                            )),
                      ),
                    )
                  ],
                );
              }).toList()),
            ],
          ));
    }, error: (error, obj) {
      return const SizedBox();
    }, loading: () {
      return const SizedBox();
    });
  }
}

class ZamenaViewGroup extends StatelessWidget {
  final List<Zamena> zamenas;
  final List<ZamenaFull> fullZamenas;
  const ZamenaViewGroup(
      {super.key, required this.zamenas, required this.fullZamenas});

  @override
  Widget build(BuildContext context) {
    final Set<int> groupsList = zamenas.map((zamena) => zamena.groupID).toSet();
    final date = DateTime.now();
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: groupsList.map((group) {
          final groupZamenas =
              zamenas.where((zamena) => zamena.groupID == group);
          final isFullZamena =
              fullZamenas.any((fullzamena) => fullzamena.group == group);
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(getGroupById(group)!.name,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inverseSurface,
                          fontSize: 20,
                          fontFamily: 'Ubuntu')),
                  isFullZamena
                      ? Text(
                          "Полная замена",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .inverseSurface
                                  .withOpacity(0.7),
                              fontSize: 18,
                              fontFamily: 'Ubuntu'),
                        )
                      : const SizedBox()
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: groupZamenas.map((zamena) {
                  final course = getCourseById(zamena.courseID)!;
                  final teacher = getTeacherById(zamena.teacherID);
                  final cabinet = getCabinetById(zamena.cabinetID);
                  // return const Text("data");
                  return CourseTile(
                    clickabe: false,
                      course: course,
                      lesson: Lesson(
                          id: course.id,
                          number: zamena.lessonTimingsID,
                          group: group,
                          date: date,
                          course: course.id,
                          teacher: teacher.id,
                          cabinet: cabinet.id),
                      swaped: null,
                      needZamenaAlert: false,
                      type: SearchType.group,
                      refresh: () {},
                      saturdayTime: false,
                      obedTime: false,
                      short: true);
                }).toList(),
              )
            ],
          );
        }).toList());
  }
}

class ZamenaDateNavigation extends ConsumerStatefulWidget {
  const ZamenaDateNavigation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ZamenaDateNavigationState();
}

class _ZamenaDateNavigationState extends ConsumerState<ZamenaDateNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ToggleWeekButton(
              next: false,
              onTap: (way, context) {
                ref.read(zamenaProvider).toggleWeek(way, context);
              },
            ),
            const SizedBox(
              width: 5,
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        getDayName(
                            ref.watch(zamenaProvider).currentDate.weekday),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Ubuntu',
                            fontSize: 16,
                            color:
                                Theme.of(context).colorScheme.inverseSurface),
                      ),
                      Text(
                        ref.watch(zamenaProvider).currentDate.formatyyyymmdd(),
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Ubuntu',
                            fontSize: 12,
                            color: Theme.of(context)
                                .colorScheme
                                .inverseSurface
                                .withOpacity(0.5)),
                      ),
                    ],
                  ),
                  AnimatedSize(
                    curve: Curves.easeOutCubic,
                    duration: const Duration(milliseconds: 150),
                    alignment: Alignment.center,
                    child: ref
                                .watch(zamenaProvider)
                                .currentDate
                                .formatyyyymmdd() ==
                            DateTime.now().formatyyyymmdd()
                        ? Container(
                            margin: const EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                "Сегодня",
                                style: TextStyle(
                                    color: Theme.of(context).canvasColor,
                                    fontSize: 14,
                                    fontFamily: 'Ubuntu',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
            ToggleWeekButton(
              next: true,
              onTap: (way, context) {
                ref.read(zamenaProvider).toggleWeek(way, context);
              },
            ),
          ],
        ));
  }
}
