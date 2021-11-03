import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';

class MyDropdown extends StatefulWidget {
  late dynamic value;
  late List<dynamic> list;
  late String hint;
  late Function onChange;
  late bool border;
  late Alignment alignment;

//  final int type;
//  1 = country, 2 = province, 3 = city
//  List<Country> countries = [];
//  List<Province> provinces = [];
//  List<City> cities = [];

  MyDropdown(
      {required this.value,
      required this.list,
      required this.hint,
      required this.onChange,
      required this.alignment,
      required this.border});

  @override
  State<MyDropdown> createState() => _MyDropdownState();
}

class _MyDropdownState extends ResourcefulState<MyDropdown> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DropdownButtonFormField<dynamic>(
      decoration: InputDecoration(
        fillColor: Color.fromRGBO(245, 245, 245, 1),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: widget.border
                ? Color.fromARGB(255, 164, 164, 164)
                : Color.fromRGBO(245, 245, 245, 1),
            width: 0.3.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 0.3.w,
          ),
        ),
      ),
      icon: Icon(
        Icons.arrow_drop_down,
        color: AppColors.primary,
        size: 8.w,
      ),
      isExpanded: true,
      value: widget.value,
      hint: Text(
        widget.hint,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.caption,
      ),
      items: widget.list
          .map(
            (dynamic item) => DropdownMenuItem<dynamic>(
              child: Container(
                  alignment: widget.alignment,
                  child: Text(
                    item.name!,
                    style: Theme.of(context).textTheme.caption,
                  )),
              value: item,
            ),
          )
          .toList(),
      onChanged: (val) => widget.onChange(val),
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
