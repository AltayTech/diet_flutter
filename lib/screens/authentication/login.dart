import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/auth/user_info.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/authentication/auth_header.dart';
import 'package:behandam/screens/authentication/authentication_bloc.dart';
import 'package:behandam/screens/utility/arc.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../routes.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ResourcefulState<LoginScreen> {
  final _text = TextEditingController();
  late Map<String, dynamic> args;
  bool _obscureText = false;
  String _password = "";
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
      Navigator.pop(context);
      if (!event.toString().isEmptyOrNull) {
        check = true;
        if (event.toString().contains(Routes.auth.substring(1)))
          VxNavigator.of(context).push(Uri.parse('/$event'),
              params: {"mobile": args['mobile'], 'countryId': args['countryId']});
        else
          VxNavigator.of(context).clearAndPush(Uri.parse(Routes.listView));
      }
    });
    authBloc.showServerError.listen((event) {
      VxNavigator.of(context).pop();
      Utils.getSnackbarMessage(context, event);
    });
  }

  bool isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {
      isInit = true;
      args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      debugPrint('login args $args');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.arcColor,
          elevation: 0.0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Color(0xffb4babb),
              onPressed: () => VxNavigator.of(context).pop()),
        ),
        body: StreamBuilder(
            stream: authBloc.waiting,
            builder: (context, snapshot) {
              if (snapshot.data == false && !check) {
                return TouchMouseScrollable(
                    child: SingleChildScrollView(
                      child: Column(children: [
                          AuthHeader(title: intl.login,),
                        content(),
                      ]),
                    ));
              } else {
                check = false;
                return Center(child: Container(width: 15.w, height: 15.w, child: Progress()));
              }
            }),
      ),
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
                  borderRadius: BorderRadius.circular(15.0), color: AppColors.arcColor),
              child: Text(
                "+ ${args['mobile']}",
                textDirection: TextDirection.ltr,
                style: TextStyle(color: AppColors.penColor),
              )),
          Space(height: 2.h),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0), color: AppColors.arcColor),
            child: TextField(
              controller: _text,
              textDirection: TextDirection.ltr,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.penColor),
                      borderRadius: BorderRadius.circular(15.0)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  // enabledBorder: OutlineInputBorder(
                  //   borderSide: BorderSide(color: Colors.grey)),
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
                  // errorText: _validate ? intl.fillAllField : null,
                labelStyle: TextStyle(color: AppColors.penColor, fontSize: 12.sp),),
              obscureText: !_obscureText,
              onSubmitted: (String) {
                clickButton();
              },
              onChanged: (txt) {
                _password = txt;
              },
            ),
          ),
          SizedBox(height: 8.h),
          button(AppColors.btnColor, intl.login, Size(100.w, 8.h), clickButton),
          SizedBox(height: 8.h),
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
            Text(intl.changePassword, style: typography.bodyText2),
            Container(
              width: 70.w,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: intl.textChangePass1,
                  style: TextStyle(fontSize: 14.sp, color: AppColors.penColor),
                  children: <TextSpan>[
                    TextSpan(
                        text: '${args['mobile']}', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: intl.textChangePass2),
                  ],
                ),
              ),
            ),
            ButtonBar(
              mainAxisSize: MainAxisSize.min,
              alignment: MainAxisAlignment.start,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size(8.w, 5.h)),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    foregroundColor: MaterialStateProperty.all(AppColors.penColor),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                  ),
                  child:
                      Text(intl.no, style: TextStyle(color: AppColors.penColor, fontSize: 16.sp)),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(AppColors.btnColor),
                        fixedSize: MaterialStateProperty.all(Size(10.0, 20.0))),
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

  void clickButton() {
    if (_password.length > 0) {
      User user = User();
      user.mobile = args['mobile'];
      user.password = _password;
      DialogUtils.showDialogProgress(context: context);
      authBloc.passwordMethod(user);
    } else
      Utils.getSnackbarMessage(context, intl.pleaseEnterPassword);
  }
}
