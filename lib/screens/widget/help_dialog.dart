import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/regime/help.dart';
import 'package:behandam/screens/regime/regime_bloc.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';

import 'progress.dart';

class HelpDialog extends StatefulWidget {
  HelpDialog({Key? key, required this.helpId}) : super(key: key);

  final int helpId;

  @override
  State<HelpDialog> createState() => _HelpDialogState();
}

class _HelpDialogState extends ResourcefulState<HelpDialog> {
  late RegimeBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = RegimeBloc();
    bloc.helpBodyState(widget.helpId);
  }

  @override
  Widget build(BuildContext context) {
   super.build(context);

    return StreamBuilder(
        stream: bloc.helpers,
        builder: (context, AsyncSnapshot<List<Help>> snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                width: double.maxFinite,
                decoration: AppDecorations.boxLarge.copyWith(
                  color: AppColors.onPrimary,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Space(height: 2.h),
                      Text(
                        bloc.name,
                        style: typography.bodyText2,
                      ),
                      Space(height: 1.h),
                      if (widget.helpId == 2)
                        ImageUtils.fromLocal(
                          'assets/images/diet/body-scale-happy.svg',
                          width: 20.w,
                          height: 20.h,
                        ),
                      Space(height: 2.h),
                      Text(
                        snapshot.data![0].body!,
                        style: typography.caption,
                      ),
                      Space(height: 2.h),
                      SubmitButton(
                        label: intl.understand,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      Space(height: 2.h),
                    ],
                  ),
                ),
              ),
            );
          } else
            return Center(child: Progress());
        });
  }

}
