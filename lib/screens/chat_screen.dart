import 'package:chat_gpt_clone/constants/chats.dart';
import 'package:chat_gpt_clone/constants/colors.dart';
import 'package:chat_gpt_clone/services/assets_manager.dart';
import 'package:chat_gpt_clone/services/services.dart';
import 'package:chat_gpt_clone/widgets/chat_widget.dart';
// import 'package:chat_gpt_clone/widgets/response_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  bool isTyping = true;
  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(AssetsManager.openaiLogo)),
          ),
          title: const Text('ChatGPT'),
          actions: [
            IconButton(
                onPressed: () async {
                  Services.showModal(context);
                },
                icon: const Icon(Icons.more_vert_rounded))
          ],
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
              child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return ChatWidget(
                          msg: chatMessages[index]["msg"],
                          chatIndex: chatMessages[index]["chatIndex"]);
                    }),
              ),
              if (isTyping) ...[
                const SpinKitThreeBounce(
                  color: Colors.white,
                  size: 18,
                )
              ],
              const SizedBox(
                height: 15,
              ),
              Material(
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.grey),
                        controller: textEditingController,
                        onSubmitted: (value) {
                          print('message sent $value');
                        },
                        decoration: const InputDecoration.collapsed(
                            hintText: 'How can I help?',
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ))
                  ]),
                ),
              )
            ],
          )),
        ));
  }
}
