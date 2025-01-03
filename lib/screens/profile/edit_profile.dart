import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/profile/profile_bloc.dart';
import 'package:behandam/screens/profile/profile_provider.dart';
import 'package:behandam/screens/profile/toolbar_edit_profile.dart';
import 'package:behandam/screens/profile/user_box.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logifan/widgets/space.dart';
import 'package:country_calling_code_picker/picker.dart' as picker;

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen();

  @override
  State createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ResourcefulState<EditProfileScreen> {
  late ProfileBloc profileBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileBloc = ProfileBloc();
    getlistCountry();
    /* profileBloc.showServerError.listen((event) {

    });*/
  }
  void getlistCountry() async {
    List<picker.Country> list = await picker.getCountries(context);
    profileBloc.getInformation(list);
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProfileProvider(profileBloc,
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: Toolbar(titleBar: intl.editProfile),
            body: body(),
          ),
        ));
  }

  Widget body() {
    return Container(
      height: 100.h,
      child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                  child: StreamBuilder(
                      stream: profileBloc.progressNetwork,
                      builder: (context, AsyncSnapshot<bool> snapshot) {
                        if (snapshot.data == null || snapshot.data == true) {
                          return Center(
                            child: SpinKitCircle(
                              size: 5.h,
                              color: AppColors.primary,
                            ),
                          );
                        } else {
                          return content();
                        }
                      })),
              flex: 1,
            ),
          ]),
    );
  }

  Widget content() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ToolbarEditProfile(),
            UserBox(),
            SubmitButton(
              onTap: () {
                profileBloc.edit(context);
              },
              label: intl.acceptEdit,
            ),
            Space(height: 1.h,)
          ],
        ),
        scrollDirection: Axis.vertical,
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
