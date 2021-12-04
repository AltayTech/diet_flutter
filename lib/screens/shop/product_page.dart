import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/auth/country_code.dart';
import 'package:behandam/screens/shop/product_bloc.dart';
import 'package:behandam/screens/widget/centered_circular_progress.dart';
import 'package:behandam/screens/widget/line.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends ResourcefulState<ProductPage> {
  late ProductBloc productBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productBloc = ProductBloc();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.redBar,
        title: Text(intl.shop),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios), onPressed: () => VxNavigator.of(context).pop()),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 2.h),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child:
              // StreamBuilder(
              //   stream: productBloc.product,
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData)
              //       return ListView.builder(
              //         shrinkWrap: true,
              //         physics: NeverScrollableScrollPhysics(),
              //         itemBuilder: (_, index) {
                        // if (index == snapshot.requireData.length) {
                        //   return loadMoreProgress();
                        // }
                        // return
                          Column(
                          children: [
                            // ...snapshot.data!
                                // .where((element) => element.categoryId == args!.id)
                                // .map((product) =>
                                Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Column(
                                children: [
                                  firstSection('test')
                                      // product.productName, product.productThambnail),
                  //               ],
                  //             ),
                  //           ))
                  //               .toList(),
                  //         ],
                  //       );
                  //     },
                  //     // itemCount: snapshot.requireData.length + 1,
                  //   );
                  // else
                  //   return Progress();
                // },
              // ),
            // ),
          ],
        ),
      ),
    ]))]))));
  }

  Widget firstSection(String? title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          children: [
            ImageUtils.fromLocal('assets/images/shop/title.png'),
            // ImageUtils.fromNetwork(FlavorConfig.instance.variables["baseUrlFile"] + pic),
            Text(title!),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
               Text('$rating / 5');
              },
            ),
            Row(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: AppColors.redBar.withOpacity(0.3)
                      ),
                      child: ImageUtils.fromLocal('assets/images/shop/corno.png'),
                    ),
                    Column(
                      children: [
                        Text('12:45'),
                        Text(intl.courseTime),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: AppColors.redBar.withOpacity(0.3)
                      ),
                      child: ImageUtils.fromLocal('assets/images/shop/person.png'),
                    ),
                    Column(
                      children: [
                        Text('125${intl.person}'),
                        Text(intl.buyThisCourse),
                      ],
                    )
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0, left: 12.0),
              child: Line(color: AppColors.strongPen, height: 0.1.h),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text('1000',
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 10.sp)),
                      Text('500' + intl.currency, style: TextStyle(fontSize: 12.sp))
                    ],
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(Size(45.w, 6.h)),
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        foregroundColor: MaterialStateProperty.all(AppColors.redBar),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                        side: MaterialStateProperty.all(BorderSide(color: AppColors.redBar))),
                    child: Row(
                      children: [
                        ImageUtils.fromLocal('assets/images/shop/add_cart.svg', width: 2.w, height: 3.h),
                        SizedBox(width: 2.w),
                        Text(intl.buyThisCourse,
                            style: TextStyle(color: AppColors.redBar, fontSize: 14.sp)),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget secondTile(int? selling, int? discount) {
    return Card(
      child: Column(
        children: [

        ],
      ),
    );
  }

  Widget animationsList() {
    return Expanded(
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Colors.transparent, Colors.red],
          ).createShader(bounds);
        },
        child: Container(height: 200.0, width: 200.0, color: Colors.blue,
        child: Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.')),
        blendMode: BlendMode.dstATop,
      ),
    );
  }

  Widget loadMoreProgress() {
    return StreamBuilder(
      stream: productBloc.loadingMoreProducts,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        return CenteredCircularProgressIndicator(
          visible: snapshot.data == true,
        );
      },
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
