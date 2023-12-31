import 'dart:convert';
import 'package:get/get.dart';
import 'package:paytym/models/report/employee_list_model.dart';
import 'package:paytym/network/base_controller.dart';

import '../../../models/branch_dept_list_model.dart';
import '../../../network/base_client.dart';
import '../../../network/end_points.dart';
import '../../login/login_controller.dart';

class DashboardControllerAdmin extends GetxController with BaseController {
  final employeeList = EmployeeListModel(employeeList: []).obs;
  final branchDeptList =
      BranchDeptListModel(branches: [], departments: [], message: '').obs;
  Map<String, List<EmployeeList>> branchwiseEmployeeMap = {};
  Map<String, List<EmployeeList>> deptwiseEmployeeMap = {};

  seeDetailsPage(index) {
    switch (index) {
      case 0:
        Get.find<LoginController>().initialIndex = 3;
        Get.find<LoginController>().bottomNavigationAdminIndex.value = 4;
        break;
      case 1:
        Get.find<LoginController>().initialIndex = 4;
        Get.find<LoginController>().bottomNavigationAdminIndex.value = 4;
        break;
      case 2:
        Get.find<LoginController>().bottomNavigationAdminIndex.value = 1;
        break;
      case 3:
        Get.find<LoginController>().bottomNavigationAdminIndex.value = 2;
        break;
    }
  }

  @override
  void onReady() {
    super.onReady();
    // fetchDashboardData();
    fetchEmployeeList();
  }

  // fetchDashboardData() async {
  //   showLoading();
  //   Get.find<BaseClient>().onError = fetchDashboardData;

  //   var responseString = await Get.find<BaseClient>()
  //       .post(ApiEndPoints.leaveAdmin, null,
  //           Get.find<LoginController>().getHeader())
  //       .catchError(handleError);
  //   if (responseString == null) {
  //     return;
  //   } else {
  //     hideLoading();
  //     // leaveAdminResponseModel.value =
  //     //     leavesAdminResponseModelFromJson(responseString);
  //     Get.find<BaseClient>().onError = null;
  //   }
  // }

  fetchEmployeeList() async {
    if (employeeList.value.message.isEmpty) {
      Get.find<BaseClient>().onError = fetchEmployeeList;
      var requestModel = {
        'employer_id':
            '${Get.find<LoginController>().loginResponseModel?.employee?.employer_id}'
      };
      var responseString = await Get.find<BaseClient>()
          .post(ApiEndPoints.employeeList, jsonEncode(requestModel),
              Get.find<LoginController>().getHeader())
          .catchError(handleError);
      if (responseString == null) {
        return;
      } else {
        employeeList.value = employeeListModelFromJson(responseString);
        Get.find<BaseClient>().onError = null;
        classifyEmployeeListByBranchAndDept();
        fetchBranchDeptList();
      }
    }
  }

  classifyEmployeeListByBranchAndDept() {
    for (var element in employeeList.value.employeeList) {
      if (!branchwiseEmployeeMap.keys.contains(element.branchId.toString())) {
        branchwiseEmployeeMap[element.branchId.toString()] = [element];
      } else {
        branchwiseEmployeeMap[element.branchId.toString()]!.add(element);
      }
      if (!deptwiseEmployeeMap.keys.contains(element.departmentId.toString())) {
        deptwiseEmployeeMap[element.departmentId.toString()] = [element];
      } else {
        deptwiseEmployeeMap[element.departmentId.toString()]!.add(element);
      }
    }
  }

  fetchBranchDeptList() async {
    if (branchDeptList.value.message.isEmpty) {
      Get.find<BaseClient>().onError = fetchBranchDeptList;
      var requestModel = {
        //todo change employer id
        'employer_id': '4'
        // '${Get.find<LoginController>().loginResponseModel?.employee?.employer_id}'
      };
      var responseString = await Get.find<BaseClient>()
          .post(ApiEndPoints.branchDeptList, jsonEncode(requestModel),
              Get.find<LoginController>().getHeader())
          .catchError(handleError);
      if (responseString == null) {
        return;
      } else {
        branchDeptList.value = branchDeptListModelFromJson(responseString);
        Get.find<BaseClient>().onError = null;
      }
    }
  }
}
