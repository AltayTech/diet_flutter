import 'package:behandam/const_&_model/selected_time.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/psy/calender_details.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';

class PSYCalenderScreen extends StatelessWidget {
  const PSYCalenderScreen({Key? key}) : super(key: key);

  ADShow(BuildContext context, List<SelectedTime>? info) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 450,
        // height: 300,
        child: ListView.builder(
            shrinkWrap: false,
            itemCount: info!.length,
            itemBuilder: (_, index) {
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                elevation: 5,
                child: Column(
                  children: [
                    ListTile(
                      leading: info[index].adviserImage == null
                          ? Icon(AppIcons.dropDown)
                          : Image.network(
                          'https://debug.behaminplus.ir//helia-service${info[index].adviserImage}'),
                      title: Text(info[index].adviserName!),
                      subtitle: Text(
                        info[index].date!,
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                      trailing: Container(
                          width: 100.0,
                          padding: EdgeInsets.only(top: 8.0),
                          child: Column(children: [
                            Column(children: [
                              Text("${info[index].price.toString()} تومان "),
                              Text("${info[index].duration.toString()} دقیقه ",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6)))
                            ])
                          ])),
                    ),
                    ButtonBar(
                        mainAxisSize: MainAxisSize.min,
                        alignment: MainAxisAlignment.start,
                        children: [
                          ...info[index].times!.map((item) {
                            return FlatButton(
                              textColor: AppColors.baseColor,
                              onPressed: () {
                                showModal(context,info[index], item.id);
                              },
                              child: Text(
                                  item.startTime.toString().substring(0, 5)),
                            );
                          }).toList(),
                        ])
                  ],
                ),
              );
            }),
      ),
    );
  }
  showModal(BuildContext ctx, SelectedTime info, int? sessionId) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      context: ctx,
      builder: (_) {
        return Popover(
          child: Container(
            height: 180,
            color: Colors.white,
            child: Container(
              child: Column(
                children: [
                  ListTile(
                    leading: info.adviserImage == null
                        ? Icon(AppIcons.dropDown)
                        : Image.network(
                        'https://debug.behaminplus.ir//helia-service${info.adviserImage}'),
                    title: Text(info.adviserName!),
                    subtitle: Text(
                      info.date!,
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                    trailing: Container(
                        width: 100.0,
                        padding: EdgeInsets.only(top: 8.0),
                        child: Column(children: [
                          Column(children: [
                            Text("${info.price.toString()} تومان "),
                            Text("${info.duration.toString()} دقیقه ",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)))
                          ])
                        ])),
                  ),
                  ButtonBar(
                    mainAxisSize: MainAxisSize.min,
                    alignment: MainAxisAlignment.start,
                    children: [
                      FlatButton(
                          textColor: AppColors.baseColor,
                          onPressed: () {
                            // Param p = new Param();
                            // p.sessionId = sessionId;
                            // p.packageId = info.packageId;
                            // p.name = info.adviserName;
                            // p.price = info.price;
                            // p.date = info.date;
                            // ctx.vxNav.push(Uri.parse(Routes.rules), params: p);
                            ctx.vxNav.push(Uri.parse(Routes.rules),params: {
                              'sessionId': sessionId,
                              'packageId': info.packageId,
                              'name': info.adviserName,
                              'price': info.price,
                              'date': info.date,
                            });
                          },
                          child: Text('همین ساعت را رزرو کن')),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xffE3EBEF),
          elevation: 0.0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Color(0xff191C32),
              onPressed: () => Navigator.of(context)
                ..pop()
                ..pushNamed("/home"))),
      backgroundColor: Color(0xffE3EBEF),
      body: CalenderDetails(),
    );
  }
}

