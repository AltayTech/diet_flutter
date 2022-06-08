import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/advice/advice.dart';
import 'package:behandam/screens/advice/bloc.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';

class AdvicePage extends StatefulWidget {
  const AdvicePage({Key? key}) : super(key: key);

  @override
  State<AdvicePage> createState() => _AdvicePageState();
}

class _AdvicePageState extends ResourcefulState<AdvicePage> {
  late AdviceBloc bloc;
  String? previousName;
  final List<Map<String, dynamic>> data = [
    {
      'icon': 'assets/images/foodlist/advice/bulb_support.svg',
      'color': AppColors.blueRuler,
      'type': AdviceType.admin,
    },
    {
      'icon': 'assets/images/foodlist/advice/bulb.svg',
      'color': AppColors.purpleRuler,
      'type': AdviceType.diet,
    },
    {
      'icon': 'assets/images/foodlist/advice/bulb_plus.svg',
      'color': AppColors.greenRuler,
      'type': AdviceType.sickness,
    },
    {
      'icon': 'assets/images/foodlist/advice/bulb_plus.svg',
      'color': AppColors.pinkRuler,
      'type': AdviceType.special,
    },
  ];

  @override
  void initState() {
    super.initState();
    bloc = AdviceBloc();
    bloc.loadContent();
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
      body: TouchMouseScrollable(
        child: SingleChildScrollView(
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
                          advicePart(AdviceType.admin,
                              snapshot.requireData.adminRecommends!, snapshot.requireData),
                        if (snapshot.requireData.dietTypeRecommends != null && snapshot.requireData.dietTypeRecommends!.isNotEmpty)
                          advicePart(AdviceType.diet,
                              snapshot.requireData.dietTypeRecommends!, snapshot.requireData),
                        if (snapshot.requireData.sicknessRecommends != null && snapshot.requireData.sicknessRecommends!.isNotEmpty)
                          advicePart(AdviceType.sickness,
                              snapshot.requireData.sicknessRecommends!, snapshot.requireData),
                        if (snapshot.requireData.specialRecommends != null && snapshot.requireData.specialRecommends!.isNotEmpty)
                          advicePart(AdviceType.special,
                              snapshot.requireData.specialRecommends!, snapshot.requireData),
                      ],
                    );
                  }
                  return Center(child: Progress());
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget advicePart(AdviceType type, List<dynamic> advices, AdviceData adviceData) {
    Map<String, dynamic>? item =
    data.firstWhere((element) => element['type'] == type);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header(type),
        Space(height: 1.h),
        if(type != AdviceType.sickness && type != AdviceType.special) Text(
          intl.beAdvisedTo,
          textAlign: TextAlign.start,
          style: typography.caption?.apply(
            color: item['color'] ?? Colors.green,
          ),
        ),
        ...advices.map((advice) => adviceItem(advice, type, adviceData)).toList(),
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
      case AdviceType.admin:
        text = intl.adminAdvice;
        break;
      case AdviceType.diet:
        text = intl.dietAdvice;
        break;
      case AdviceType.sickness:
        text = intl.sicknessAdvice;
        break;
      case AdviceType.special:
        text = intl.specialAdvice;
        break;
    }
    return text;
  }

  Widget adviceItem(dynamic advice, AdviceType type, AdviceData adviceData) {
    Map<String, dynamic> item =
        data.firstWhere((element) => element['type'] == type);
    String? name;
    if(type == AdviceType.sickness){
      advice as SicknessTypeRecommend;
      name = adviceData.userSicknesses?.firstWhere((element) => element.id == advice.pivot.sicknessId).title;
    }
    if(type == AdviceType.special){
      advice as SpecialTypeRecommend;
      name = adviceData.userSpecials?.firstWhere((element) => element.id == advice.pivot.specialId).title;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if((type == AdviceType.sickness || type == AdviceType.special) && name != previousName) Text(
          setText(name!),
          textAlign: TextAlign.start,
          style: typography.caption?.apply(
            color: item['color'] ?? Colors.green,
          ),
        ),
        Container(
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
                  advice?.text ?? '',
                  softWrap: true,
                  textAlign: TextAlign.start,
                  style: typography.caption,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String setText(String name){
    previousName = name;
    return intl.forSomethingBeAdvisedTo(name);
  }

  @override
  void onRetryLoadingPage() {
    bloc.loadContent();
  }

}
