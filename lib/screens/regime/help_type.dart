import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/help.dart';
import 'package:behandam/screens/regime/regime_bloc.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:logifan/widgets/space.dart';
import 'package:behandam/widget/sizer/sizer.dart';

class HelpTypeScreen extends StatefulWidget {
  const HelpTypeScreen({Key? key}) : super(key: key);

  @override
  _HelpTypeScreenState createState() => _HelpTypeScreenState();
}

class _HelpTypeScreenState extends ResourcefulState<HelpTypeScreen> {
  late RegimeBloc regimeBloc;
  late HelpPage helpType;

  @override
  void initState() {
    super.initState();
    regimeBloc = RegimeBloc();
    listenBloc();
  }

  bool isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {
      isInit = true;
      helpType = ModalRoute.of(context)!.settings.arguments as HelpPage;
      if (helpType == HelpPage.regimeType) regimeBloc.helpMethod(1);
      if (helpType == HelpPage.menuType) regimeBloc.helpMethod(2);
      if (helpType == HelpPage.packageType) regimeBloc.helpMethod(3);
    }
  }

  @override
  void dispose() {
    regimeBloc.dispose();
    super.dispose();
  }

  void listenBloc() {
    regimeBloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder(
      stream: regimeBloc.helpTitle,
      builder: (_, AsyncSnapshot<String> snapshot) {
        return Scaffold(
          appBar: Toolbar(
            titleBar: snapshot.data ?? intl.whichRegime,
          ),
          body: body(),
        );
      },
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Card(
        shape: AppShapes.rectangleMedium,
        elevation: 1,
        margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder(
                stream: regimeBloc.helpTitle,
                builder: (_, AsyncSnapshot<String> snapshot) {
                  return Text(
                    snapshot.data ?? '',
                    style: typography.subtitle2,
                  );
                },
              ),
              Space(height: 1.h),
              // helpType == HelpPage.packageType ? media(0) : Container(),
              Space(height: 1.h),
              helps(),
              Space(height: 1.h),
              // helpType == HelpPage.packageType ? media(1) : Container(),
              SizedBox(height: 5.h)
            ],
          ),
        ),
      ),
    );
  }

  Widget item(Help help) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: ClipRRect(
        borderRadius: AppBorderRadius.borderRadiusSmall,
        child: Container(
          color: AppColors.primary.withOpacity(0.1),
          padding: EdgeInsets.only(right: 3.w),
          child: Container(
            color: AppColors.box,
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            child: Text(
              help.body ?? '',
              style: typography.caption,
            ),
          ),
        ),
      ),
    );
  }

  Widget helps() {
    return StreamBuilder(
      stream: regimeBloc.help,
      builder: (context, AsyncSnapshot<Help> snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...snapshot.requireData.helpers!.map((help) => item(help)).toList(),
              ...snapshot.requireData.media!
                  .map((media) => ImageUtils.fromNetwork(
                      FlavorConfig.instance.variables["baseUrlFile"] + media.url,
                      width: 10.w,
                      height: 20.h))
                  .toList(),
              // .map((help) => item(help))
              // .toList(),
            ],
          );
        } else {
          return Center(
            child: Container(
              width: 15.w,
              height: 15.w,
              child: CircularProgressIndicator(color: Colors.grey, strokeWidth: 1.0),
            ),
          );
        }
      },
    );
  }

  Widget media(int index) {
    return StreamBuilder(
      stream: regimeBloc.helpMedia,
      builder: (context, AsyncSnapshot<List<Help>> snapshot) {
        if (snapshot.hasData) {
          // return Column(
          //   crossAxisAlignment: CrossAxisAlignment.stretch,
          //   children: [
          //     ...snapshot.requireData
          //         .map((media) => ImageUtils.fromNetwork(FlavorConfig.instance.variables["baseUrlFile"]+media.url,
          //     width: 10.w,
          //     height: 20.h))
          //         .toList(),
          //   ],
          // );
          return ImageUtils.fromNetwork(
              FlavorConfig.instance.variables["baseUrlFile"] + snapshot.data![index].url,
              width: 10.w,
              height: 20.h);
        } else {
          return Container();
        }
      },
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
