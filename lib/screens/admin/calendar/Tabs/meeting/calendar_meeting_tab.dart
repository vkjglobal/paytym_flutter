import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:paytym/core/colors/colors.dart';
import 'package:paytym/core/constants/widgets.dart';
import 'package:paytym/screens/admin/calendar/calendar_controller.dart';

import '../../../../../core/constants/styles.dart';

class CalendarMeetingAdmin extends StatelessWidget {
  const CalendarMeetingAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: Get.find<CalendarControllerAdmin>()
            .meetingResponseModel
            .value
            .meetingsListe
            .length,
        itemBuilder: (context, index) {
          final meeting = Get.find<CalendarControllerAdmin>()
              .meetingResponseModel
              .value
              .meetingsListe[index];
          return SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 40,
                  child: Column(
                    children: [
                      kSizedBoxH10,
                      Text(
                        DateFormat('EEE').format(meeting.date),
                        style: kTextStyleS18W600.copyWith(
                            color: CustomColors.grey156x3TextColor),
                      ),
                      Text(
                        meeting.date.day.toString(),
                        style: kTextStyleS18W600.copyWith(
                            color: CustomColors.lightBlueColor),
                      ),
                    ],
                  ),
                ),
                kSizedBoxW10,
                Expanded(
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.2, color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  meeting.location,
                                  // 'Meeting with Miller',
                                  style: kTextStyleS18W600.copyWith(
                                      color: CustomColors.blackTextColor),
                                ),
                                kSizedBoxH4,
                                Text(
                                  meeting.location,
                                  // 'HR Manager',
                                  style: kTextStyleS14W600Cgrey300LS0p2
                                      .copyWith(color: Colors.grey),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.schedule,
                                      size: 15,
                                      color: Colors.grey,
                                    ),
                                    kSizedBoxW4,
                                    Text(
                                      DateFormat.jm().format(meeting.startTime),

                                      // '09:00 AM - 12:00 AM',
                                      style: kTextStyleS14W600Cgrey300LS0p2
                                          .copyWith(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Get.find<CalendarControllerAdmin>()
                                          .deleteMeeting(index);
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline_outlined,
                                      color: CustomColors.redColor,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => kSizedBoxH10,
      ),
    );
  }
}
