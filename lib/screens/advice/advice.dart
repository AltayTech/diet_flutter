import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/advice/advice.dart';
import 'package:behandam/screens/advice/bloc.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';

class AdvicePage extends StatefulWidget {
  const AdvicePage({Key? key}) : super(key: key);

  @override
  State<AdvicePage> createState() => _AdvicePageState();
}

class _AdvicePageState extends ResourcefulState<AdvicePage> {
  late AdviceBloc bloc;
  final List<Map<String, dynamic>> data = [
    {
      'icon': 'assets/images/foodlist/advice/bulb_support.svg',
      'color': AppColors.blueRuler,
      'type': AdviceType.Admin,
    },
    {
      'icon': 'assets/images/foodlist/advice/bulb.svg',
      'color': AppColors.purpleRuler,
      'type': AdviceType.Diet,
    },
    {
      'icon': 'assets/images/foodlist/advice/bulb_plus.svg',
      'color': AppColors.greenRuler,
      'type': AdviceType.Sickness,
    },
    {
      'icon': 'assets/images/foodlist/advice/bulb_plus.svg',
      'color': AppColors.pinkRuler,
      'type': AdviceType.Special,
    },
  ];

  @override
  void initState() {
    super.initState();
    bloc = AdviceBloc();
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
      appBar: Toolbar(titleBar: intl.advices),
      body: SingleChildScrollView(
        child: Card(
          shape: AppShapes.rectangleMedium,
          elevation: 1,
          margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            child: StreamBuilder(
              stream: bloc.advices,
              builder: (_, AsyncSnapshot<AdviceData> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (snapshot.requireData.adminRecommends != null && snapshot.requireData.adminRecommends!.isNotEmpty)
                        advicePart(AdviceType.Admin,
                            snapshot.requireData.adminRecommends!),
                      if (snapshot.requireData.dietTypeRecommends != null && snapshot.requireData.dietTypeRecommends!.isNotEmpty)
                        advicePart(AdviceType.Diet,
                            snapshot.requireData.dietTypeRecommends!),
                      if (snapshot.requireData.sicknessRecommends != null && snapshot.requireData.sicknessRecommends!.isNotEmpty)
                        advicePart(AdviceType.Sickness,
                            snapshot.requireData.sicknessRecommends!),
                      if (snapshot.requireData.specialRecommends != null && snapshot.requireData.specialRecommends!.isNotEmpty)
                        advicePart(AdviceType.Special,
                            snapshot.requireData.specialRecommends!),
                    ],
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget advicePart(AdviceType type, List<dynamic> advices) {
    Map<String, dynamic>? item =
    data.firstWhere((element) => element['type'] == type);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header(type),
        Space(height: 1.h),
        Text(
          intl.beAdvisedTo,
          textAlign: TextAlign.start,
          style: typography.caption?.apply(
            color: item['color'] ?? Colors.green,
          ),
        ),
        ...advices.map((advice) => adviceItem(advice, type)).toList(),
      ],
    );
  }

  Widget header(AdviceType type) {
    Map<String, dynamic> item =
        data.firstWhere((element) => element['type'] == type);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          decoration: AppDecorations.boxMild.copyWith(
            color: item['color'].withOpacity(0.5),
          ),
          padding: EdgeInsets.all(2.w),
          child: ImageUtils.fromLocal(
            'assets/images/foodlist/advice/bulb.svg',
            width: 6.w,
            height: 6.w,
            color: AppColors.iconsColor,
          ),
        ),
        Space(width: 2.w),
        Expanded(
          child: Text(
            adviceHeaderText(type),
            textAlign: TextAlign.start,
            style: typography.subtitle2,
          ),
        ),
      ],
    );
  }

  String adviceHeaderText(AdviceType type) {
    String text = '';
    switch (type) {
      case AdviceType.Admin:
        text = intl.adminAdvice;
        break;
      case AdviceType.Diet:
        text = intl.dietAdvice;
        break;
      case AdviceType.Sickness:
        text = intl.sicknessAdvice;
        break;
      case AdviceType.Special:
        text = intl.specialAdvice;
        break;
    }
    return text;
  }

  Widget adviceItem(dynamic advice, AdviceType type) {
    Map<String, dynamic> item =
        data.firstWhere((element) => element['type'] == type);
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          color: item['color'].withOpacity(0.5),
          padding: EdgeInsets.only(right: 2.w),
          child: Container(
            color: AppColors.box,
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            child: Text(
              advice.text ?? '',
              softWrap: true,
              textAlign: TextAlign.start,
              style: typography.caption,
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