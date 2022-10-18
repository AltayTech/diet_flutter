import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/auth/country.dart';
import 'package:behandam/screens/authentication/authentication_bloc.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/web_scroll.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:country_calling_code_picker/picker.dart' as picker;
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';

import '../provider.dart';

class ListCountry extends StatefulWidget {
  ListCountry({required this.click});

 late Function(Country) click;
  @override
  State<ListCountry> createState() => _ListCountryState();
}

class _ListCountryState extends ResourcefulState<ListCountry> {
  final _textSearchCountryCode = TextEditingController();
  late AuthenticationBloc authBloc;
  late Country _selectedLocation;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    authBloc = AuthenticationProvider.of(context);
    return selectCountry();
  }

  Widget selectCountry() {
    return Container(
      height: 7.h,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.grey[200]),
      child: StreamBuilder(
        stream: authBloc.selectedCountry,
        builder: (_, AsyncSnapshot<Country> snapshot) {
          if (snapshot.hasData) {
            _selectedLocation = snapshot.requireData;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () => countryDialog(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 0,
                        child: Icon(Icons.keyboard_arrow_down, color: Colors.orange, size: 20),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '+${_selectedLocation.code ?? ''}',
                            textDirection: TextDirection.ltr,
                            maxLines: 1,
                            style: typography.caption,
                          ),
                        ),
                      ),
                      Space(width: 2.w),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: ImageUtils.fromLocal(_selectedLocation.flag!,
                            width: 6.w,
                            package: picker.countryCodePackageName,
                            height: 4.5.w,
                            fit: BoxFit.fill),
                      ),
                    ],
                  )),
            );
          }
          return Progress();
        },
      ),
    );
  }

  countryDialog() {
    DialogUtils.showBottomSheetPage(
      context: context,
      child: Container(
        height: 64.h,
        padding: EdgeInsets.all(3.w),
        alignment: Alignment.center,
        child: Column(
          children: [
            TextField(
              controller: _textSearchCountryCode,
              textDirection: TextDirection.ltr,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.penColor),
                    borderRadius: BorderRadius.circular(15.0)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                // enabledBorder: OutlineInputBorder(
                //   borderSide: BorderSide(color: Colors.grey)),
                // errorText: _validate ? intl.fillAllField : null,
                label: Text(intl.search),
                labelStyle: TextStyle(
                    color: AppColors.penColor, fontSize: 10.sp, fontWeight: FontWeight.w400),
              ),
              style: TextStyle(
                  color: AppColors.penColor, fontSize: 10.sp, fontWeight: FontWeight.w400),
              onSubmitted: (String) {
                widget.click(_selectedLocation);
              },
              onChanged: authBloc.searchCountry,
            ),
            Space(height: 2.h),
            StreamBuilder<List<Country>>(
                stream: authBloc.filterListCountry,
                builder: (context, filterListCountry) {
                  if (filterListCountry.hasData)
                    return Expanded(
                      child: ScrollConfiguration(
                        behavior: MyCustomScrollBehavior(),
                        child: ListView.builder(
                          // shrinkWrap: true,
                          itemBuilder: (_, index) => GestureDetector(
                            onTap: () {
                              authBloc.setCountry(filterListCountry.data![index]);
                              _selectedLocation = filterListCountry.data![index];
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: 5.h,
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(2.0),
                                      child: ImageUtils.fromLocal(
                                          filterListCountry.data![index].flag??'assets/images/flags/ir.png',
                                          package: picker.countryCodePackageName,
                                          width: 7.w,
                                          fit: BoxFit.fill,
                                          height: 5.w),
                                    ),
                                    Space(width: 2.w),
                                    Text(
                                      '+${filterListCountry.data![index].code ?? ''}',
                                      style: typography.caption,
                                    ),
                                    Space(width: 3.w),
                                    Expanded(
                                        child: Text(
                                      filterListCountry.data![index].name ?? '',
                                      style: typography.caption,
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          itemCount: filterListCountry.data!.length,
                        ),
                      ),
                    );
                  return Center(child: Progress());
                }),
          ],
        ),
      ),
    );
  }

}
