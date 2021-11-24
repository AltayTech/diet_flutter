import 'package:flutter/material.dart';


final GlobalKey<ScaffoldMessengerState> navigatorMessengerKey = GlobalKey();

abstract class Routes {
  static const home = '/home';
  static const login = '/login';
  static const pass = '/pass';
  static const register = '/register';
  static const verify = '/verify';
  static const resetCode = '/resetCode';
  static const resetPass = '/resetPass';
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
  static const vitrin = '/vitrin';
  static const PSYIntro = '/PSYIntro';
  static const PSYCalender = '/PSYCalender';
  static const PSYTerms = '/PSYTerms';
  static const PSYPaymentBill = '/PSYPaymentBill';
  // static const PSYPaymentCard = '/PSYPaymentCard';
  static const paymentCardConfirm = '/reg/payment/card/confirm';

  /// All available routes to Navigator
  static final all = <String, Widget Function(BuildContext)>{
    //   home: (context) => HomePage(),
  };
}
