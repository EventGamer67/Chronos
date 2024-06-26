import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zameny_flutter/domain/Providers/drawer_provider.dart';
import 'package:zameny_flutter/domain/Services/firebase.dart';

class ScheduleHeader extends ConsumerStatefulWidget {
  const ScheduleHeader({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScheduleHeaderState();
}

class _ScheduleHeaderState extends ConsumerState<ScheduleHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            // GestureDetector(
            //   onTap: () {
            //     ref.read(drawerProvider).openDrawer();
            //   },
            //   child: SizedBox(
            //       width: 52,
            //       height: 52,
            //       child: Center(
            //           child: SvgPicture.asset(
            //         "assets/icon/vuesax_linear_note.svg",
            //         colorFilter: ColorFilter.mode(
            //             Theme.of(context).colorScheme.inverseSurface,
            //             BlendMode.srcIn),
            //         width: 32,
            //         height: 32,
            //       ))),
            // ),
            GestureDetector(
              onTap: () {
                ref.watch(norificationProvider).enableNotifications();
              },
              child: SizedBox(
                  width: 52,
                  height: 52,
                  child: Center(
                      child: SvgPicture.asset(
                    "assets/icon/notification.svg",
                    colorFilter: ColorFilter.mode(
                        ref.watch(norificationProvider).fcmToken == null
                            ? Theme.of(context).colorScheme.inverseSurface
                            : Colors.green,
                        BlendMode.srcIn),
                    width: 32,
                    height: 32,
                  ))),
            ),
          ],
        ),
        Text(
          "Расписание",
          style: TextStyle(
              color: Theme.of(context).primaryColorLight,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Ubuntu'),
        ),
        IconButton(
            onPressed: () {
              showModalBottomSheet(
                  barrierColor: Colors.black.withOpacity(0.3),
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  context: context,
                  builder: (context) => SizedBox(
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  "Показать логи Talker",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      fontFamily: 'Ubuntu'),
                                ),
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => TalkerScreen(
                                            talker: GetIt.I.get<Talker>()))),
                              ),
                              // ListTile(
                              //     title: Text(
                              //       "Тест",
                              //       style: TextStyle(
                              //           color: Theme.of(context)
                              //               .colorScheme
                              //               .inversePrimary,
                              //           fontFamily: 'Ubuntu'),
                              //     ),
                              //     onTap: () async {
                              //       SupabaseClient supa = GetIt.I.get<SupabaseClient>();
                              //       GetIt.I.get<Talker>().debug(await supa.rpc('test4',params: {'groupid' : 2464,'datestart': DateTime(2024,3,11).toIso8601String(), 'dateend':DateTime(2024,3,17).toIso8601String() }));
                              //     }),
                            ],
                          ),
                        ),
                      ));
            },
            icon: Icon(
              Icons.more_horiz_rounded,
              size: 36,
              color: Theme.of(context).primaryColorLight,
            ))
      ],
    );
  }
}
