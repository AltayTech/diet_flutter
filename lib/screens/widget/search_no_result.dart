import 'package:flutter/material.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:logifan/widgets/space.dart';
// import 'package:behandam/utils/image.dart';
// import 'package:behandam/widgets/sized_box/space.dart';

class SearchNoResult extends StatefulWidget {
  SearchNoResult([this.message]);

  final String? message;

  @override
  _SearchNoResultState createState() => _SearchNoResultState();
}

class _SearchNoResultState extends ResourcefulState<SearchNoResult> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        Space(height: 10.h),
        // ImageUtils.fromLocal('assets/artwork/no_result_found.png', width: 30.w),
        // Space(height: 2.h),
        Text(widget.message ?? intl.noResultFound, style: typography.caption),
        Space(height: 5.h),
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
