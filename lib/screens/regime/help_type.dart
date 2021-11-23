import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/help.dart';
import 'package:behandam/screens/regime/regime_bloc.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../routes.dart';

class HelpTypeScreen extends StatefulWidget {
  const HelpTypeScreen({Key? key}) : super(key: key);

  @override
  _HelpTypeScreenState createState() => _HelpTypeScreenState();
}

class _HelpTypeScreenState extends ResourcefulState<HelpTypeScreen> {
  late RegimeBloc regimeBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    regimeBloc = RegimeBloc();
    regimeBloc.helpMethod(1);
    listenBloc();
  }

  void listenBloc() {
    regimeBloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {

    super.build(context);
    return Scaffold(
      appBar:Toolbar(titleBar: intl.whichRegime),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0,bottom: 20.0,right: 10.0),
                  child: Text(intl.whichRegime),
                ),
                StreamBuilder(
                    stream: regimeBloc.helpers,
                    builder: (context, AsyncSnapshot<List<Help>> snapshot){
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) => UnconstrainedBox(
                            child: Stack(
                              children: [
                                Transform.translate(
                                  offset: Offset(8.0,4.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(15.0),topRight: Radius.circular(15.0)),
                                          color: AppColors.help),
                                      width: 5.w,
                                      height: 21.h),
                                ),
                                Container(
                                  width: 80.w,
                                  height: 22.h,
                                  child: Card(
                                    color: AppColors.arcColor,
                                    semanticContainer: true,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0),topLeft: Radius.circular(15.0))),
                                    // margin: EdgeInsets.only(right: 25.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(snapshot.data![index].body!,style: TextStyle(fontSize: 16.0)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      else{
                        return Center(
                            child: Container(
                                width:15.w,
                                height: 15.w,
                                child: CircularProgressIndicator(color: Colors.grey,strokeWidth: 1.0)));
                      }
                    }),
                SizedBox(height: 5.h)
              ],
            ),
          ),
        ),
      ),
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
