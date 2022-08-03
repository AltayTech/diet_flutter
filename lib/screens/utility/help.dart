import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/regime/regime_bloc.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends ResourcefulState<Help> {
  late RegimeBloc regimeBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    regimeBloc = RegimeBloc();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // return Container();
    // regimeBloc.helpBodyState(id);
    return  Column(
      children: [
        StreamBuilder<List<Help>>(
            // stream: regimeBloc.helpers,
            builder: (context, AsyncSnapshot<List<Help>> snapshot){
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color:Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(regimeBloc.name),
                          Space(height: 2.h),
                          // id == 2
                          //     ? ImageUtils.fromLocal('assets/images/diet/body-scale-happy.svg',width: 20.w,height: 20.h,)
                          //     : Container(),
                          // Space(height: 2.h),
                          // Text(snapshot.data![0].body!,style: TextStyle(fontSize: 16.0)),
                          Space(height: 2.h),
                          CustomButton(AppColors.btnColor, intl.understand,Size(100.w,8.h),
                                  () => Navigator.of(context).pop())
                        ],
                      ),
                    ),
                  ),
                );
              }
              else
                return Center(
                    child: Container(
                        width:15.w,
                        height: 15.w,
                        child: Progress()));

            }),
      ],
    );
  }

  @override
  void onRetryAfterMaintenance() {
    // TODO: implement onRetryAfterMaintenance
  }

  @override
  void onRetryAfterNoInternet() {
    // TODO: implement onRetryAfterNoInternet
  }

  @override
  void onRetryLoadingPage() {
    // TODO: implement onRetryLoadingPage
  }
  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}