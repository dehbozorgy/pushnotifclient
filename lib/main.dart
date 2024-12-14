import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pushnotifclient/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Component/CartRegister.dart';
import 'Component/WidgetWaiting.dart';
import 'Funcs.dart';
import 'Component/CartSubscribe.dart';
import 'Component/DataSubscribe.dart';
import 'ModelDataBase/TableUser.dart';
import 'Notification.dart';
import 'SecondPage.dart';
import 'firebase_options.dart';
import 'DataBase.dart';

final GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  Map<String,dynamic> data = message.data;

  String StrId = data.toString();

  int id = StrId.hashCode;

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final List<String>? items = prefs.getStringList('token');

  if(items==null){
    prefs.setStringList('token', <String>['$id']);
  }
  else {
    items.add('$id');
    await prefs.remove('token');
    prefs.setStringList('token', items);
  }


  await NotificationApi.showNotification(
      id: id,
      title: 'Title => ${data['title']}',
      body: 'Body => ${data['body']}',
      payload: '${data['title']}');

}


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await ScreenUtil.ensureScreenSize();

  await Hive
    ..initFlutter()
    ..registerAdapter(TableUserAdapter())
  ;

  Permission.notification.isDenied.then((value){
    if(value){
      Permission.notification.request();
    }
  });

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.instance.setupMessageHandlers();

  await NotificationApi.init();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorkey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TableUser? data;

  List<DataSubscribe> lst = [
    DataSubscribe(Title: 'فوتبال آقایان', Topic: 'men_football', pngPath: 'assets/sport/a.png'),
    DataSubscribe(Title: 'فوتبال بانوان', Topic: 'women_football', pngPath: 'assets/sport/b.png'),
    DataSubscribe(Title: 'تنیس', Topic: 'tennis', pngPath: 'assets/sport/c.png'),
    DataSubscribe(Title: 'پینگ پنگ', Topic: 'ping_pong', pngPath: 'assets/sport/d.png'),
    DataSubscribe(Title: 'وزنه برداری', Topic: 'weight_lifting', pngPath: 'assets/sport/e.png'),
    DataSubscribe(Title: 'دوچرخه سواری', Topic: 'cycling', pngPath: 'assets/sport/f.png'),
  ];

  Future UpdateUser(String Topic) async {

    if(data!.lstSubcription.contains(Topic)){
      await FirebaseMessaging.instance.unsubscribeFromTopic(Topic);
      data!.lstSubcription.remove(Topic);
    }
    else{
      await FirebaseMessaging.instance.subscribeToTopic(Topic);
      data!.lstSubcription.add(Topic);
    }

    await DeletAllUser();

    await SaveUser(data!);

    return true;

  }

  Future<TableUser?>? GetDataUser() async {
    data = await GetUser();
    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final List<String>? items = prefs.getStringList('token');

      if(items!=null){
        for(String str in items) {
          await NotificationApi.Cancel(int.parse(str));
        }
      }

      await prefs.remove('token');

      /////////////////////////////////
      data = await GetUser();
      setState(() {});

    });

    ListenNotifications();

  }

  void ListenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context)=> SecondPage(Payload: payload)
      ));


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Builder(builder: (context){
          ScreenUtil.init(context, designSize: const Size(360, 690));
          return Center(

            ///////////////////////////////////////////////////////////////////////
            child: data!=null ? ListView.builder(
              itemCount: lst.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                  vertical: 15
              ),
              itemBuilder: (context,index){
                return CartSubscribe(
                    dataNotif: lst.elementAt(index),
                    callBack: () async {

                      String Topic = lst.elementAt(index).Topic;

                      await showMessageBox(context, WidgetWaiting(InputFunction: UpdateUser(Topic)));

                      setState(() {});


                    },
                    activated: data!.lstSubcription.contains(lst.elementAt(index).Topic)
                );
              },
            ) :
            ElevatedButton(
                onPressed: () async {

                  data = TableUser(isRegistered: true, lstSubcription: []);

                  await SaveUser(data!);

                  setState(() {});

                },
                child: Text('Register',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    )
                ),
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.lightBlueAccent)
                )
            ),


            ////////////////////////////////////////////////////////////////////////////

            // child: FutureBuilder<TableUser?>(
            //     future: GetDataUser(),
            //     builder: (context,snapshot){
            //       if(snapshot.hasData){
            //         return ListView.builder(
            //          itemCount: lst.length,
            //           shrinkWrap: true,
            //           physics: BouncingScrollPhysics(),
            //           padding: EdgeInsets.symmetric(
            //             vertical: 15
            //           ),
            //           itemBuilder: (context,index){
            //             return CartNotif(
            //                 dataNotif: lst.elementAt(index),
            //                 callBack: () async {
            //
            //                   String Topic = lst.elementAt(index).Topic;
            //
            //                   // await UpdateUser(Topic);
            //
            //                   await showMessageBox(context, WidgetWaiting(InputFunction: UpdateUser(Topic)));
            //
            //                   setState(() {});
            //
            //
            //                 },
            //                 activated: data!.lstSubcription.contains(lst.elementAt(index).Topic)
            //             );
            //           },
            //         );
            //       }
            //       else if(snapshot.hasError){
            //         return Text('Error => ${snapshot.error}');
            //       }
            //       else {
            //         return ElevatedButton(onPressed: () async {
            //
            //           bool? res2 = await showMessageBox(context, CartRegister());
            //
            //           setState(() {});
            //
            //
            //         }, child: Text('Register'));
            //       }
            //     }
            // )

            /////////////////////////////////////////////////////////////////


          );
        }),
      ),
    );
  }

}