import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Notification.dart';

class ShowNotif extends StatelessWidget {

  const ShowNotif({super.key,
    required this.title,
    required this.body,
    required this.payload});

  final String title;
  final String body;
  final String payload;

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10)
      ),
      constraints: BoxConstraints(
          maxWidth: 0.8.sw,
          maxHeight: 0.8.sh
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(

          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Container(
                width: 80.w,height: 80.w,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.7)
                ),
                child: Image.asset(
                    'assets/png/notification.png',
                    alignment: Alignment.center,fit: BoxFit.contain)),

            Flexible(
              fit: FlexFit.loose,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        'Title : ${title}',
                        textAlign: TextAlign.left,
                        softWrap: true,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )
                    ),
                    SizedBox(height: 15.h),
                    Text(
                        'Body : ${body}',
                        textAlign: TextAlign.left,
                        softWrap: true,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )
                    ),

                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pop('id_Open');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('تایید',style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        )),
                        SizedBox(width: 5),
                        Image.asset('assets/emoji/ok.png',width: 30,height: 30)
                      ],
                    ),
                    style: ButtonStyle(
                      fixedSize: WidgetStatePropertyAll(Size.fromWidth(100.w)),
                      backgroundColor: WidgetStatePropertyAll(Colors.green),
                      padding: WidgetStatePropertyAll(EdgeInsets.zero),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pop('id_Close');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('انصراف',style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        )),
                        SizedBox(width: 5),
                        Image.asset('assets/emoji/cancel.png',width: 30,height: 30)
                      ],
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.blue),
                      fixedSize: WidgetStatePropertyAll(Size.fromWidth(100.w)),
                      padding: WidgetStatePropertyAll(EdgeInsets.zero),
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    ).animate(
      effects: [
        ScaleEffect(begin: Offset(0.0, 0.0),end: Offset(1.0, 1.0),duration: 300.ms,alignment: Alignment.center)
      ] ,
    );
  }

}
