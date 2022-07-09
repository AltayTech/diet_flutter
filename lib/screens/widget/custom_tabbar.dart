import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';

class ItemTab {
  ItemTab({required this.title});

  String title;
  bool selected = false;
}

class CustomTabBar extends StatefulWidget {
  CustomTabBar(this.color, this.listItem, this._controller);

  final Color color;
  TabController _controller;
  final List<ItemTab> listItem;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends ResourcefulState<CustomTabBar> {
  static int indexItem = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: widget.color,
      ),
      child: DefaultTabController(
        length: widget.listItem.length,
        child: TabBar(
          unselectedLabelColor: Colors.black87,
          labelColor: Colors.white,
          unselectedLabelStyle: Theme.of(context).textTheme.button!,
          labelStyle: Theme.of(context).textTheme.button!,
          indicatorColor: AppColors.accentColor,
          labelPadding: EdgeInsets.all(8),
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: AppColors.accentColor,
          ),
          controller: widget._controller,
          tabs: widget.listItem
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
                        debugPrint("click > ${indexItem}");
                        setState(() {
                          indexItem = index;
                          widget._controller.index = indexItem;
                        });
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

class CustomTabBarUnderLineIndicator extends StatefulWidget {
  CustomTabBarUnderLineIndicator(
      this.color, this.listItem, this._controller, this.tabIndicatorColor);

  final Color color;
  Color? tabIndicatorColor;
  TabController _controller;
  final List<ItemTab> listItem;

  @override
  State<CustomTabBarUnderLineIndicator> createState() =>
      _CustomTabBarUnderLineIndicatorState();
}

class _CustomTabBarUnderLineIndicatorState
    extends ResourcefulState<CustomTabBarUnderLineIndicator> {
  static int indexItem = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: widget.color,
      ),
      child: DefaultTabController(
        length: widget.listItem.length,
        child: TabBar(
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.black87,
          unselectedLabelStyle: Theme.of(context).textTheme.button!,
          labelStyle: Theme.of(context).textTheme.button!,
          indicatorColor: widget.tabIndicatorColor ?? AppColors.accentColor,
          labelPadding: EdgeInsets.all(8),
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: UnderlineTabIndicator(
              // color for indicator (underline)
              borderSide: BorderSide(
                  color: widget.tabIndicatorColor ?? AppColors.accentColor,
                  width: 3)),
          controller: widget._controller,
          tabs: widget.listItem
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
                        debugPrint("click > ${indexItem}");
                        setState(() {
                          indexItem = index;
                          widget._controller.index = indexItem;
                        });
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
