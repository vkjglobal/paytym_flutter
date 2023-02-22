// const kBaseUrl = 'http://52.40.210.26:2000/api';
const kBaseUrl = 'http://paytym.net/api';
const kMpaisaBaseUrl = 'pay.mpaisa.vodafone.com.fj';
const kDomainUrl = 'paytym.net';

class ApiEndPoints {
  static const login = '$kBaseUrl/login';
  static const logout = '$kBaseUrl/logout';
  static const sendOtp = '$kBaseUrl/send-otp';
  static const confirmOtp = '$kBaseUrl/confirm-otp';
  static const updatePassword = '$kBaseUrl/password-update';
  static const leave = '$kBaseUrl/leave-request';
  static const payslip = '$kBaseUrl/payslip';
  static const checkIn = '$kBaseUrl/check_in';
  static const checkOut = '$kBaseUrl/check_out';
  static const checkInByScan = '$kBaseUrl/check_in_by_scan';
  static const checkOutByScan = '$kBaseUrl/check_out_by_scan';
  static const requestAdvance = '$kBaseUrl/request_advance';
  static const requestPayment = '$kBaseUrl/request_payment';
  static const deductions = '$kBaseUrl/deductions';
  static const meetings = '$kBaseUrl/meetings';
  static const getChat = '$kBaseUrl/get-chat';
  static const sendChat = '$kBaseUrl/send-chat';
  static const quitCompany = '$kBaseUrl/quit_company';
  static const events = '$kBaseUrl/events_list';
  static const sendOtpToEmail = '$kBaseUrl/forgot-password';
  static const confirmOtpWithEmail = '$kBaseUrl/forgotpwd-confirm-otp';
  static const resetPasswordWithEmail = '$kBaseUrl/forgotpwd-password-update';

  static const attendance = '$kBaseUrl/checkin_checkout_list';
  static const holidayRequestAdmin = '$kBaseUrl/list_leaves';
  static const leaveAcceptReject = '$kBaseUrl/leave_requests_accept_reject';
  static const deleteEvent = '$kBaseUrl/delete_event';
  static const createEvent = '$kBaseUrl/create_event';
  static const deleteHoliday = '$kBaseUrl/delete_leave';
  static const createHoliday = '$kBaseUrl/create_leaves';
  static const attendanceAcceptReject = '$kBaseUrl/attendance_approve_reject';
  static const leaveRequestAdmin = '$kBaseUrl/leave_requests_lists';
  static const deductionsList = '$kBaseUrl/deductions_list';
  static const meetingsList = '$kBaseUrl/list_meetings';
  static const medicalList = '$kBaseUrl/extra_details';

  static const createMeetings = '$kBaseUrl/create_meetings';
  static const deleteMeetings = '$kBaseUrl/meetings_delete';
  static const getOvertime = '$kBaseUrl/list_overtime';
}
