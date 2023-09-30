import 'dart:developer';

// import 'package:chat_gpt_clone/constants/chats.dart';
import 'package:chat_gpt_clone/constants/colors.dart';
import 'package:chat_gpt_clone/models/chat_model.dart';
// import 'package:chat_gpt_clone/models/ai_models_model.dart';
// import 'package:chat_gpt_clone/providers/api_provider.dart';
import 'package:chat_gpt_clone/providers/drop_down_provider.dart';
import 'package:chat_gpt_clone/services/api_service.dart';
// import 'package:chat_gpt_clone/services/api_service.dart';
import 'package:chat_gpt_clone/services/assets_manager.dart';
import 'package:chat_gpt_clone/services/services.dart';
import 'package:chat_gpt_clone/widgets/chat_widget.dart';
// import 'package:chat_gpt_clone/widgets/response_widget.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  bool isTyping = false;
  late TextEditingController textEditingController;
  late FocusNode focusNode;
  late ScrollController listScrollController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    listScrollController = ScrollController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    listScrollController.dispose();
  }

  List<ChatModel> chatList = [];
  @override
  Widget build(BuildContext context) {
    final dropdown = ref.watch(dropdownProvider.notifier);

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
                  await Services.showModal(context);
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
                    controller: listScrollController,
                    itemCount: chatList.length,
                    itemBuilder: (context, index) {
                      return ChatWidget(
                          msg: chatList[index].msg,
                          chatIndex: chatList[index].chatIndex);
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
                        focusNode: focusNode,
                        style: const TextStyle(color: Colors.white),
                        controller: textEditingController,
                        onSubmitted: (value) async {
                          await sendMessage(provider: dropdown);
                        },
                        decoration: const InputDecoration.collapsed(
                            hintText: 'How can I help?',
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          await sendMessage(provider: dropdown);
                        },
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

  void scrollDownToEnd() {
    listScrollController.animateTo(
        listScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut);
  }

  Future<void> sendMessage({required StateController<String> provider}) async {
    log("Request sent");
    try {
      setState(() {
        isTyping = true;
        chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        textEditingController.clear();
        focusNode.unfocus();
        scrollDownToEnd();
      });

      chatList.addAll(await ApiService.sendPrompt(
          provider.state, textEditingController.text));
      setState(() {});
    } catch (error) {
      log(error.toString());
    } finally {
      setState(() {
        isTyping = false;
      });
    }
  }
}
