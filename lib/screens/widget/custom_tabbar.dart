import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';

class ItemTab {
  ItemTab({required this.title});

  String title;
  bool selected = false;
}

class CustomTabBar extends StatelessWidget {
  CustomTabBar(this.color, this.listItem, this._controller);

  final Color color;
  TabController _controller;
  final List<ItemTab> listItem;

  static int indexItem = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: DefaultTabController(
        length: listItem.length,
        child: TabBar(
          unselectedLabelColor: Colors.black87,
          labelColor: Colors.white,
          /*unselectedLabelStyle: Utils.styleTextTabBar,
          labelStyle: Utils.styleTextSelectTabBar,*/
          indicatorColor: AppColors.accentColor,
          labelPadding: EdgeInsets.all(8),
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: AppColors.accentColor,
          ),
          controller: _controller,
          tabs: listItem
              .asMap()
              .map((index, item) => MapEntry(
            index,
            InkWell(
              child: Container(
                  height: double.maxFinite,
                  alignment: Alignment.center,
                  child: Text(
                    item.title,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  )),
              onTap: () {
                print("click > $indexItem");
                indexItem = index;
                _controller.index=indexItem;
                (context as Element).markNeedsBuild();
              },
            ),
          ))
              .values
              .toList(),
        ),
      ),
    );
  }
}