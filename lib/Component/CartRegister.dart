import 'dart:convert';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import '/ModelDataBase/TableUser.dart';
import '../Funcs.dart';
import 'InputText.dart';
import 'WidgetWaiting.dart';
import '/DataBase.dart';

class CartRegister extends StatelessWidget {
  CartRegister({super.key});

  final CarouselSliderController buttonCarouselController = CarouselSliderController();

  final TextEditingController txtUserName = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  String? ValideLessThan3Char(String? Input) {
    if(Input == null || Input.length < 3)
      return 'کمتر از 3 کارکتر منطقی نیست';
    return null;
  }

  int ActivePngIndex = 0;

  Future<bool> Register() async {

    FocusManager.instance.primaryFocus!.unfocus();

    String? token = await FirebaseMessaging.instance.getToken();

    Response response = await post(Uri.parse('http://192.168.8.100:3000/user/register'),
        headers: {
          "Content-Type":"application/json"
        }, body: jsonEncode({
          'name':txtUserName.text,
          'password':txtPassword.text,
          'avatar':'assets/Avatar/${ActivePngIndex}.png',
          'token':token
        }));

    TableUser tableUser = TableUser(isRegistered: true, lstSubcription: []);

    await SaveUser(tableUser);

    return true;

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
        width: 0.85.sw,
        decoration: BoxDecoration(
            color: Colors.indigoAccent,
            borderRadius: BorderRadius.circular(10)
        ),
        constraints: BoxConstraints(
          maxHeight: 0.7.sh,
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(
                  width: 100.w,
                  height: 30.h,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Transform.rotate(
                        angle: -pi/2,
                        child: GestureDetector(
                            onTap: (){
                              buttonCarouselController.nextPage();
                            },
                            child: Icon(Icons.play_arrow_sharp,color: Colors.lightGreen)
                        )
                    ),
                  ),
                ),

                Container(
                  width: 80.w,height: 80.w,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.7),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            blurStyle: BlurStyle.outer,
                            spreadRadius: 0,
                            blurRadius: 5
                        )
                      ]
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: CarouselSlider(

                    items: [

                      for(int i = 0; i <= 30; i++)
                        Image.asset(
                            'assets/Avatar/${i}.png',
                            alignment: Alignment.center,fit: BoxFit.fill),

                    ],

                    carouselController: buttonCarouselController,
                    options: CarouselOptions(
                      autoPlay: false,
                      onPageChanged: (index,_){
                        ActivePngIndex = index;
                      },
                      scrollDirection: Axis.vertical,
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                      aspectRatio: 2.0,
                      initialPage: 0,
                    ),
                  ),


                ).animate(
                  effects: [
                    ScaleEffect(begin: Offset(0.0, 0.0),end: Offset(1.0, 1.0),delay: 700.ms,duration: 500.ms,alignment: Alignment.center)
                  ] ,
                ),

                SizedBox(
                  width: 100.w,
                  height: 30.h,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Transform.rotate(
                        angle: pi/2,
                        child: GestureDetector(
                            onTap: (){
                              buttonCarouselController.previousPage();
                            },
                            child: Icon(Icons.play_arrow_sharp,color: Colors.lightGreen))
                    ),
                  ),
                ),

              ],
            ),

            Flexible(
              child: Form(
                key: _keyForm,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: BouncingScrollPhysics(),
                  children: [

                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h
                      ),
                      child: InputText(
                        hint: 'نام کاربری',
                        pathPng: 'assets/png/patient.png',
                        Validator: ValideLessThan3Char,
                        controller: txtUserName,
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h
                      ),
                      child: InputText(
                        pathPng: 'assets/png/key.png',
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center,
                        textInputType: TextInputType.number,
                        hint: 'پسوورد',
                        Validator: ValideLessThan3Char,
                        controller: txtPassword,

                      ),
                    ),

                  ],

                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 15
              ),
              child: ElevatedButton(
                onPressed: () async {

                  FocusManager.instance.primaryFocus!.unfocus();

                  if(_keyForm.currentState!.validate()){

                    bool res = await showMessageBox(context, WidgetWaiting(InputFunction: Register()));

                    Navigator.pop(context,true);

                  }

                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('تایید',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 15.sp
                    )),
                    SizedBox(width: 5),
                    Image.asset('assets/png/ok.png',width: 30,height: 30)
                  ],
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    fixedSize: MaterialStateProperty.all(Size(double.maxFinite,40))
                ),
              ),
            ),

          ],
        ),
      ),
    ).animate(
      effects: [
        ScaleEffect(begin: Offset(0.0, 0.0),end: Offset(1.0, 1.0),duration: 500.ms,alignment: Alignment.center)
      ] ,
    );
  }

}
