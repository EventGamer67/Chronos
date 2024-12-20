import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart' as sf;
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zameny_flutter/domain/Providers/schedule_provider.dart';
import 'package:zameny_flutter/domain/Services/Data.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/schedule_date_header_toggle_week_button.dart';
import 'package:zameny_flutter/theme/flex_color_scheme.dart';

class BaseContainer extends StatelessWidget {
  final Widget child;

  const BaseContainer({
    required this.child,
    super.key
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
      ),
      child: child,
    );
  }
}

class DateHeader extends ConsumerWidget {
  const DateHeader({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(scheduleProvider);
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ToggleWeekButton(
              next: false,
              onTap: provider.toggleWeek,
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(child: DateHeaderDatePicker(provider: provider)),
            const SizedBox(
              width: 5,
            ),
            ToggleWeekButton(next: true, onTap: provider.toggleWeek),
          ],
        ),);
  }
}

class DateHeaderDatePicker extends StatelessWidget {
  const DateHeaderDatePicker({
    required this.provider, super.key,
  });

  final ScheduleProvider provider;

  @override
  Widget build(final BuildContext ctx) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showDialog(
              context: ctx,
              builder: (final BuildContext context) {
                return Center(
                    child: Container(
                  width: 380,
                  height: 450,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),),
                  child: sf.SfDateRangePicker(
                    selectionColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.6),
                    backgroundColor: Colors.transparent,
                    selectionRadius: 10,
                    initialDisplayDate: DateTime.now(),
                    showActionButtons: true,
                    onViewChanged: (final dateRangePickerViewChangedArgs) {
                      GetIt.I.get<Talker>().debug('need load');
                    },
                    allowViewNavigation: false,
                    onCancel: () => Navigator.of(context).pop(),
                    onSubmit: (final p0) {
                      if (p0 == null) {
                        Navigator.of(context).pop();
                        return;
                      }
                      final DateTime time = (p0 as DateTime);
                      provider.navigationDate = time;
                      provider.currentWeek = provider.getWeekNumber(time);
                      provider.dateSwitched(ctx);
                      Navigator.of(context).pop();
                    },
                    monthViewSettings:
                        sf.DateRangePickerMonthViewSettings(
                            firstDayOfWeek: DateTime.monday,
                            blackoutDates: GetIt.I
                                .get<Data>()
                                .holidays
                                .map((final e) => e.date)
                                .toList(),),
                    showTodayButton: true,
                    showNavigationArrow: true,
                    navigationDirection:
                        sf.DateRangePickerNavigationDirection.vertical,
                    navigationMode:
                        sf.DateRangePickerNavigationMode.scroll,
                    headerStyle: const sf.DateRangePickerHeaderStyle(
                        backgroundColor: Colors.transparent,),
                    cellBuilder: (final context, final cellDetails) {
                      return MonthCell(details: cellDetails);
                    },
                  ),
                ),);
              },
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Осенний семестр 2024/2025',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: ctx.styles.ubuntuInverseSurfaceBold16,
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 32,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Неделя ${provider.currentWeek}',
                      style: ctx.styles.ubuntuInverseSurfaceBold16,
                    ),
                    const SizedBox(width: 5),
                    AnimatedSize(
                      curve: Curves.easeOutCubic,
                      duration: const Duration(milliseconds: 150),
                      child: provider.todayWeek == provider.currentWeek
                        ? Container(
                          decoration: BoxDecoration(
                            color: Theme.of(ctx).colorScheme.primary,
                            borderRadius: const BorderRadius.all(Radius.circular(20))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              'Текущий',
                              style: ctx.styles.ubuntuCanvasColorBold14,
                            ),
                          ),
                          )
                        : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MonthCell extends ConsumerWidget {
  const MonthCell({required this.details, super.key});
  final sf.DateRangePickerCellDetails details;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final bool chillday = details.date.weekday == 7 ||
        GetIt.I
            .get<Data>()
            .holidays
            .any((final element) => element.date == details.date);
    final bool isToday = details.date.day == DateTime.now().day &&
        details.date.month == DateTime.now().month &&
        DateTime.now().year == details.date.year;
    if (isToday) {
      //GetIt.I.get<Talker>().good("da");
    }
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: !chillday
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white.withOpacity(0.1),)
                : null,
            child: Center(child: Text(details.date.day.toString())),
          ),
        ),
        isToday
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Theme.of(context).colorScheme.primary,),),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
