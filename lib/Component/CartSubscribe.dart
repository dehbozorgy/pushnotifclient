import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/Component/DataSubscribe.dart';

import 'FadingEffect.dart';

class CartSubscribe extends StatelessWidget {

  final DataSubscribe dataNotif;

  final VoidCallback callBack;

  final bool activated;

  const CartSubscribe({
    super.key,
    required this.dataNotif,
    required this.callBack,
    required this.activated});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 0.9.sw,
        margin: EdgeInsets.symmetric(
            vertical: 15
        ),
        height: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  blurRadius: 5,
                  spreadRadius: 0,
                  blurStyle: BlurStyle.outer
              )
            ],
            image: DecorationImage(image: AssetImage(dataNotif.pngPath)
                ,fit: BoxFit.fill,opacity: 0.8)
        ),
        clipBehavior: Clip.hardEdge,
        child: CustomPaint(
            foregroundPainter: FadingEffect(),
            child: Padding(
              padding: EdgeInsets.all(7),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(dataNotif.Title,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.sp,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.indigo,
                            blurRadius: 10,
                          )
                        ]
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                      onPressed: callBack,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(activated ? Icons.notifications_off : Icons.notifications,size: 30,),
                          Text(activated ? 'غیر فعال کردن' : 'فعال کردن',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                            ),
                          )
                        ],
                      ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(activated ? Colors.lightGreenAccent : Colors.orangeAccent),
                      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 10)),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
