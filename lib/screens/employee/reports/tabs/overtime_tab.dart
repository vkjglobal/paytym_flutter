import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:paytym/core/constants/widgets.dart';
import 'package:paytym/models/report/overtime_list_response_model.dart';
import 'package:paytym/screens/employee/reports/reports_controller.dart';

import '../../../../models/report/overtime/overtime_status-model.dart';

class OvertimeTab extends StatelessWidget {
  const OvertimeTab({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ReportsController>().getOvertime();
    });
    return Obx(() {
      List<EmployeeList>? overtimeDetails = Get.find<ReportsController>()
          .overtimeResponseModel
          .value
          .employeeList;

      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: overtimeDetails.length,
        itemBuilder: (context, index) {
          final overtimeDetail = overtimeDetails[index];
          OvertimeStatusModel overtimeStatusModel =
              Get.find<ReportsController>()
                  .getOvertimeStatusModel(overtimeDetail?.status.toString());
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: GestureDetector(
                  onTap: () {},
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    // OT request status 0: Applied, 1:Approved,2:Rejected
                    child: Column(
                      children: [
                        kSizedBoxH4,
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 75),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ID: #${overtimeDetail.employeeId.toString().padLeft(5, '0')}',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    // kSizedBoxH2,
                                    DetailsRow(
                                      title: "Date: ",
                                      value: DateFormat('dd-MM-yyyy').format(
                                          overtimeDetail.date ??
                                              DateTime(0000, 00, 00)),
                                    ),
                                    // Text(
                                    //   overtimeDetail.branch ?? '',
                                    //   style: TextStyle(
                                    //       color: Colors.grey.shade600,
                                    //       fontSize: 12.5),
                                    // ),
                                    Text(
                                      '${overtimeDetail.user?.firstName ?? ''} ${overtimeDetail.user?.lastName ?? ''}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: overtimeStatusModel.textColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        overtimeStatusModel.text,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: overtimeStatusModel.boxColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    kSizedBoxH2,
                                    DetailsRow(
                                      title: "Total Hours: ",
                                      value: overtimeDetail.totalHours ?? '',
                                    ),
                                    kSizedBoxH4,
                                    // DetailsRow(
                                    //   title: "Total Hours: ",
                                    //   value: overtimeDetail.totalHours ?? '',
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Reason: ',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  // overtimeDetail.reason ?? '',
                                  overtimeDetail.declineReason ?? '',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        kSizedBoxH10,
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     const Text(
                        //       'Reason: ',
                        //       style: TextStyle(
                        //         fontSize: 12,
                        //         fontWeight: FontWeight.w400,
                        //         color: Colors.black,
                        //       ),
                        //     ),
                        //     Expanded(
                        //       child: Text(
                        //         overtimeDetail.reason ?? '',
                        //         style: const TextStyle(
                        //           fontSize: 12,
                        //           fontWeight: FontWeight.w400,
                        //           color: Colors.blue,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }
}

class DetailsRow extends StatelessWidget {
  final String title;
  final String value;
  const DetailsRow({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}
