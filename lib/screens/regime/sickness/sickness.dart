import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/regime/user_sickness.dart';
import 'package:behandam/screens/regime/regime_bloc.dart';
import 'package:behandam/screens/regime/sickness/sickness_bloc.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:sizer/sizer.dart';

class SicknessScreen extends StatefulWidget {
  const SicknessScreen({Key? key}) : super(key: key);

  @override
  _SicknessScreenState createState() => _SicknessScreenState();
}

class _SicknessScreenState extends ResourcefulState<SicknessScreen> {
  late SicknessBloc sicknessBloc;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sicknessBloc = SicknessBloc();
    sicknessBloc.getSickness();
    // listenBloc();
  }

/*  void listenBloc() {
    regimeBloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: Toolbar(titleBar: intl.whichRegime),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(height: 5.h),
                Center(
                  child: Text(
                    'دچار چه عارضه یا بیماری هستی؟',
                    textDirection: TextDirection.rtl,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                Space(height: 0.05.h),
                ...sicknessBloc.userSickness.sickness_categories!.map((element) {
                  return _sicknessPartBox(element);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sicknessPartBox(CategorySickness sickness) {
    var index = sicknessBloc.userSickness.sickness_categories?.indexWhere((element) => element == sickness);
    return sickness.sicknesses!= null && sickness.sicknesses!.length > 0
        ? Column(
      children: [
        Text(sickness.title!),
       /* if (index != _illnesses.length - 1) SizedBox(height: _heightSpace * 0.03),
        if (index != _illnesses.length - 1) Divider(height: _heightSpace * 0.005),
        if (index != _illnesses.length - 1) SizedBox(height: _heightSpace * 0.04),
        if (index == _illnesses.length - 1) SizedBox(height: _heightSpace * 0.05),*/
      ],
    )
        : Container();
  }

  Widget _titleBox(String title, Color iconBg) {
    return Text(
      title,
      textAlign: TextAlign.right,
      style: Theme.of(context).textTheme.headline6,
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
}
