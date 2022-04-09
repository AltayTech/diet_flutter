import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> navigatorMessengerKey = GlobalKey();

abstract class Routes {
  // static const home = '/home';
  static const auth = '/auth';
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const passVerify = '/auth/pass/verify';
  static const authVerify = '/auth/verify';
  static const resetCode = '/resetCode';
  static const resetPass = '/auth/pass/reset';
  static const regimeType = '/diet/type';
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
  static const paymentBill = '/payment/bill';
  static const cardToCard = '/reg/payment/card';
  static const resetPasswordProfile = '/resetPasswordProfile';
  static const vitrin = '/vitrin';
  static const psychologyIntro = '/psy/intro';
  static const psychologyCalender = '/psy/calender';
  static const psychologyTerms = '/psy/terms';
  static const psychologyPaymentBill = '/psy/paymentBill';
  static const psychologyReservedMeeting = '/psy/reservedMeeting';
  static const activity = '/activity';
  static const paymentCardConfirm = '/reg/payment/card/confirm';
  static const dietHistory = '/reg/diet/history';
  static const dietGoal = '/reg/diet/goal';
  static const paymentFail = '/reg/payment/online/fail';
  static const paymentWaiting = '/reg/payment/card/wait';
  static const overview = '/reg/overview';
  static const menuSelect = '/reg/menu/select';
  static const menuConfirm = '/reg/menu/confirm';
  static const statusUser = '/status';
  static const weightEnter = '/weight/enter';
  static const listMenuAlert = '/list/menu/alert';
  static const listWeightAlert = '/list/weight/alert';
  static const renewAlert = '/renew/alert';
  static const reviveAlert = '/revive/alert';
  static const paymentOnlineSuccess = '/reg/payment/online/success';
  static const listMenuSelect = '/list/menu/select';
  static const regSickBlock = '/reg/sick/block';
  static const listSickBlock = '/list/sick/block';
  static const reviveSickBlock = '/revive/sick/block';
  static const renewSickBlock = '/renew/sick/block';
  static const regBlock = '/reg/block';
  static const listBlock = '/list/block';
  static const reviveBlock = '/revive/block';
  static const renewBlock = '/renew/block';
  static const splash = '/app';
  static const shopCategory = '/shop/categories';
  static const shopOrders = '/shop/orders';
  static const shopHome = '/shop';
  static const termsApp = '/terms';
  static const targetWeight = '/list/weight/target';

  // static const renewWeightEnter = '/renew/weight';
  static const refund = '/refund';
  static const refundVerify = '/refund/verify';
  static const refundRecord = '/refund/record';
  static const shopProduct = '/shop/product';
  static const shopBill = '/shop/payment/bill';
  static const shopPaymentOnlineSuccess = '/shop/payment/online/success';
  static const dailyMessage = '/dailyMessage';
  static const selectPackageSubscription = '/subscription/select-package';
  static const billSubscription = '/subscription/bill';
  /// All available routes to Navigator
  static final all = <String, Widget Function(BuildContext)>{
    //   home: (context) => HomePage(),
  };
}
