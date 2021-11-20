import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/regime/user_sickness.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/widget/bottom_triangle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logifan/widgets/space.dart';
import 'package:sizer/sizer.dart';

abstract class ItemClick {
  click();
}

class SicknessDialog extends StatefulWidget {
  late CategorySickness items;
  late ItemClick itemClick;

  SicknessDialog({required this.items, required this.itemClick});

  @override
  _SicknessDialogState createState() => _SicknessDialogState();
}

class _SicknessDialogState extends ResourcefulState<SicknessDialog> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Widget _itemWithTickChild(
      {required Widget child,
      required Sickness current,
      required CategorySickness category,
      required ItemClick itemClick}) {
    return Container(
      width: double.maxFinite,
      height: 9.h,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 2,
            right: 0,
            left: 0,
            child: Center(
              child: Container(
                // padding: EdgeInsets.all(_widthSpace * 0.06),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: current.isSelected!
                      ? [
                          BoxShadow(
                            color: Color.fromRGBO(255, 241, 241, 1),
                            // color: current['shadow'],
                            blurRadius: 3.0,
                            spreadRadius: 2.0,
                          ),
                        ]
                      : null,
                ),
                child: CircleAvatar(
                  backgroundColor:
                      current.isSelected! ? Colors.white : Color.fromRGBO(239, 239, 239, 1),
                  radius: 4.w,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 1.h),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SvgPicture.asset(
                        'assets/images/bill/tick.svg',
                        width: 5.w,
                        height: 5.w,
                        color: current.isSelected!
                            ? Color.fromRGBO(255, 128, 128, 1)
                            : Color.fromARGB(255, 217, 217, 217),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 60.w,
              height: 6.5.h,
              margin: EdgeInsets.fromLTRB(0.5.w, 0.5.h, 0.5.w, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: current.isSelected!
                    ? [
                        BoxShadow(
                          color: Color.fromRGBO(255, 241, 241, 1),
                          // color: current['shadow'],
                          blurRadius: 3.0,
                          spreadRadius: 2.0,
                        ),
                      ]
                    : null,
              ),
              child: child,
            ),
          ),
          Positioned(
            bottom: 2,
            right: 0,
            left: 0,
            child: Center(
              child: InkWell(
                onTap: () => setState(() {
                  category.children?.forEach((item) {
                    item.isSelected = false;
                    current.isSelected = false;
                  });
                  current.isSelected = true;
                  category.isSelected = true;
                  Navigator.of(context).pop();
                  itemClick.click();
                }),
                child: Container(
                  child: CircleAvatar(
                    backgroundColor:
                        current.isSelected! ? Colors.white : Color.fromRGBO(239, 239, 239, 1),
                    radius: 4.w,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SvgPicture.asset(
                          'assets/images/bill/tick.svg',
                          width: 3.w,
                          height: 3.w,
                          color: current.isSelected! ? null : Color.fromARGB(255, 217, 217, 217),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget illItemChild(bool isSelected, Sickness sickness) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.items.children?.forEach((item) {
            item.isSelected = false;
            widget.items.isSelected = false;
          });
          sickness.isSelected = true;
          widget.items.isSelected = true;
          Navigator.of(context).pop();
          widget.itemClick.click();
        });
      },
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              color: isSelected ? widget.items.bgColor : Color.fromRGBO(246, 246, 246, 1),
              width: double.infinity,
              // height: SizeConfig.blockSizeVertical * 5,
              child: ClipPath(
                clipper: BottomTriangle(),
                child: Container(
                  // height: double.infinity,
                  color: isSelected ? Colors.white : Color.fromRGBO(239, 239, 239, 1),
                  padding: EdgeInsets.symmetric(
                    horizontal: 1.w,
                    vertical: 3.h,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 1.w,
                      vertical: 3.h,
                    ),
                    child: Text(
                      sickness.title!,
                      textAlign: TextAlign.center,
                      // overflow: TextOverflow.visible,
                      style:
                          Theme.of(context).textTheme.caption!.copyWith(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 10,
            right: 0,
            left: 0,
            child: Center(
              child: Text(
                sickness.title!,
                textAlign: TextAlign.center,
                // overflow: TextOverflow.visible,
                style: Theme.of(context).textTheme.caption!,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: widget.items.children!.length < 2 ? 40.h : 60.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 4.h,
              ),
              width: double.infinity,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemBuilder: (_, index) {
                    return _itemWithTickChild(
                        child: illItemChild(widget.items.children![index].isSelected!,
                            widget.items.children![index]),
                        current: widget.items.children![index],
                        category: widget.items,
                        itemClick: widget.itemClick);
                  },
                  itemCount: widget.items.children!.length,
                  separatorBuilder: (ctx, index) => Space(
                    width: 2.w,
                  ),
                ),
              ),
            ),
            flex: 1,
          ),
          Expanded(
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.maxFinite,
                      height: 10.h,
                    ),
                    flex: 1,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Container(
                      width: double.maxFinite,
                      height: 10.h,
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          intl.cancel,
                          style: Theme.of(context)
                              .textTheme
                              .button!
                              .copyWith(color: AppColors.btnColor),
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
              padding: EdgeInsets.all(2.w),
              margin: EdgeInsets.all(2.w),
            ),
            flex: 0,
          ),
        ],
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
}
