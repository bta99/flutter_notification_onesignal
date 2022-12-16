import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:push_notification/models/data.dart';
part '../../room_chat_logic.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late ScrollController scrollController;
  // late RoomChatLogic roomChatLogic;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController(initialScrollOffset: 0);
    // roomChatLogic = RoomChatLogic();
  }

  @override
  void dispose() {
    scrollController.dispose();
    // roomChatLogic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Column(
              children: List.generate(
                // roomChatLogic.lstMessage.length,
                context.watch<RoomChatLogic>().lstMessage.length,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    left:
                        context.watch<RoomChatLogic>().lstMessage[index]!.id ==
                                0
                            ? 10
                            : 0,
                    right:
                        context.watch<RoomChatLogic>().lstMessage[index]!.id ==
                                0
                            ? 0
                            : 10,
                    bottom: 10,
                  ),
                  child: Align(
                    alignment:
                        context.watch<RoomChatLogic>().lstMessage[index]!.id ==
                                0
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: context
                                    .watch<RoomChatLogic>()
                                    .lstMessage[index]!
                                    .id ==
                                0
                            ? const Color(0xff009866).withOpacity(0.5)
                            : Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.only(
                          bottomLeft: context
                                      .watch<RoomChatLogic>()
                                      .lstMessage[index]!
                                      .id ==
                                  0
                              ? const Radius.circular(0)
                              : const Radius.circular(10),
                          bottomRight: context
                                      .watch<RoomChatLogic>()
                                      .lstMessage[index]!
                                      .id ==
                                  0
                              ? const Radius.circular(10)
                              : const Radius.circular(0),
                          topLeft: const Radius.circular(10),
                          topRight: const Radius.circular(10),
                        ),
                      ),
                      // ignore: use_full_hex_values_for_flutter_colors
                      // width: MediaQuery.of(context).size.width / 1.5,
                      height: 50,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                context
                                    .watch<RoomChatLogic>()
                                    .lstMessage[index]!
                                    .title!,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        height: 60,
        color: Colors.transparent,
        child: Selector<RoomChatLogic, TextEditingController>(
          selector: (_, state) => state.txtMessage,
          builder: (_, value, __) {
            return TextField(
              controller: context.read<RoomChatLogic>().txtMessage,
              onChanged: (val) {
                context.read<RoomChatLogic>().updateValue(val);
              },
              decoration: InputDecoration(
                suffixIcon: InkWell(
                    onTap: () {
                      context.read<RoomChatLogic>().addMessage();
                      FocusScope.of(context).unfocus();
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInExpo,
                      );
                    },
                    child: const Icon(Icons.send_outlined)),
                contentPadding: const EdgeInsets.only(left: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: const Color(0xff009866).withOpacity(0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: const Color(0xff009866).withOpacity(0.5),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
