import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:text_to_speech_app/api_functios.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'chat_model.dart';
import 'colors.dart';

class SpeechToTextAi extends StatefulWidget {
  const SpeechToTextAi({super.key});

  @override
  State<SpeechToTextAi> createState() => _SpeechToTextAiState();
}

class _SpeechToTextAiState extends State<SpeechToTextAi> {
  // creating a variable to store the text

  var textS = "Hold the button and Speak";

  var isListinging = false;

  //speech to text instance

  SpeechToText speechToText = SpeechToText();

  //messages list

  final List<ChatMessage> messages = [];

  //scrool controller

  var scrollController = ScrollController();

  scrollMethod() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: Duration(microseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Talk With AI".text.color(textColor).make(),
        centerTitle: true,
      ),

      //body part to show text

      body: Padding(
        padding: const EdgeInsets.only(
          top: 15,
        ),
        child: SingleChildScrollView(
          reverse: true,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: textS.text.size(24).blue800.makeCentered(),
              ),
              10.heightBox,
              Expanded(
                  child: Container(
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    controller: scrollController,
                    shrinkWrap: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var chats = messages[index];
                      return chatHead(chattext: chats.text, type: chats.type);
                    }),
              ).box.color(chatBg).rounded.shadow.make()),
              20.heightBox,
              "Developed By Farhana".text.make()
            ],
          ).box.height(MediaQuery.sizeOf(context).height * 0.9).make(),
        ),
      ),

      //mike option button to record,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 80,
        duration: Duration(milliseconds: 2000),
        animate: isListinging,
        glowColor: bgColor,
        repeat: true,
        repeatPauseDuration: Duration(microseconds: 70),
        showTwoGlows: true,
        child: GestureDetector(
          onTapDown: (details) async {
            if (!isListinging) {
              var available = await speechToText.initialize();
              if (available) {
                setState(() {
                  isListinging = true;
                  speechToText.listen(
                    onResult: (result) {
                      setState(() {
                        textS = result.recognizedWords;
                      });
                    },
                  );
                });
              }
            }
          },
          onTapUp: (details) async {
            setState(() {
              isListinging = false;
            });

            speechToText.stop();

            messages.add(ChatMessage(text: textS, type: ChatMessageType.user));
            var msg = await ApiServices.sendMessage(textS);

            setState(() {
              messages.add(
                  ChatMessage(text: msg.toString(), type: ChatMessageType.ai));
            });
          },
          child: CircleAvatar(
            backgroundColor: bgColor,
            radius: 35,
            child: Icon(
              isListinging ? Icons.mic : Icons.mic_none,
              color: Colors.white,
              size: 35,
            ),
          ),
        ),
      ),
    );
  }

  // chat buble widget

  Widget chatHead({required chattext, required ChatMessageType? type}) {
    MainAxisAlignment axisAlignment = MainAxisAlignment.end;

    String iconName = "arrow_froward";
    IconData icon = Icons.person;

    if (type == ChatMessageType.ai) {
      axisAlignment = MainAxisAlignment.start;
      icon = Icons.add_reaction_rounded;
    }
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: axisAlignment,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              icon,
              color: Color.fromARGB(255, 215, 129, 31),
            ),
          ),
          5.widthBox,
          Flexible(
              child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
              child: Text(
                chattext,
                style: TextStyle(color: bgColor2, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          )
                  .box
                  .color(Colors.white)
                  .customRounded(BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                      bottomLeft: Radius.circular(3)))
                  .make()),
        ],
      ),
    );
  }
}
