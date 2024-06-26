
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zameny_flutter/domain/Providers/bloc/export_bloc.dart';
import 'package:zameny_flutter/domain/Providers/schedule_provider.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/CourseTile.dart';

class SearchResultHeader extends ConsumerStatefulWidget {
  const SearchResultHeader({
    super.key,
  });

  @override
  _SearchResultHeaderState createState() => _SearchResultHeaderState();
}

class _SearchResultHeaderState extends ConsumerState<SearchResultHeader> {
  bool opened = false;
  ExportBloc exportBloc = ExportBloc();

  @override
  Widget build(BuildContext context) {
    ScheduleProvider provider = context.watch<ScheduleProvider>();
    //bool enabled = provider.searchType == SearchType.group ? true : false;
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            Text(provider.getSearchTypeNamed(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inverseSurface,
                    fontFamily: 'Ubuntu',
                    fontSize: 18)),
            Text(provider.searchDiscribtion(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inverseSurface,
                    fontFamily: 'Ubuntu',
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            // enabled && IS_DEV
            //     ? Container(
            //         margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            //         padding: const EdgeInsets.all(8),
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(20),
            //           border: Border.all(
            //               color: Theme.of(context)
            //                   .colorScheme
            //                   .onSurface
            //                   .withOpacity(0.1)),
            //         ),
            //         child: Row(
            //           children: [

            //           ],
            //         ),
            //       )
            //     : const SizedBox()
          ],
        ),
        provider.searchType != SearchType.cabinet
            ? Align(
                alignment: Alignment.topRight,
                child: Modal(
                  visible: opened,
                  modal: Dialog(
                    alignment: Alignment.topRight,
                    child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                                width: 1,
                                color: Colors.white.withOpacity(0.15))),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          BlocBuilder<ExportBloc, ExportState>(
                              bloc: exportBloc,
                              builder: (context, state) {
                                return AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 150),
                                  child: Builder(
                                      key: ValueKey<String>(state.toString()),
                                      builder: (context) {
                                        if (state is ExportFailed) {
                                          return SizedBox(
                                            height: 30,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.warning),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  state.reason,
                                                  style: const TextStyle(
                                                      fontFamily: 'Ubuntu',
                                                      color: Colors.red),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                        if (state is ExportLoading) {
                                          return SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            )),
                                          );
                                        }
                                        if (state is ExportReady) {
                                          return GestureDetector(
                                            onTap: () async {
                                              exportBloc.add(ExportStart(
                                                  context: context, ref: ref));
                                            },
                                            child: const SizedBox(
                                              height: 30,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.image),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'Экспортировать расписание',
                                                    style: TextStyle(
                                                        fontFamily: 'Ubuntu',
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                        return const SizedBox();
                                      }),
                                );
                              })
                        ])),
                  ),
                  onClose: () => setState(() => opened = false),
                  child: IconButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() => opened = true);
                    },
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

class Modal extends StatefulWidget {
  const Modal({
    super.key,
    required this.visible,
    required this.onClose,
    required this.modal,
    required this.child,
  });

  final Widget child;
  final Widget modal;
  final bool visible;
  final VoidCallback onClose;

  @override
  State<Modal> createState() => _ModalState();
}

class _ModalState extends State<Modal> with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(vsync: this, value: 0);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Barrier(
      visible: widget.visible,
      onClose: widget.onClose,
      child: PortalTarget(
        visible: widget.visible,
        closeDuration: const Duration(milliseconds: 150),
        anchor: const Aligned(
            follower: Alignment.topRight, target: Alignment.topRight),
        portalFollower: Animate(
          controller: controller,
          value: 0.05,
          effects: const [
            FadeEffect(duration: Duration(milliseconds: 250)),
            ScaleEffect(
                duration: Duration(milliseconds: 250),
                alignment: Alignment.topRight,
                curve: Curves.fastLinearToSlowEaseIn)
          ],
          child: widget.modal,
        ),
        child: widget.child,
      ),
    );
  }
}

class Barrier extends StatelessWidget {
  const Barrier({
    super.key,
    required this.onClose,
    required this.visible,
    required this.child,
  });

  final Widget child;
  final VoidCallback onClose;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: visible,
      closeDuration: kThemeAnimationDuration,
      portalFollower: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onClose,
          child: const SizedBox()),
      child: child,
    );
  }
}
