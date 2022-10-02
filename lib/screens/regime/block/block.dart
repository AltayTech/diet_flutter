import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/user/block_user.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';

import 'bloc.dart';

class Block extends StatefulWidget {
  const Block({Key? key}) : super(key: key);

  @override
  State<Block> createState() => _BlockState();
}

class _BlockState extends ResourcefulState<Block> {
  late BlockUserBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = BlockUserBloc();
    bloc.loadContent();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: Toolbar(titleBar: intl.needInvestigation),
      body: TouchMouseScrollable(
        child: SingleChildScrollView(
          child:   Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
            constraints: BoxConstraints(minHeight: 80.h),
            child: StreamBuilder<BlockUser>(
                stream: bloc.blockUser,
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return content(snapshot.requireData);
                  else
                    return Center(child: Progress());
                }),
          ),
        ),
      ),
    );
  }

  Widget content(BlockUser blockUser) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageUtils.fromLocal(
          'assets/images/block_user.svg',
          width: 80.w,
          // height: 30.w,
        ),
        titleText(blockUser.title ?? ''),
        Space(height: 4.h),
        descriptionText(blockUser.description ?? intl.blockSickText),
        Space(height: 4.h),
        Center(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: CustomButton(AppColors.btnColor, intl.understand, Size(80.w, 6.h), () {
              Navigator.pop(context);
            }),
          ),
        ),

      ],
    );
  }

  Widget titleText(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, right: 32),
      child: Text(
        title,
        style: typography.caption!.copyWith(fontWeight: FontWeight.w700, fontSize: 14.sp),
        softWrap: true,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget descriptionText(String description) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Text(
        description,
        style: typography.caption!.copyWith(fontWeight: FontWeight.w400, fontSize: 12.sp),
        softWrap: true,
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  void onRetryLoadingPage() {
    if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);

    bloc.onRetryLoadingPage();
  }

  @override
  void onRetryAfterNoInternet() {
    if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);

    bloc.onRetryAfterNoInternet();
  }
}
