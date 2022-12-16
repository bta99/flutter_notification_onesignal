part of '/widgets/homePage/homepage.dart';

class RoomChatLogic extends ChangeNotifier {
  RoomChatLogic();
  Data? message = Data(id: 0, userId: 0, title: '');
  Data? message2 = Data(id: 1, userId: 1, title: '');
  TextEditingController txtMessage = TextEditingController();
  List<Data?> lstMessage = [
    // 'Xin chào',
    // 'Chào bạn',
    // 'Bạn có thể cho tôi hỏi vài thứ về cuộc thi vừa rồi hay không?',
    // 'ok,bạn có thể hỏi ngay bây giờ',
  ];

  void updateValue(val) {
    // message2 = null;
    message!.id = 0;
    message!.userId = 0;
    message!.title = val;
    notifyListeners();
  }

  void updateValue2(val, {int? id, int? userId}) {
    message2!.id = id;
    message2!.userId = userId;
    message2!.title = val;
    notifyListeners();
  }

  void addMessage() {
    lstMessage.add(message2!.title!.isNotEmpty ? message2 : message);
    txtMessage.clear();
    message = Data(id: 0, userId: 0, title: '');
    message2 = Data(id: 1, userId: 1, title: '');
    notifyListeners();
  }
}
