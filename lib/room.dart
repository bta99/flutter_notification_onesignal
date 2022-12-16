import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:push_notification/notification.dart';
import 'package:push_notification/widgets/homePage/homepage.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({Key? key}) : super(key: key);

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
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
    return Scaffold(
      appBar: AppBar(
        // ignore: use_full_hex_values_for_flutter_colors
        backgroundColor: const Color(0xff0098665),
        centerTitle: true,
        title: const Text('Room chat'),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                onTap: () {
                  Navigator.pushNamed(context, '/home');
                },
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.green,
                      width: 2,
                    ),
                  ),
                  child: const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/avatar_null.png'),
                  ),
                ),
                title: const Text(
                  'user_id:náoawkooakokdoakoaofoakokokw',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
