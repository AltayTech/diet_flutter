import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/regime_type.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/regime/regime_bloc.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

class RegimeTypeScreen extends StatefulWidget {
  const RegimeTypeScreen({Key? key}) : super(key: key);

  @override
  _RegimeTypeScreenState createState() => _RegimeTypeScreenState();
}

class _RegimeTypeScreenState extends ResourcefulState<RegimeTypeScreen> {
  late RegimeBloc regimeBloc;
  bool check = false;
  Key? key;
  Color? colorType;
  bool disableClick = false;
  List<bool> activeCard = [false,false,false,false,false,false,false,false];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    regimeBloc = RegimeBloc();
    listenBloc();
  }

  void listenBloc() {
    regimeBloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.redBar,
        title: Center(child: Text(intl.regimeReceive)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0,bottom: 20.0),
                  child: Text(intl.selectYourRegime,textAlign: TextAlign.center,),
                ),
                ListOfTypes(),
                SizedBox(height: 5.h),
                Text(intl.whichRegime,textAlign: TextAlign.center,),
                InkWell(
                  child: SvgPicture.asset('assets/images/physical_report/guide.svg',
                    width: 5.w, height: 5.h),
                  onTap: () => VxNavigator.of(context).push(Uri.parse(Routes.helpType)),
                ),
                SizedBox(height: 5.h)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ListOfTypes(){
    return StreamBuilder(
        stream: regimeBloc.itemList,
        builder: (context, AsyncSnapshot<List<RegimeType>> snapshot){
          if (snapshot.hasData) {
            // print('here:${regimeBloc.type.length}');
            return ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount:snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) => UnconstrainedBox(
                child: Stack(
                  children: [
                    // click(snapshot.data![index].isActive!),
                    Transform.translate(
                      offset: Offset(8.0,4.0),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(30.0),topRight: Radius.circular(30.0)),
                              color: colorType),
                          width: 5.w,
                          height: 8.h),
                    ),
                    InkWell(
                      onTap: activeCard[index]
                          ? () => VxNavigator.of(context).push(Uri.parse(Routes.helpType))
                          : () =>{
                        print('active1: ${snapshot.data!.length}'),
                        Utils.getSnackbarMessage(context, 'به زودی'),
                      },

                      child: Container(
                        width: 80.w,
                        height: 9.h,
                        child: Card(
                          color: AppColors.arcColor,
                          semanticContainer: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30.0),topLeft: Radius.circular(30.0))),
                          // margin: EdgeInsets.only(right: 25.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children:[
                                  Text(snapshot.data![index].title!,
                                      style: TextStyle(color: snapshot.data![index].isActive! == '0' ? AppColors.strongPen : AppColors.penColor)),
                                  setContent(snapshot.data![index].alias!, snapshot.data![index].isActive!, index),
                                ]
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          else{
            check = false;
            return Center(
                child: Container(
                    width:15.w,
                    height: 15.w,
                    child: CircularProgressIndicator(color: Colors.grey,strokeWidth: 1.0)));
          }
        });
  }

  Widget setContent(String type, String active, int index){
    switch(type) {
      case "WEIGHT_LOSS":{
        colorType = AppColors.looseType;
        if(active == '1')
          activeCard[index] = true;
          return SvgPicture.asset('assets/images/diet/loose_weight.svg');
        }
      case "WEIGHT_GAIN":{
          colorType = AppColors.gainType;
          if(active == '1')
            activeCard[index] = true;
          return SvgPicture.asset('assets/images/diet/gain_weight.svg');
        }
      case "STABILIZATION":{
        colorType = AppColors.stableType;
        if(active == '1')
          activeCard[index] = true;
          return SvgPicture.asset('assets/images/diet/fix_weight.svg');
        }
      case "DIABETES":{
          colorType = AppColors.diabetType;
          if(active == '1')
            activeCard[index] = true;
          return SvgPicture.asset('assets/images/diet/diabetes_diet.svg');
        }
      case "PREGNANCY":{
        colorType = AppColors.pregnantType;
        if(active == '1')
          activeCard[index] = true;
          return SvgPicture.asset('assets/images/diet/pregnant_diet.svg');
        }
      case "KETOGENIC":{
          colorType = AppColors.ketoType;
          if(active == '1')
            activeCard[index] = true;
          return SvgPicture.asset('assets/images/diet/fix_weight.svg');
        }
      case "SPORTS":{
        colorType = AppColors.sportType;
        if(active == '1')
          activeCard[index] = true;
          return SvgPicture.asset('assets/images/diet/fix_weight.svg');
        }
      case "NOTRICA":{
        colorType = AppColors.notricaType;
        if(active == '1')
          activeCard[index] = true;
          return SvgPicture.asset('assets/images/diet/gain_weight.svg');
        }
      default:{
        colorType = AppColors.gainType;
        if(active == '1')
          activeCard[index] = true;
          return SvgPicture.asset('assets/images/diet/gain_weight.svg');
        }

    }
  }

  click(String active){
    if(active == 1)
      disableClick = true;
    else
      disableClick = false;
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
}
