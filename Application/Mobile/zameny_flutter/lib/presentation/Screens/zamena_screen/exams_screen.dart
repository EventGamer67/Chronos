import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:zameny_flutter/domain/Services/tools.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/presentation/Screens/app/providers/main_provider.dart';
import 'package:zameny_flutter/presentation/Screens/timetable/timetable_screen.dart';
import 'package:zameny_flutter/presentation/Screens/zamena_screen/providers/zamena_provider.dart';
import 'package:zameny_flutter/presentation/Screens/zamena_screen/widget/zamena_view_chooser.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/course_tile.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/schedule_date_header_toggle_week_button.dart';
import 'package:zameny_flutter/presentation/Widgets/shared/failed_load_widget.dart';
import 'package:zameny_flutter/presentation/Widgets/shared/loading_widget.dart';
import 'package:zameny_flutter/theme/flex_color_scheme.dart';


class ZamenaScreenWrapper extends StatelessWidget {
  const ZamenaScreenWrapper({super.key});

  @override
  Widget build(final BuildContext context) {
    return const ScreenAppearBuilder(
      child: ZamenaScreen()
    );
  }
}

class ZamenaScreen extends ConsumerStatefulWidget {
  const ZamenaScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ZamenaScreenState();
}

class _ZamenaScreenState extends ConsumerState<ZamenaScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late final ScrollController controller;

  @override
  void initState() {
    controller = ScrollController();
    controller.addListener((){
      ref.read(mainProvider).updateScrollDirection(controller.position.userScrollDirection);
    });
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        controller: controller,
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Замены',
                  style: context.styles.ubuntuPrimaryBold24,
                ),
              ],
            ),
            // const DateHeader(),
            const SizedBox(height: 10),
            const ZamenaDateNavigation(),
            const SizedBox(height: 8),
            const ZamenaViewChooser(),
            const SizedBox(height: 8),
            // const WarningDevBlank(),
            // const SizedBox(height: 10),
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
  Widget build(final BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: ref.watch(zamenasListProvider).when(
        data: (final data) {
          if (data.$1.isEmpty) {
            return const Center(
              key: ValueKey('noData'),
              child: Text('Нет замен'),
            );
          }
        switch (ref.watch(zamenaProvider).zamenaView) {
          case ZamenaViewType.group:
            return ZamenaViewGroup(
              key: const ValueKey('data'),
              zamenas: data.$1,
              fullZamenas: data.$2,
            );
          case ZamenaViewType.teacher:
            return ZamenaViewTeacher(
              key: const ValueKey('data'),
              zamenas: data.$1,
              fullZamenas: data.$2,
            );
        }
        },
        error: (final error, final trace) {
          return Center(
            key: const ValueKey('error'),
            child: FailedLoadWidget(error: error.toString()),
          );
        },
        loading: () {
          return const LoadingWidget(key: ValueKey('loading'));
        },
      ),
    );
  }
}

class ZamenaFileBlock extends ConsumerWidget {
  const ZamenaFileBlock({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return ref.watch(zamenasListProvider).when(data: (final data) {
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
                children: data.$3.map((final ZamenaFileLink link) {
                return Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => launchUrl(Uri.parse(link.link)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ссылка:',
                              style: context.styles.ubuntuInverseSurface12,
                            ),
                            Text(
                              link.link,
                              style: context.styles.ubuntuInverseSurface10.copyWith(color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.6))
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Время добавления в систему:',
                              style: context.styles.ubuntuInverseSurface12,
                            ),
                            Text(
                              '${link.created}',
                              style: context.styles.ubuntuInverseSurface10.copyWith(color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.6))
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),),
            ],
          ),);
    }, error: (final error, final obj) {
      return const SizedBox();
    }, loading: () {
      return const SizedBox();
    },);
  }
}

class ZamenaViewTeacher extends StatelessWidget {
  final List<Zamena> zamenas;
  final List<ZamenaFull> fullZamenas;
  const ZamenaViewTeacher({required this.zamenas, required this.fullZamenas, super.key});

  @override
  Widget build(final BuildContext context) {
    final Set<int> teachersList = zamenas.map((final zamena) => zamena.teacherID).toSet();
    final date = DateTime.now();
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: teachersList.map((final teacherId) {
          final groupZamenas =
              zamenas.where((final zamena) => zamena.teacherID == teacherId).toList();
              groupZamenas.sort((final a,final b) => a.lessonTimingsID > b.lessonTimingsID ? 1 : -1);
          final teacher = getTeacherById(teacherId);
          if(teacher.name.replaceAll(' ', '') == ''){
            return const SizedBox();
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    teacher.name,
                    style: context.styles.ubuntuInverseSurface20,
                  )
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: groupZamenas.map((final zamena) {
                  final course = getCourseById(zamena.courseID)!;
                  final cabinet = getCabinetById(zamena.cabinetID);
                  final group = getGroupById(zamena.groupID);
                  return CourseTile(
                    clickabe: false,
                      course: course,
                      lesson: Lesson(
                          id: course.id,
                          number: zamena.lessonTimingsID,
                          group: group!.id,
                          date: date,
                          course: course.id,
                          teacher: teacher.id,
                          cabinet: cabinet.id,),
                      swaped: null,
                      type: SearchType.teacher,
                      refresh: () {},
                      saturdayTime: false,
                      obedTime: false,
                      short: true,);
                }).toList(),
              ),
            ],
          );
        }).toList(),);
  }
}

class ZamenaViewGroup extends StatelessWidget {
  final List<Zamena> zamenas;
  final List<ZamenaFull> fullZamenas;
  const ZamenaViewGroup(
      {required this.zamenas, required this.fullZamenas, super.key,});

  @override
  Widget build(final BuildContext context) {
    final Set<int> groupsList = zamenas.map((final zamena) => zamena.groupID).toSet();
    final date = DateTime.now();
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: groupsList.map((final int group) {
          final groupZamenas = zamenas.where((final Zamena zamena) => zamena.groupID == group);
          final isFullZamena = fullZamenas.any((final fullzamena) => fullzamena.group == group);

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getGroupById(group)!.name,
                    style: context.styles.ubuntuInverseSurface20
                  ),
                  isFullZamena
                    ? Text(
                        'Полная замена',
                        style: context.styles.ubuntu18.copyWith(color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.7))
                      )
                    : const SizedBox.shrink(),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: groupZamenas.map((final zamena) {
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
                        cabinet: cabinet.id,
                      ),
                      swaped: null,
                      type: SearchType.group,
                      refresh: () {},
                      saturdayTime: false,
                      obedTime: false,
                      short: true,);
                }).toList(),
              ),
            ],
          );
        }).toList(),);
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
  Widget build(final BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ToggleWeekButton(
              next: false,
              onTap: (final way, final context) {
                ref.read(zamenaProvider).toggleWeek(way, context);
              },
            ),
            const SizedBox(
              width: 5,
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        getDayName(ref.watch(zamenaProvider).currentDate.weekday),
                        style: context.styles.ubuntuInverseSurfaceBold16,
                      ),
                      Text(
                        ref.watch(zamenaProvider).currentDate.formatyyyymmdd(),
                        style: context.styles.ubuntu40012.copyWith(color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.5))
                      ),
                    ],
                  ),
                  AnimatedSize(
                    curve: Curves.easeOutCubic,
                    duration: const Duration(milliseconds: 150),
                    child: ref.watch(zamenaProvider).currentDate.formatyyyymmdd() == DateTime.now().formatyyyymmdd()
                      ? Container(
                          margin: const EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                              borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              'Сегодня',
                              style: context.styles.ubuntuCanvasColorBold14,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            ToggleWeekButton(
              next: true,
              onTap: (final way, final context) {
                ref.read(zamenaProvider).toggleWeek(way, context);
              },
            ),
          ],
        ),);
  }
}
