import 'package:behandam/base/errors.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/fast/fast.dart';
import 'package:behandam/screens/fast/bloc.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/search_no_result.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:behandam/extensions/bool.dart';
import 'package:velocity_x/velocity_x.dart';

class FastPatternPage extends StatefulWidget {
  const FastPatternPage({Key? key}) : super(key: key);

  @override
  _FastPatternPageState createState() => _FastPatternPageState();
}

class _FastPatternPageState extends ResourcefulState<FastPatternPage> {
  late FastBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = FastBloc();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: Toolbar(titleBar: intl.fastPatterns),
      body: body(),
    );
  }

  Widget body(){
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          child: StreamBuilder(
            stream: bloc.loadingContent,
            builder: (_, AsyncSnapshot<bool> snapshot){
              if (snapshot.error is NoResultFoundError) {
                return SearchNoResult(intl.foodNotFoundMessage);
              }
              if(snapshot.hasData){
                return content();
              }
              return Center(child: Progress());
            },
          ),
        ),
      ),
    );
  }

  Widget content(){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          intl.selectFastPattern,
          style: typography.caption,
          textAlign: TextAlign.center,
        ),
        Space(height: 2.h),
        StreamBuilder(
          stream: bloc.patterns,
          builder: (_, AsyncSnapshot<List<FastPatternData>> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  ...snapshot.requireData
                      .map((pattern) => item(pattern))
                      .toList(),
                ],
              );
            }
            return EmptyBox();
          },
        ),
      ],
    );
  }

  Widget item(FastPatternData pattern) {
    return GestureDetector(
      onTap: () {
        bloc.changeToFast(pattern);
        VxNavigator.of(context).returnAndPush(true);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 1.h),
        child: Stack(
          children: [
            Container(
              child: ImageUtils.fromLocal(
                'assets/images/foodlist/fasting/fasting_bg.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    pattern.title,
                    style: typography.bodyText2
                        ?.copyWith(color: AppColors.accentColor),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    pattern.description,
                    style: typography.caption?.copyWith(
                      color: AppColors.onPrimary,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ],
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
