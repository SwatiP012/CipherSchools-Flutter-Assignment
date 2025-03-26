import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> messages;
  const MessagesScreen({super.key, required this.messages});

  @override
  // ignore: library_private_types_in_public_api
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    return ListView.separated(
      itemCount: widget.messages.length,
      separatorBuilder: (_, i) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final messageData = widget.messages[index];
        final isUser = messageData['isUserMessage'] ?? false;
        final message = messageData['message'];
        String msgText = '';

        try {
          msgText = message?.text?.text?[0] ?? '';
        } catch (e) {
          msgText = 'Invalid message';
        }

        return Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
               Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomRight: Radius.circular(isUser ? 0 : 20),
                    topLeft: Radius.circular(isUser ? 20 : 0),
                  ),
                  color: isUser ? const Color(0xFFFAAB78) : const Color(0xffdddddd),
                ),
                constraints: BoxConstraints(maxWidth: w * 2 / 3),
                child: Text(
                  msgText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
