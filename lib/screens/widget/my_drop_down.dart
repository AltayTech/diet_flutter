import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/auth/country-code.dart';
import 'package:flutter/material.dart';

class MyDropdown extends StatefulWidget {
  late double widthSpace;
  late String value;
  late List<CountryCode> list;
  late String hint;
  late Function onChange;
  late bool border;

//  final int type;
//  1 = country, 2 = province, 3 = city
//  List<Country> countries = [];
//  List<Province> provinces = [];
//  List<City> cities = [];

  MyDropdown(
      {required this.widthSpace,
      required this.value,
      required this.list,
      required this.hint,
      required this.onChange,
      required this.border});

  @override
  State<MyDropdown> createState() => _MyDropdownState();
}

class _MyDropdownState extends ResourcefulState<MyDropdown> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Directionality(
      textDirection: context.textDirectionOfLocale,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          fillColor: Color.fromRGBO(245, 245, 245, 1),
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              color: widget.border
                  ? Color.fromARGB(255, 164, 164, 164)
                  : Color.fromRGBO(245, 245, 245, 1),
              width: widget.widthSpace * 0.003,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: widget.widthSpace * 0.003,
            ),
          ),
        ),
        icon: Icon(
          Icons.arrow_drop_down,
          color: Color.fromRGBO(180, 180, 180, 1),
          size: widget.widthSpace * 0.07,
        ),
        isExpanded: true,
        value: widget.value ?? null,
        hint: Text(
          widget.hint,
          style: TextStyle(
            color: Color.fromRGBO(162, 160, 160, 1),
            fontSize: widget.widthSpace * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        items: widget.list
            .map(
              (item) => DropdownMenuItem(
                child: Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      item.name!,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: Color.fromRGBO(162, 160, 160, 1),
                        fontSize: widget.widthSpace * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                value: item.name,
              ),
            )
            .toList(),
        onChanged: (val) => widget.onChange(val),
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
