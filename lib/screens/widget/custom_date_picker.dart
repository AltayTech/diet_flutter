import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/widget/custom_slider.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shamsi_date/shamsi_date.dart';

class CustomDate extends StatefulWidget {
  CustomDate({this.function, String? this.datetime, this.isShowMonth, this.maxYear}) {
    if (isShowMonth == null) isShowMonth = false;
  }

  Function? function;
  String? datetime;
  bool? isShowMonth;
  final int? maxYear;

  @override
  myDate createState() => myDate();

  static List<String> monthsList = [
    'فروردین',
    'اردیبهشت',
    'خرداد',
    'تیر',
    'مرداد',
    'شهریور',
    'مهر',
    'آبان',
    'آذر',
    'دی',
    'بهمن',
    'اسفند',
  ];
}

class myDate extends ResourcefulState<CustomDate> {
  int birthday = 15, birthYear = 1390, birthMonth = 3;
  int selectedIll = 3;
  int _wieghtGramValue = 100;
  MySlider? sliderYear;
  MySlider? sliderMonth;
  MySlider? sliderDay;
  List<int>? yearsList;
  List<int>? daysList;

  void initialSlider() {
    sliderYear = MySlider(
      minValue: yearsList![0],
      maxValue: yearsList![yearsList!.length - 1],
      value: birthYear,
      type: DateType.Year,
      height: 22.h,
      onClick: Click,
      list: yearsList,
      verticalSliderType: VerticalSliderType.Number,
//                  itemExtent: itemExtent
    );

    sliderMonth = MySlider(
      minValue: 1,
      maxValue: 12,
      value: birthMonth,
      type: DateType.Month,
      height: 22.h,
      onClick: Click,
      list: CustomDate.monthsList,
      verticalSliderType: VerticalSliderType.String,
//                  itemExtent: itemExtent
    );

    sliderDay = MySlider(
      minValue: daysList![0],
      maxValue: daysList![daysList!.length - 1],
      value: birthday,
      type: DateType.Day,
      height: 22.h,
      onClick: Click,
      list: daysList,
      verticalSliderType: VerticalSliderType.Number,
//                  itemExtent: itemExtent
    );
  }

  void intialDate(Jalali jalali) {
    if (yearsList == null) {
      yearsList = <int>[];
      daysList = <int>[];
      var forLength = widget.maxYear ?? jalali.year;
      for (int i = 1300; i <= forLength; i++) {
        yearsList!.add(i);
      }
    } else {
      daysList!.clear();
    }
    setState(() {
      for (int day = 1; day <= jalali.monthLength; day++) {
        daysList!.add(day);
      }

      /*if(birthday>daysList.length){
          birthday=daysList[daysList.length-1];
          Fimber.d("${birthday}");
        }*/
    });
  }

  Widget birthDatePopupSlider(int flex, MySlider? slider) {
    //Fimber.d('value value $birthYear / ');
    return Expanded(
      flex: flex,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 22.h,
            alignment: Alignment.center,
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return constraints.isTight ? Container() : slider!;
                },
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 12,
            child: Center(
              child: SvgPicture.asset(
                'assets/images/diet/list_arrow_orange.svg',
                width: 3.w,
                height: 3.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget birthDatePopupTitleBox(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Text(
          text,
          textAlign: TextAlign.center,
          textDirection: context.textDirectionOfLocale,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    Jalali jalali = Jalali.fromDateTime(new DateTime.now());
    /* if(widget.datetime==null) {
      jalali = Jalali.fromDateTime(new DateTime.now());
    }else {
      var dateSplit=widget.datetime.split("-");
      jalali = Gregorian(int.parse(dateSplit[0]),int.parse(dateSplit[1]),int.parse(dateSplit[2])).toJalali();
    }*/
    var dateSplit;
    Jalali date;
    if (widget.datetime != null) {
      dateSplit = widget.datetime!.substring(0, 10).split("-");
      date = Gregorian(int.parse(dateSplit[0]), int.parse(dateSplit[1]), int.parse(dateSplit[2]))
          .toJalali();
    } else {
      dateSplit = DateTime.now().toUtc().toString().substring(0, 10).split("-");
      date =
          Gregorian(int.parse(dateSplit[0]) - 10, int.parse(dateSplit[1]), int.parse(dateSplit[2]))
              .toJalali();
    }

    birthYear = date.year;
    birthday = date.day;
    birthMonth = date.month;
    intialDate(jalali);
    _scrollController = ScrollController(initialScrollOffset: (birthYear - yearsList![0]) * (5.h));
    /* widget.datetime =
        '$birthday ${CustomDate.monthsList[birthMonth - 1]} $birthYear';*/

    initialSlider();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Row(
          textDirection: context.textDirectionOfLocaleInversed,
          children: [
            birthDatePopupTitleBox('${intl.year}', 2),
            SizedBox(width: 3.w),
            birthDatePopupTitleBox('${intl.month}', 3),
            SizedBox(width: 3.w),
            birthDatePopupTitleBox('${intl.day}', 2),
          ],
        ),
        SizedBox(height: 1.h),
        Expanded(
          child: Row(
            textDirection: context.textDirectionOfLocaleInversed,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              birthDatePopupSlider(2, sliderYear),
              SizedBox(width: 3.w),
              birthDatePopupSlider(3, sliderMonth),
              SizedBox(width: 3.w),
              birthDatePopupSlider(2, sliderDay),
            ],
          ),
        ),
      ],
    );
  }

  void Click(changeItem, type) {
    switch (type) {
      case DateType.Year:
        birthYear = changeItem;

        break;
      case DateType.Month:
        birthMonth = changeItem;
        break;
      case DateType.Day:
        birthday = changeItem;
        break;
    }
    print('value is = >  $birthday $birthMonth $birthYear');
    setState(() {
      widget.datetime = "$birthday $birthMonth $birthYear";
      selectedIll;
      Jalali jalali;
      try {
        jalali = new Jalali(birthYear, birthMonth, birthday);
      } on DateException {
        jalali = new Jalali(birthYear, birthMonth, 1);
        birthday = jalali.monthLength;
        jalali = new Jalali(birthYear, birthMonth, birthday);
      }
      final jf = jalali.toGregorian().formatter;
      final j = jalali.formatter;
      if (widget.isShowMonth!)
        widget.function!(widget.datetime);
      else {
        widget.function!("${jf.yyyy}-${jf.mm}-${jf.dd}");
      }
      intialDate(jalali);
      /*  sliderDay.list=daysList;
      sliderDay.maxValue=daysList.length;*/
      initialSlider();
    });
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
