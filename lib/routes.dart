import 'package:flutter/material.dart';


final GlobalKey<ScaffoldMessengerState> navigatorMessengerKey = GlobalKey();

abstract class Routes {
  // static const home = '/home';
  static const login = '/auth';
  static const pass = '/auth/login';
  static const register = '/auth/register';
  static const verify = '/auth/pass/verify';
  static const resetCode = '/resetCode';
  static const resetPass = '/auth/pass/reset';
  static const regimeType = '/reg/diet/type';
  static const helpType = '/help';
  static const profile = '/profile';
  static const listView = '/list/view';
  static const dailyMenu = '/list/daily';
  static const listFood = '/list/food';
  static const fastPatterns = '/list/pattern';
  static const editProfile = '/profile/edit';
  static const inbox = '/profile/inbox';
  static const showInbox = '/profile/inbox/item';
  static const ticket = '/ticket';
  static const ticketCall = '/ticket/call';
  static const ticketMessage = '/ticket/message';
  static const replaceFood = '/list/food/replace';
  static const calendar = '/list/archive';
  static const newTicketMessage = '/ticket/message/new';
  static const detailsTicketMessage = '/ticket/details';
  static const bodyState = '/reg/size';
  static const bodyStatus = '/reg/report';
  static const sickness = '/reg/sick/select';
  static const special_sickness = '/reg/special';
  static const advice = '/list/notice';
  static const package = '/reg/package';
  static const paymentBill = '/reg/payment/bill';
  static const cardToCard = '/reg/payment/card';
  // static const bodyStatus = '/bodyStatus';
  static const resetPasswordProfile = '/resetPasswordProfile';
  static const vitrin = '/vitrin';
  static const psychologyIntro = '/psychologyIntro';
  static const psychologyCalender = '/psychologyCalender';
  static const psychologyTerms = '/psychologyTerms';
  static const psychologyPaymentBill = '/psychologyPaymentBill';
  // static const psychologyPaymentCard = '/psychologyPaymentCard';
  static const psychologyReservedMeeting = '/psychologyReservedMeeting';
  static const activity = '/reg/activity';
  static const paymentCardConfirm = '/reg/payment/card/confirm';
  static const dietHistory = '/reg/diet/history';
  static const dietGoal = '/reg/diet/goal';
  static const paymentFail = '/reg/payment/online/fail';
  static const paymentWaiting = '/reg/payment/card/wait';
  static const overview = '/reg/overview';
  static const menuSelect = '/reg/menu/select';
  static const menuConfirm = '/reg/menu/confirm';
  static const statusUser = '/status';
  static const listMenuAlert = '/list/menu/alert';
  static const listWeightAlert = '/list/weight/alert';
  static const renewAlert = '/renew/alert';
  static const reviveAlert = '/revive/alert';
  static const paymentOnlineSuccess = '/reg/payment/online/success';
  static const listMenuSelect = '/list/menu/select';
  /// All available routes to Navigator
  static final all = <String, Widget Function(BuildContext)>{
    //   home: (context) => HomePage(),
  };
}
