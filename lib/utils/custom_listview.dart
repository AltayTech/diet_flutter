// import 'package:behandam/base/resourceful_state.dart';
// import 'package:behandam/base/utils.dart';
// import 'package:behandam/data/entity/auth/country.dart';
// import 'package:behandam/data/entity/user/city_provice_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
//
// enum ListTypeItem { Country, City, Province }
// class CustomListView extends StatefulWidget {
//
//   @override
//   CustomListViewState createState() => CustomListViewState();
// }
//
//
// class CustomListViewState extends ResourcefulState<CustomListView> {
//
//
//   // CustomListViewState(ListTypeItem? typeItem){
//   //    switch (typeItem) {
//   //     case ListTypeItem.Province:
//   //         future = getProvince();
//   //       break;
//   //     case ListTypeItem.City:
//   //         future = getCities();
//   //       break;
//   //     case ListTypeItem.Country:
//   //       // TODO: Handle this case.
//   //       break;
//   //   }
//   // }
//   Future? future;
//
//
//   String search="";
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//
//     switch (widget.typeItem) {
//       case ListTypeItem.Province:
//         return FutureBuilder(
//           future: future,
//           builder: (ctx, snapshot) {
//               return Container(
//                   alignment: Alignment.center,
//                   width: double.maxFinite,
//                   child: Column(
//                     mainAxisSize:MainAxisSize.min ,
//                     children: [
//                       CustomTextBox(
//                         lable: "جستجو",
//                         text: "",
//                         onChange: (String text) {
//                           setState(() {
//                             search=text;
//                             widget.filterListProvince = widget.provinces
//                                 .where((province) => province.name!
//                                 .toLowerCase()
//                                 .contains(text.toLowerCase()))
//                                 .toList();
//                           });
//
//                         },
//                         itemType: TextBoxItem.TextBox,
//                         autofocus: false,
//                         color: Colors.white,
//                         hint: "",
//                         maxLine: 1,
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: Padding(
//                           padding: EdgeInsets.all(12),
//                           child: ListView.separated(
//                             shrinkWrap: true,
//                             itemCount: widget.filterListProvince.length,
//                             scrollDirection: Axis.vertical,
//                             separatorBuilder: (ctx, index) => Divider(),
//                             itemBuilder: (BuildContext context, int index) {
//                               return GestureDetector(
//                                 onTap: () => {
//                                   widget.function!(widget.filterListProvince[index]),
//                                   widget.functionText!(
//                                       widget.filterListProvince[index].name),
//                                   Navigator.pop(context)
//                                 },
//                                 child: Container(
//                                   padding: EdgeInsets.only(right: 8),
//                                   child: Text(
//                                     '${widget.filterListProvince[index].name}',
//                                     textAlign: TextAlign.center,
//                                     style: Utils.styleTextMediumBlack.copyWith(
//                                         color: Color(0xff53576B), fontSize: 20),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       )
//                     ],
//                   ));
//           },
//         );
//         break;
//       case ListTypeItem.City:
//         return FutureBuilder(
//           future: future,
//           builder: (ctx, snapshot) {
//               return Container(
//                   alignment: Alignment.center,
//                   width: double.maxFinite,
//                   child: Column(
//                     children: [
//                       CustomTextBox(
//                         lable: "جستجو",
//                         text: search,
//                         onChange: (String text) {
//                           setState(() {
//                             search=text;
//                             widget.filterListCity = widget.cities
//                                 .where((city) => city.name!
//                                 .toLowerCase()
//                                 .contains(text.toLowerCase()))
//                                 .toList();
//                           });
//
//                         },
//                         itemType: TextBoxItem.TextBox,
//                         autofocus: false,
//                         color: Colors.white,
//                         hint: "",
//                         maxLine: 1,
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: Padding(
//                           padding: EdgeInsets.all(12),
//                           child: ListView.separated(
//                             shrinkWrap: true,
//                             itemCount: widget.filterListCity.length,
//                             scrollDirection: Axis.vertical,
//                             separatorBuilder: (ctx, index) => Divider(),
//                             itemBuilder: (BuildContext context, int index) {
//                               return GestureDetector(
//                                 onTap: () => {
//                                   widget.function!(widget.filterListCity[index]),
//                                   widget.functionText!(widget.filterListCity[index].name),
//                                   Navigator.pop(context)
//                                 },
//                                 child: Container(
//                                   width: double.maxFinite,
//                                   padding: EdgeInsets.only(right: 8),
//                                   child: Text(
//                                     '${widget.filterListCity[index].name}',
//                                     textAlign: TextAlign.center,
//                                     style: Utils.styleTextMediumBlack.copyWith(
//                                         color: Color(0xff53576B), fontSize: 20),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       )
//                     ],
//                   ));
//           },
//         );
//         break;
//       case ListTypeItem.Country:
//         return Container(
//             alignment: Alignment.center,
//             width: double.maxFinite,
//             height:
//             SizeConfig.blockSizeVertical*54,
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 CustomTextBox(
//                   lable: "جستجو",
//                   text: "",
//                   onChange: (String text) {
//                     setState(() {
//                       widget.filterList = widget.countries
//                           .where((country) =>
//                       country.name!
//                           .toLowerCase()
//                           .contains(text.toLowerCase()) ||
//                           country.code!
//                               .toLowerCase()
//                               .contains(text.toLowerCase()))
//                           .toList();
//                     });
//
//                   },
//                   itemType: TextBoxItem.TextBox,
//                   autofocus: false,
//                   color: Colors.white,
//                   hint: "",
//                   maxLine: 1,
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Padding(
//                     padding: EdgeInsets.all(12),
//                     child: ListView.separated(
//                       shrinkWrap: true,
//                       itemCount: widget.filterList.length,
//                       scrollDirection: Axis.vertical,
//                       separatorBuilder: (ctx, index) => Divider(),
//                       itemBuilder: (BuildContext context, int index) {
//                         return GestureDetector(
//                           onTap: () => {
//                             widget.function!(widget.filterList[index]),
//                             Navigator.pop(context)
//                           },
//                           child: Container(
//                             padding: EdgeInsets.only(right: 8),
//                             child: Text(
//                               '+${widget.filterList[index].code}   ${widget.filterList[index].name}',
//                               style: Utils.styleTextMediumBlack.copyWith(
//                                   color: Color(0xff53576B), fontSize: 20),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 )
//               ],
//             ));
//     }
//   }
//
//   @override
//   void onRetryAfterMaintenance() {
//     // TODO: implement onRetryAfterMaintenance
//   }
//
//   @override
//   void onRetryAfterNoInternet() {
//     // TODO: implement onRetryAfterNoInternet
//   }
//
//   @override
//   void onRetryLoadingPage() {
//     // TODO: implement onRetryLoadingPage
//   }
//
//   @override
//   void onShowMessage(String value) {
//     // TODO: implement onShowMessage
//   }
// }
