enum ChatMessageType { user, ai }

class ChatMessage {
  ChatMessage({required this.text, required this.type});

  String? text;
  ChatMessageType? type;
}
