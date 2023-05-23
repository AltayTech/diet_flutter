import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/auth/user_info.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/authentication/authentication_bloc.dart';
import 'package:behandam/screens/widget/custom_button.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:country_calling_code_picker/picker.dart' as picker;
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
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
    getlistCountry();
    authBloc = AuthenticationBloc();
    listenBloc();
  }

  void getlistCountry() async {
    List<picker.Country> list = await picker.getCountries(context);
    authBloc.setListCountry(list);
    authBloc.fetchCountries();
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
        if (event.toString().contains(Routes.auth))
          VxNavigator.of(context).push(Uri.parse('/$event'),
              params: {"mobile": args['mobile'], 'countryId': args['countryId']});
        else
          VxNavigator.of(context).clearAndPush(Uri.parse(Routes.listView));
      }
    });
    authBloc.showServerError.listen((event) {
      Navigator.pop(context);
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
        body: Container(
          decoration: AppDecorations.boxNoRadius.copyWith(
              gradient: const RadialGradient(
                  colors: [Color(0xff6C98FF), Color(0xff364C80)],
                  center: Alignment(0.0, 0.0),
                  stops: [0.0, 1.0],
                  focal: Alignment(0.0, 0.1),
                  focalRadius: 0,
                  radius: 1,
                  tileMode: TileMode.clamp)),
          width: double.infinity,
          height: double.infinity,
          child: StreamBuilder(
              stream: authBloc.waiting,
              builder: (context, snapshot) {
                if (snapshot.data == false && !check) {
                  return NestedScrollView(
                    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          backgroundColor: Color(0xff364C80),
                          elevation: 0.0,
                          leading: IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              color: Colors.white,
                              onPressed: () => VxNavigator.of(context).pop()),
                          // floating: true,
                          forceElevated: innerBoxIsScrolled,
                        ),
                      ];
                    },
                    body: SingleChildScrollView(
                      child: Column(children: [
                        Space(
                          height: 10.h,
                        ),
                        header(),
                        SizedBox(height: 80.0),
                        content(),
                      ]),
                    ),
                  );
                } else {
                  check = false;
                  return Center(child: Container(width: 15.w, height: 15.w, child: Progress()));
                }
              }),
        ),
      ),
    );
  }

  Widget header() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageUtils.fromLocal(
            'assets/images/logo_app.svg',
            width: 150,
            height: 150,
          ),
          Space(
            height: 2.h,
          ),
          Text(
            intl.appNameSplash,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ],
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
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0), color: AppColors.arcColor),
              child: Text(
                "+ ${args['mobile']}",
                textDirection: TextDirection.ltr,
                style: const TextStyle(color: AppColors.penColor),
              )),
          SizedBox(height: 2.h),
          Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: AppColors.arcColor),
            child: TextField(
              obscureText: !_obscureText,
              controller: _text,
              textDirection: TextDirection.ltr,
              decoration: InputDecoration(
                fillColor: AppColors.arcColor,
                filled: true,
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: intl.password,
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
                hintStyle: const TextStyle(color: Colors.black, fontSize: 18.0),
                // errorText: _validate ? intl.fillAllField : null
              ),
              onChanged: (txt) {
                _password = txt;
              },
            ),
          ),
          SizedBox(height: 5.h),
          CustomButton(Colors.white, AppColors.primary, intl.login, Size(100.w, 7.h), () {
            DialogUtils.showDialogProgress(context: context);
            if (_password.length > 0) {
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
              style: TextStyle(fontSize: 16.sp, color: Colors.white),
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
                      Text(intl.no, style: TextStyle(color: AppColors.penColor, fontSize: 10.sp)),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(AppColors.btnColor),
                        fixedSize: MaterialStateProperty.all(Size(20.0, 20.0))),
                    child: Text(
                      intl.yes,
                      style: TextStyle(fontSize: 10.sp),
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
