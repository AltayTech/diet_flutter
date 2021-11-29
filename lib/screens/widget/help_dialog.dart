import 'package:behandam/data/entity/regime/help.dart';
import 'package:behandam/extensions/build_context.dart';
import 'package:behandam/screens/regime/regime_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'progress.dart';

class HelpDialog extends StatelessWidget {
  HelpDialog({Key? key, required this.helpId}) : super(key: key);
  late RegimeBloc bloc;
  final int helpId;

  @override
  Widget build(BuildContext context) {
    AppLocalizations intl = context.intl;
    TextTheme typography = context.typography;
    bloc = RegimeBloc();
    bloc.helpBodyState(helpId);

    return StreamBuilder(
        stream: bloc.helpers,
        builder: (context, AsyncSnapshot<List<Help>> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(bloc.name),
                      SizedBox(height: 2.h),
                      helpId == 2
                          ? ImageUtils.fromLocal(
                        'assets/images/diet/body-scale-happy.svg',
                        width: 20.w,
                        height: 20.h,
                      )
                          : Container(),
                      SizedBox(height: 2.h),
                      Text(snapshot.data![0].body!,
                          style: TextStyle(fontSize: 16.0)),
                      SizedBox(height: 2.h),
                      button(AppColors.btnColor, intl.understand,
                          Size(100.w, 8.h), () => Navigator.of(context).pop())
                    ],
                  ),
                ),
              ),
            );
          } else
            return Center(
                child: Container(
                    width: 15.w,
                    height: 15.w,
                    child: Progress()));
        });
  }
}
