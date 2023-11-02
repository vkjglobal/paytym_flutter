import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:paytym/core/constants/enums.dart';
import 'package:paytym/core/constants/widgets.dart';
import 'package:paytym/models/report/overtime/overtime_status-model.dart';
import 'package:paytym/models/report/overtime_list_response_model.dart';
import 'package:paytym/screens/admin/reports/reports_controller.dart';
import '../../../../core/colors/colors.dart';
import '../../../../core/dialog_helper.dart';
import '../../../employee/dashboard/widgets/request_overtime_bottomsheet.dart';
import '../../../employee/reports/list_employees.dart';
import '../../dashboard/dashboard_controller.dart';
import '../widgets/payment_history.dart';
import '../add_attendance.dart';

class LoanTabAdmin extends StatelessWidget {
  const LoanTabAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    print("OvertimeTabAdmin called");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ReportsControllerAdmin>().getOvertime();
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => Get.find<DashboardControllerAdmin>().clearFilter());
      // Get.find<ReportsControllerAdmin>().getOvertime();
      //addotional adding below 5 oct 2023
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => Get.find<ReportsControllerAdmin>().getFilteredOvertimeList);
      // Get.find<ReportsControllerAdmin>().getOvertime();
      Get.find<ReportsControllerAdmin>().fetchBusiness();
    });
    return Obx(() {
      List<EmployeeList>? overtimeDetails = Get.find<ReportsControllerAdmin>()
          .getFilteredOvertimeList()
          ?.where((element) => element.status == '0')
          .toList();

      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: overtimeDetails?.length ?? 0,
        itemBuilder: (context, index) {
          // print("Index:$index");
          final overtimeDetail = overtimeDetails?[index];
          OvertimeStatusModel overtimeStatusModel =
              Get.find<ReportsControllerAdmin>()
                  .getOvertimeStatusModel(overtimeDetail!.status);
          // print("List Loading:${overtimeDetail.status}");
          int tempIndex = 0;
          return Column(
            children: [
              if (index == 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: GestureDetector(
                    onTap: () {
                      // print("Overtime Index: ${index.toString()}");
                      // print("Overtime ID: ${overtimeDetail.id.toString()}");
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ID: #${overtimeDetail?.employeeId.toString().padLeft(5, '0')}',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      kSizedBoxH2,
                                      Text(
                                        '${overtimeDetail?.user?.firstName ?? ''} ${overtimeDetail?.user?.lastName ?? ''}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Branch Name',
                                        // overtimeDetail?.user?.bankBranchName
                                        //         ?.toString() ??
                                        //     '',

                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12.5),
                                      ),
                                      // Text(
                                      //   '${overtimeDetail?.user?.firstName ?? ''} ${overtimeDetail?.user?.lastName ?? ''}',
                                      //   style: const TextStyle(
                                      //     fontWeight: FontWeight.w600,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 3),
                                        decoration: BoxDecoration(
                                          color: overtimeStatusModel.boxColor,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          style: TextStyle(
                                              color: overtimeStatusModel
                                                  .textColor),
                                          ' ${overtimeStatusModel.text}',
                                        ),
                                      ),
                                      kSizedBoxH2,
                                      DetailsRow(
                                        title: "Date of Requirement: ",
                                        value: DateFormat('dd-MM-yyyy').format(
                                            overtimeDetail?.date ??
                                                DateTime(0000, 00, 00)),
                                      ),
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
                                    overtimeDetail?.reason ?? '',
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
                          if (int.parse(overtimeDetail.status.toString()) == 0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                processButton('Decline', CustomColors.redColor,
                                    () {
                                  // Get.find<ReportsControllerAdmin>.selectedOvertimeID = overtimeDetail.id.toString();
                                  // Get.find<ReportsControllerAdmin>()
                                  //     .showBottomSheetForReason(
                                  //         ReasonButton.overtimeDecline);
                                  DialogHelper.showBottomSheet(
                                      RequestOvertimeBottomsheet(
                                    index: index,
                                    delete: true.toString(),
                                  ));

                                  //original code
                                  // Get.find<ReportsControllerAdmin>()
                                  //     .approveOrDeclineOvertime(
                                  //         // index, ReasonButton.overtimeDecline);
                                  //         tempIndex,
                                  //         ReasonButton.overtimeDecline);
                                }),
                                kSizedBoxW10,
                                processButton(
                                    'Edit', CustomColors.blueCardColor, () {
                                  tempIndex = tempIndex + 1;
                                  // print("Got tempIndex:${tempIndex?.toString()}");
                                  DialogHelper.showBottomSheet(
                                      RequestOvertimeBottomsheet(
                                    index: index,
                                    delete: "false",
                                  ));
                                }),
                                kSizedBoxW10,
                                processButton(
                                    'Approve', CustomColors.greenColor, () {
                                  print(
                                      "Got tempIndex:${tempIndex?.toString()}");
                                  Get.find<ReportsControllerAdmin>()
                                      .approveOrDeclineOvertime(
                                          // index, ReasonButton.overtimeApprove);
                                          tempIndex,
                                          ReasonButton.overtimeApprove);
                                }),
                              ],
                            ),
                          kSizedBoxH10,
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
