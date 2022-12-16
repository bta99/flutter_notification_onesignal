import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:push_notification/notification.dart';
import 'package:push_notification/room.dart';
import 'package:push_notification/test.dart';
import 'package:push_notification/widgets/homePage/homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => RoomChatLogic(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: '/',
      routes: {
        '/': (_) => const MyHomePage(title: 'Easy chat'),
        '/test': (_) => const TestScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late RoomChatLogic roomChatLogic;
  @override
  void initState() {
    super.initState();
    initNoti();
    NotificationService.initNotification();
    listenNotifications();
    roomChatLogic = RoomChatLogic();
  }

  void initNoti() async {
    await OneSignal.shared.setAppId('9d2756a7-38e9-4618-9ed0-79318124b39d');
    // await OneSignal.shared
    //     .getDeviceState()
    //     .then((value) => print(value!.userId));
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setNotificationOpenedHandler((openedResult) {});
    OneSignal.shared.setNotificationWillShowInForegroundHandler((event) async {
      NotificationService.showNotification(
        id: event.hashCode,
        title: event.notification.title ?? 'Tuấn Anh',
        body: event.notification.additionalData!['title'] ?? 'Tuấn Anh test',
        payload: event.notification.additionalData!['title'],
      );
      roomChatLogic.updateValue2(event.notification.additionalData!['title'],
          id: event.notification.additionalData!['id'],
          userId: event.notification.additionalData!['userId']);
      roomChatLogic.addMessage();
      OneSignal.shared
          .completeNotification(event.notification.notificationId, false);
    });
  }

  void listenNotifications() {
    NotificationService.onNotification.stream.listen((event) {
      onclick(event);
    });
  }

  void onclick(String? payload) {
    Navigator.pushNamed(context, '/test', arguments: payload);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: roomChatLogic,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            // ignore: use_full_hex_values_for_flutter_colors
            backgroundColor: const Color(0xff0098665),
            centerTitle: true,
            title: Text(widget.title),
            elevation: 0.0,
          ),
          body: Consumer<RoomChatLogic>(
            builder: (_, value, __) {
              return const HomePageWidget();
            },
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () async {
          //     await OneSignal.shared.postNotification(OSCreateNotification(
          //       playerIds: ['c429b872-0942-4413-81e6-cc4ccca1e065'],
          //       languageCode: 'en',
          //       heading: 'test thôi',
          //       additionalData: {
          //         'title': 'Tuấn Anh test gửi thông báo!',
          //       },
          //       content: 'abcxyz',
          //     ));
          //   },
          //   tooltip: 'Increment',
          //   child: const Icon(Icons.add),
          // ),
        ),
      ),
    );
  }
}
