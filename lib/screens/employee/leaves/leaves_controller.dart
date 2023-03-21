import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:paytym/core/colors/colors.dart';
import 'package:paytym/core/constants/strings.dart';
import 'package:paytym/models/leaves/leaves_request_model.dart';
import 'package:paytym/models/leaves/leaves_response.dart';
import 'package:paytym/models/leaves/leaves_status_model.dart';
import 'package:paytym/network/base_controller.dart';
import 'package:paytym/screens/login/login_controller.dart';
import '../../../core/dialog_helper.dart';
import '../../../models/message_only_response_model.dart';
import '../../../network/base_client.dart';
import '../../../network/end_points.dart';

class LeavesController extends GetxController with BaseController {
  final leaveResponseModel = LeaveResponseModel().obs;
  final formKey = GlobalKey<FormState>();
  LeaveRequestModel leaveRequestModel = LeaveRequestModel();
  final selectedItem = leaveTypes[0].obs;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  final isTimeFieldVisible = false.obs;

  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  @override
  void onReady() {
    super.onReady();
    fetchLeaveData();
  }

  fetchLeaveData() async {
    showLoading();
    Get.find<BaseClient>().onError = fetchLeaveData;
    var responseString = await Get.find<BaseClient>()
        .get(ApiEndPoints.leave, Get.find<LoginController>().getHeader())
        .catchError(handleError);
    print(responseString);
    if (responseString == null) {
      return;
    } else {
      hideLoading();
      leaveResponseModel.value = leaveResponseModelFromJson(responseString);
      Get.find<BaseClient>().onError = null;
    }
  }

  Future<MessageOnlyResponseModel?> applyForLeave() async {
    showLoading();
    leaveRequestModel.employerId =
        '${Get.find<LoginController>().loginResponseModel?.employee?.employerId}';

    var responseString = await Get.find<BaseClient>()
        .post(ApiEndPoints.leave, leaveRequestModelToJson(leaveRequestModel),
            Get.find<LoginController>().getHeader())
        .catchError(handleError);

    if (responseString == null) {
      return null;
    } else {
      hideLoading();
      return messageOnlyResponseModelFromJson(responseString);
    }
  }

  String formatDate(String? date) {
    if (date == null) {
      return '';
    }
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('EEE, dd MMM').format(dateTime);
  }

  String getMonthFromDate(String? date) {
    if (date == null) {
      return '';
    }
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('MMMM yyyy').format(dateTime);
  }

  Future<void> selectDateTime(BuildContext context, bool isStartDate) async {
    final DateTime? dateTime = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: isStartDate ? DateTime(1990) : startDate,
      lastDate: DateTime(2030),
    );
    isStartDate ? startDate = dateTime! : endDate = dateTime!;

    isStartDate
        ? startDateController.text = getDateString(startDate)
        : endDateController.text = getDateString(endDate);
  }

  String getDateString(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }

    return DateFormat('dd-MM-yyyy').format(dateTime).toString();
  }

  String getDateReverseString(String? date) {
    if (date == null) {
      return '';
    }
    var inputFormat = DateFormat('dd-MM-yyyy');
    var inputDate = inputFormat.parse(date);

    var outputFormat = DateFormat('yyyy-MM-dd');
    return outputFormat.format(inputDate);
  }

  validateAndApplyForLeave() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      MessageOnlyResponseModel? model = await applyForLeave();

      if (model != null) {
        DialogHelper.showToast(desc: model.message!);
        LeaveRequest leaveRequest = LeaveRequest(
          title: leaveRequestModel.title,
          // startDate: (selectedItem.value == 'halfday')
          //     ? '${getDateReverseString(leaveRequestModel.startDate)} ${DateFormat().format(DateTime.tryParse(startTimeController.text) ?? DateTime(00, 00, 00))}'
          //     : '${getDateReverseString(leaveRequestModel.startDate)} 00:00:00',
          // endDate: (selectedItem.value == 'halfday')
          //     ? '${getDateReverseString(leaveRequestModel.endDate)} ${DateFormat().format(DateTime.tryParse(startTimeController.text) ?? DateTime(00, 00, 00))}'
          //     : '${getDateReverseString(leaveRequestModel.endDate)} 00:00:00',

          //startDate: getDateReverseString(leaveRequestModel.startDate),
          //endDate: getDateReverseString(leaveRequestModel.endDate),
          type: int.parse(leaveRequestModel.type),
          startDate: "02-11-2022 00:00:00",
          endDate: "02-11-2022 00:00:00",
        );
        leaveResponseModel.value.leaveRequests?.insert(0, leaveRequest);
        leaveRequestModel = LeaveRequestModel();
        startDate = DateTime.now();
        endDate = DateTime.now();

        startDateController.text = kStartDateString;
        endDateController.text = kEndDateString;
        Get.back();
        selectedItem.value = leaveTypes[0];
        leaveResponseModel.refresh();
      }
    }
  }

  String? titleValidator(String value) {
    return GetUtils.isLengthLessThan(value, 5)
        ? "Reason should be minimum 5 characters"
        : null;
  }

  String? dateValidator(String value) {
    final regExp =
        RegExp(r'^(0[1-9]|[12][0-9]|3[01])\-(0[1-9]|1[012])\-\d{4}$');
    return regExp.hasMatch(value) && GetUtils.isLengthEqualTo(value, 10)
        ? null
        : "Enter a valid date";
  }

  LeaveStatusModel getLeaveStatusModel(String? status) {
    switch (status) {
      case '1':
        //1 => status - approved
        return LeaveStatusModel(
            'Approved', CustomColors.greenColor, CustomColors.lightGreenColor);
      case '2':
        //2 => status - declined
        return LeaveStatusModel(
            'Declined', CustomColors.redColor, CustomColors.lightRedColor);
      case '0':
      default:
        //0 => status - awaiting
        return LeaveStatusModel('Awaiting', CustomColors.orangeLabelColor,
            CustomColors.lightOrangeColor);
    }
  }

  String leaveTypesToString(leaveType) {
    var type = leaveType is LeaveRequest ? leaveType.type : leaveType;
    if (type == 7) {
      return 'Casual';
    }
    if (type == 9) {
      return 'Halfday';
    }
    return '';
  }
}
