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

class OvertimeTabAdmin extends StatelessWidget {
  const OvertimeTabAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => Get.find<DashboardControllerAdmin>().clearFilter());
      Get.find<ReportsControllerAdmin>().getOvertime();
    });
    return Obx(() {
      List<EmployeeList>? overtimeDetails =
          Get.find<ReportsControllerAdmin>().getFilteredOvertimeList();
      // ?.where((element) => element.status == '0')
      // .toList();
      if (overtimeDetails?.isEmpty ?? true) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const ListEmployeesAdmin());
                  },
                  child: const Text('Add Overtime'),
                ),
              ),
            ),
          ],
        );
      }
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: overtimeDetails?.length ?? 0,
        itemBuilder: (context, index) {
          print("Index:$index");
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
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => const ListEmployeesAdmin());
                      },
                      child: const Text('Add Overtime'),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: GestureDetector(
                  onTap: () {},
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 3),
                                      decoration: BoxDecoration(
                                        color: overtimeStatusModel.boxColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        style: TextStyle(
                                            color:
                                                overtimeStatusModel.textColor),
                                        ' ${overtimeStatusModel.text}',
                                      ),
                                    ),
                                    kSizedBoxH2,
                                    DetailsRow(
                                      title: "Date: ",
                                      value: DateFormat('dd-MM-yyyy').format(
                                          overtimeDetail?.date ??
                                              DateTime(0000, 00, 00)),
                                    ),
                                    kSizedBoxH4,
                                    DetailsRow(
                                      title: "Total Hours: ",
                                      value: overtimeDetail?.totalHours ?? '',
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
                                Get.find<ReportsControllerAdmin>()
                                    .approveOrDeclineOvertime(
                                        index, ReasonButton.overtimeDecline);
                              }),
                              kSizedBoxW10,
                              processButton('Edit', CustomColors.blueCardColor,
                                  () {
                                tempIndex = tempIndex + 1;
                                DialogHelper.showBottomSheet(
                                    RequestOvertimeBottomsheet(
                                  index: tempIndex,
                                ));
                              }),
                              kSizedBoxW10,
                              processButton('Approve', CustomColors.greenColor,
                                  () {
                                Get.find<ReportsControllerAdmin>()
                                    .approveOrDeclineOvertime(
                                        index, ReasonButton.overtimeApprove);
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
