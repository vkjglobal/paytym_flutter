import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:paytym/models/report/attendance/attendance_admin_response_model.dart';
import 'package:paytym/models/report/deduction_response_model.dart';
import 'package:paytym/models/report/medical_list_admin_model.dart';
import 'package:paytym/models/report/overtime_list_response_model.dart';
import 'package:paytym/models/report/payslip_response_model.dart';
import 'package:paytym/models/dashboard/request_advance_model.dart';
import 'package:paytym/network/base_controller.dart';
import 'package:paytym/screens/login/login_controller.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/enums.dart';
import '../../../core/constants/strings.dart';
import '../../../core/dialog_helper.dart';
import '../../../models/message_only_response_model.dart';
import '../../../models/report/attendance/attendance_accept_decline_request_model.dart';
import '../../../models/report/deduction_list_admin_model.dart';
import '../../../network/base_client.dart';
import '../../../network/end_points.dart';
import '../chat/chat_controller.dart';
import '../widgets/reason_bottomsheet.dart';
import 'widgets/pay_payment.dart';
import 'widgets/payment_history.dart';
import 'widgets/pending_payroll_listview.dart';

class ReportsControllerAdmin extends GetxController with BaseController {
  final ReceivePort _port = ReceivePort();
  String sharePath = '';
  final selectedDropdownDay = daysDummyList[0].obs;

  //Sharing or downloading enum will be idle at the start
  final isSharingOrDownloading = SharingOrDownloading.idle.obs;
  final payslipResponseModel = PayslipResponseModel().obs;
  final requestAdvanceFormKey = GlobalKey<FormState>();
  RequestAdvanceModel requestAdvanceModel = RequestAdvanceModel();
  final deductionResponseModel = DeductionListAdminModel().obs;
  final overtimeResponseModel =
      OvertimeListResponseModel(message: '', employeeList: []).obs;
  final medicalResponseModel =
      MedicalListAdminModel(message: '', extraDetails: []).obs;
  final attendanceResponseModel =
      AttendanceAdminModel(message: '', history: []).obs;
  String quitCompanyReason = '';

  final selectedDepartment = departments.first.obs;
  final selectedBranch = branches.first.obs;

  final selectedDropdownYear = years.first.obs;
  final payrollClickedButton = 0.obs;

  final chatGroupList = dummy_data.obs;
  int selectedItemIndex = 0;

//for bottomsheet
  showBottomSheetForReason(ReasonButton reasonButton) {
    DialogHelper.showBottomSheet(ReasonBottomSheetAdmin(
      reasonButton: reasonButton,
    ));
  }

  String getTime(String? dateTime) {
    if (dateTime == null) return '-';

    DateTime? dt = DateTime.parse(dateTime);
    return DateFormat.jm().format(dt);
  }

  fetchPayslip() async {
    showLoading();
    Get.find<BaseClient>().onError = fetchPayslip;
    var responseString = await Get.find<BaseClient>()
        .post(
            ApiEndPoints.payslip, null, Get.find<LoginController>().getHeader())
        .catchError(handleError);
    if (responseString == null) {
      return;
    } else {
      hideLoading();
      payslipResponseModel.value = payslipResponseModelFromJson(responseString);
      payslipResponseModel.refresh();
      Get.find<BaseClient>().onError = null;
    }
  }

  requestAdvanceOrSalary(bool isSalary) async {
    showLoading();

    var responseString = await Get.find<BaseClient>()
        .post(
            isSalary
                ? ApiEndPoints.requestPayment
                : ApiEndPoints.requestAdvance,
            requestAdvanceModelToJson(requestAdvanceModel),
            Get.find<LoginController>().getHeader())
        .catchError(handleError);
    if (responseString == null) {
      return;
    } else {
      hideLoading();
      DialogHelper.showToast(
          desc: messageOnlyResponseModelFromJson(responseString).message!);
      requestAdvanceModel = RequestAdvanceModel();
      Get.back();
    }
  }
//todo add onError in getattendance as well. Don't forget '()' will not be present on function

  getOvertime() async {
    showLoading();
    var model = {
      'employer_id': '4'
      // '${Get.find<LoginController>().loginResponseModel?.employee?.employer_id}'
    };
    Get.find<BaseClient>().onError = getOvertime;
    var responseString = await Get.find<BaseClient>()
        .post(ApiEndPoints.getOvertime, jsonEncode(model),
            Get.find<LoginController>().getHeader())
        .catchError(handleError);
    if (responseString == null) {
      return;
    } else {
      hideLoading();
      overtimeResponseModel.value =
          overtimeListResponseModelFromJson(responseString);
      overtimeResponseModel.refresh();
      Get.find<BaseClient>().onError = null;
    }
  }

  getDeduction() async {
    showLoading();
    var model = {
      'employer_id':
          '${Get.find<LoginController>().loginResponseModel?.employee?.employer_id}'
    };
    Get.find<BaseClient>().onError = getDeduction;
    var responseString = await Get.find<BaseClient>()
        .post(ApiEndPoints.deductionsList, jsonEncode(model),
            Get.find<LoginController>().getHeader())
        .catchError(handleError);
    if (responseString == null) {
      return;
    } else {
      hideLoading();
      deductionResponseModel.value =
          deductionListAdminModelFromJson(responseString);
      deductionResponseModel.refresh();
      Get.find<BaseClient>().onError = null;
    }
  }

  deleteDeduction(int index) async {
    // showLoading();
    // var requestModel = {
    //   'id': '${deductionResponseModel.value.details![index]!.id}'
    // };
    // var responseString = await Get.find<BaseClient>()
    //     .post(ApiEndPoints.deleteEvent, jsonEncode(requestModel),
    //         Get.find<LoginController>().getHeader())
    //     .catchError(handleError);
    // if (responseString == null) {
    //   return;
    // } else {
    //   hideLoading();
    //   deductionResponseModel.value.events?.removeAt(index);
    //   deductionResponseModel.refresh();
    // }
  }

  getMedical() async {
    showLoading();
    var model = {
      'employer_id': '4'
      // '${Get.find<LoginController>().loginResponseModel?.employee?.employer_id}'
    };
    Get.find<BaseClient>().onError = getMedical;
    var responseString = await Get.find<BaseClient>()
        .post(ApiEndPoints.medicalList, jsonEncode(model),
            Get.find<LoginController>().getHeader())
        .catchError(handleError);
    if (responseString == null) {
      return;
    } else {
      hideLoading();
      medicalResponseModel.value =
          medicalListAdminModelFromJson(responseString);
      medicalResponseModel.refresh();
      Get.find<BaseClient>().onError = null;
    }
  }

  approveOrDeclineAttendance(ReasonButton reasonButton) async {
    showLoading();
    final model = AttendanceAcceptDeclineRequestModel(
        employeeId: attendanceResponseModel
            .value.history[selectedItemIndex].userId
            .toString(),
        reason: 'ddd',
        approvalStatus:
            reasonButton == ReasonButton.attendanceApprove ? '0' : '1',
        startDate:
            attendanceResponseModel.value.history[selectedItemIndex].date!);
    var responseString = await Get.find<BaseClient>()
        .post(
            ApiEndPoints.attendanceAcceptReject,
            attendanceAcceptDeclineRequestModelToJson(model),
            Get.find<LoginController>().getHeader())
        .catchError(handleError);
    if (responseString == null) {
      return;
    } else {
      hideLoading();
      DialogHelper.showToast(
          desc: messageOnlyResponseModelFromJson(responseString).message ?? '');
    }
  }

  getAttendance() async {
    if (attendanceResponseModel.value.message.isEmpty) {
      showLoading();
      Get.find<BaseClient>().onError = getAttendance;
      var attendanceRequestModel = {
        'employer_id':
            '${Get.find<LoginController>().loginResponseModel?.employee?.employer_id}'
      };
      var responseString = await Get.find<BaseClient>()
          .post(ApiEndPoints.attendance, jsonEncode(attendanceRequestModel),
              Get.find<LoginController>().getHeader())
          .catchError(handleError);
      if (responseString == null) {
        return;
      } else {
        hideLoading();
        attendanceResponseModel.value =
            attendanceAdminModelFromJson(responseString);
        attendanceResponseModel.refresh();
        Get.find<BaseClient>().onError = null;
      }
    }
  }

  Widget getPayrollTab() {
    if (Get.find<ReportsControllerAdmin>().payrollClickedButton.value == 0) {
      return const PendingPayrollListview();
    } else if (Get.find<ReportsControllerAdmin>().payrollClickedButton.value ==
        1) {
      return const PayPayment();
    }
    return const PaymentHistory();
  }

  String formatNumber(String value) {
    final formatNum = NumberFormat('#.00');
    return formatNum.format(int.parse(value));
  }

  downloadPdf(String? url) async {
    if (url != null && url.isNotEmpty) {
      sharePath = '';
      isSharingOrDownloading.value = SharingOrDownloading.downloading;
      await FlutterDownloader.enqueue(
        url: url,
        saveInPublicStorage: true,
        savedDir: '/storage/emulated/0/Download',
        showNotification: true,
        openFileFromNotification: false,
        // fileName: 'payslip.pdf',
      );
    }
  }

  sharePdf(String? url, String? type) async {
    if (type == 'pdf' || type == 'png') {
      isSharingOrDownloading.value = SharingOrDownloading.sharing;
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      if (File('$tempPath/payslip.$type').existsSync()) {
        File('$tempPath/payslip.$type').deleteSync();
      }
      sharePath = '$tempPath/payslip.$type';
      await FlutterDownloader.enqueue(
        url: url!,
        savedDir: tempPath,
        showNotification: false,
        openFileFromNotification: false,
        fileName: 'payslip.$type',
      );
    }
  }

  String? amountValidator(String value) {
    if (value.isEmpty) {
      return 'Value cannot be empty';
    } else if (int.parse(
            payslipResponseModel.value.payroll?.salary ?? '10000') <
        int.parse(value)) {
      return 'Request amount should be less than salary';
    } else if (int.parse(value) < 50) {
      return 'Request amount should be greater than 50';
    }
    return GetUtils.isLengthLessThan(value, 2) ? "Enter a valid number" : null;
  }

  String? notEmptyValidator(String value) {
    return (value.isEmpty) ? 'Value cannot be empty' : null;
  }

  void requestAdvance() {
    if (requestAdvanceFormKey.currentState!.validate()) {
      requestAdvanceFormKey.currentState!.save();
      requestAdvanceOrSalary(false);
    }
  }

  Future<void> requestQuitFromCompany() async {
    if (requestAdvanceFormKey.currentState!.validate()) {
      requestAdvanceFormKey.currentState!.save();
      if (quitCompanyReason.isNotEmpty) {
        showLoading();
        String json = jsonEncode({'requests': quitCompanyReason});
        var responseString = await Get.find<BaseClient>()
            .post(ApiEndPoints.quitCompany, json,
                Get.find<LoginController>().getHeader())
            .catchError(handleError);
        if (responseString == null) {
          return;
        } else {
          hideLoading();
          DialogHelper.showToast(desc: 'Request submitted successfully');
          Get.back();
        }
      }
    }
  }

  void requestPayment() {
    requestAdvanceModel = RequestAdvanceModel(
        amount: payslipResponseModel.value.payroll?.salary ?? '0');
    requestAdvanceOrSalary(true);
  }

  String? descriptionValidator(String value) {
    return GetUtils.isLengthLessThan(value, 5)
        ? "Enter a valid description"
        : null;
  }

  String getDate(String date) {
    final DateTime now = DateTime.parse(date);
    return DateFormat('dd-MM-yyyy').format(now);
  }

  @override
  void onReady() {
    super.onReady();
    fetchPayslip();
  }

  //for downloading

  @override
  void onInit() {
    super.onInit();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      // String id = data[0];
      DownloadTaskStatus status = data[1];
      // int progress = data[2];

      //download completed
      if (status == DownloadTaskStatus.complete) {
        //Download completed from Share button
        if (isSharingOrDownloading.value == SharingOrDownloading.sharing) {
          Share.shareXFiles([XFile(sharePath)]);
          sharePath = '';
          //Download completed from download button
        } else if (isSharingOrDownloading.value ==
            SharingOrDownloading.downloading) {
          DialogHelper.showToast(desc: 'Download completed');
        }
        isSharingOrDownloading.value = SharingOrDownloading.idle;
      } else if (status == DownloadTaskStatus.failed) {
        sharePath = '';
        isSharingOrDownloading.value = SharingOrDownloading.idle;
      }
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  void onClose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.onClose();
  }

  // onClickMenuItem(ReportsDropDown value) {
  //   if (value == ReportsDropDown.payment || value == ReportsDropDown.advance) {
  //     DialogHelper.showBottomSheet(ReportsBottomsheet(
  //       isSalary: value == ReportsDropDown.payment,
  //     ));
  //   } else if (value == ReportsDropDown.logout) {
  //     showLogoutDialog();
  //   } else {
  //     DialogHelper.showBottomSheet(const QuitCompanyBottomSheet());
  //   }
  // }
}
