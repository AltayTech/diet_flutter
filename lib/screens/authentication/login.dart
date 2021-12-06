import 'package:behandam/base/utils.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/auth/user_info.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/utility/modal.dart';
import 'package:behandam/screens/authentication/authentication_bloc.dart';
import 'package:behandam/screens/authentication/auth.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:behandam/screens/utility/arc.dart';
import '../../routes.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ResourcefulState<LoginScreen> {
  final _text = TextEditingController();
  late Map<String, dynamic> args;
  bool _validate = false;
  bool _obscureText = false;
  String _password="";
  late AuthenticationBloc authBloc;
  bool check = false;

  @override
  void initState() {
    super.initState();
    authBloc = AuthenticationBloc();
    listenBloc();
  }

  @override
  void dispose() {
    authBloc.dispose();
    super.dispose();
  }

  void listenBloc() {
    authBloc.navigateToVerify.listen((event) {
      //Navigator.pop(context);
      if (!event.toString().isEmptyOrNull) {
        check = true;
        VxNavigator.of(context).clearAndPush(Uri.parse('/$event'), params: {"mobile": args['mobile'], 'countryId': args['countryId']});
      }
    });
    authBloc.showServerError.listen((event) {
      Navigator.pop(context);
    });
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    debugPrint('login args $args');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder(
            stream: authBloc.waiting,
            builder: (context, snapshot) {
              if (snapshot.data == false && !check) {
                return NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        backgroundColor: AppColors.arcColor,
                        elevation: 0.0,
                        leading: IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            color: Color(0xffb4babb),
                            onPressed: () => VxNavigator.of(context).pop()),
                        // floating: true,
                        forceElevated: innerBoxIsScrolled,
                      ),
                    ];
                  },
                  body: SingleChildScrollView(
                    child: Column(children: [
                      header(),
                      SizedBox(height: 80.0),
                      content(),
                    ]),
                  ),
                );
              } else {
                check = false;
                return Center(
                    child: Container(
                        width: 15.w, height: 15.w, child: Progress()));
              }
            }),
      ),
    );
  }

  Widget header() {
    return Stack(
      // alignment: Alignment.center,
      // fit: StackFit.loose,
      overflow: Overflow.visible,
      children: [
        RotatedBox(quarterTurns: 90, child: MyArc(diameter: 150)),
        Positioned(
          top: 0.0,
          right: 0.0,
          left: 0.0,
          child: Center(
              child: Text(intl.login,
                  style: TextStyle(
                      color: AppColors.penColor,
                      fontSize: 22.0,
                      fontFamily: 'Iransans-Bold',
                      fontWeight: FontWeight.w700))),
        ),
        Positioned(
          top: 60.0,
          right: 0.0,
          left: 0.0,
          child: Center(
            child: ImageUtils.fromLocal(
              'assets/images/registry/profile_logo.svg',
              width: 120.0,
              height: 120.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget content() {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, left: 20.0),
      child: Column(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: AppColors.arcColor),
              child: Text(
                "+ ${args['mobile']}",
                textDirection: TextDirection.ltr,
                style: TextStyle(color: AppColors.penColor),
              )),
          SizedBox(height: 2.h),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: AppColors.arcColor),
            child: TextField(
              obscureText: !_obscureText,
              controller: _text,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.penColor)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.penColor),
                    borderRadius: BorderRadius.circular(15.0)),
                labelText: intl.password,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.penColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                labelStyle:
                    TextStyle(color: AppColors.penColor, fontSize: 18.0),
                // errorText: _validate ? intl.fillAllField : null
              ),
              onChanged: (txt) {
                _password = txt;
              },
            ),
          ),
          SizedBox(height: 10.h),
          button(AppColors.btnColor, intl.login, Size(100.w, 8.h), () {
            DialogUtils.showDialogProgress(context: context);
            if(_password.length>0) {
              User user = User();
              user.mobile = args['mobile'];
              user.password = _password;
              authBloc.passwordMethod(user);
            }
          }),
          SizedBox(height: 10.h),
          InkWell(
            child: Text(
              intl.forgetPassword,
              style: TextStyle(fontSize: 16.sp, color: AppColors.penColor),
            ),
            onTap: () => DialogUtils.showDialogPage(
              context: context,
              child: changePassDialog(),
            ),
          )
        ],
      ),
    );
  }

  Widget changePassDialog() {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        width: double.maxFinite,
        decoration: AppDecorations.boxLarge.copyWith(
          color: AppColors.onPrimary,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(intl.changePassword),
            Container(
              width: 70.w,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: intl.textChangePass1,
                  style: TextStyle(fontSize: 14.sp, color: AppColors.penColor),
                  children: <TextSpan>[
                    TextSpan(
                        text: '${args['mobile']}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: intl.textChangePass2),
                  ],
                ),
              ),
            ),
            ButtonBar(
              mainAxisSize: MainAxisSize.min,
              alignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(AppColors.btnColor),
                        fixedSize: MaterialStateProperty.all(Size(80.0, 50.0))),
                    child: Text(
                      intl.no,
                      style: TextStyle(fontSize: 22.0),
                    ),
                    onPressed: () => Navigator.pop(context)),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(AppColors.btnColor),
                        fixedSize: MaterialStateProperty.all(Size(80.0, 50.0))),
                    child: Text(
                      intl.yes,
                      style: TextStyle(fontSize: 22.0),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      DialogUtils.showDialogProgress(context: context);
                      MemoryApp.forgetPass = true;
                      authBloc.sendCodeMethod(args['mobile']);
                      // context.vxNav.push(Uri.parse(Routes.resetCode), params: args);
                    })
              ],
            )
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
