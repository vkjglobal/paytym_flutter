import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:paytym/core/colors/colors.dart';
import 'package:paytym/core/constants/widgets.dart';
import 'package:paytym/screens/employee/calendar/Tabs/holiday/calendar_holiday_tab.dart';
import 'package:paytym/screens/employee/calendar/widgets/calendar_card.dart';
import 'package:flutter/material.dart';
import 'package:paytym/screens/widgets/custom_app_bar.dart';
import '../../../core/constants/strings.dart';
import '../../widgets/custom_tab_bar.dart';
import 'Tabs/meeting/calendar_meeting_tab.dart';
import 'Tabs/event/calendar_event_tab.dart';
import 'calendar_controller.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CalendarController());
    return DefaultTabController(
      length: calendarTabList.length,
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(),
        ),
        backgroundColor: CustomColors.calendarPageBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              const CalendarCard(),
              kSizedBoxH15,
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
                child: CustomTabBar(
                  tabsList: calendarTabList,
                  width: 30,
                  color: CustomColors.blueTextColor,
                ),
              ),
              kSizedBoxH8,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Animate(
                    effects: const [FadeEffect()],
                    child: TabBarView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Animate(
                          effects: const [FadeEffect()],
                          child: const CalendarMeeting(),
                        ),
                        Animate(
                            effects: const [FadeEffect()],
                            child: const CalendarEvent()),
                        Animate(
                            effects: const [FadeEffect()],
                            child: const CalendarHolidayTab()),
                        // CalendarSchedule(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
