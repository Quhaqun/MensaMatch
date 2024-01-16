import 'package:flutter/material.dart';
import 'package:mensa_match/components/chat_message.dart';

class ChatBubble extends StatefulWidget {
  final int index;
  final ChatMessage message;
  final Function(int) onDelete;
  final Function(String, String) onUpdate; // Corrected this line

  ChatBubble({
    required Key key,
    required this.index,
    required this.message,
    required this.onDelete,
    required this.onUpdate,
  }) : super(key: key);
  // Call the super constructor with the provided key

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}


class _ChatBubbleState extends State<ChatBubble> {
  late String editedText;

  @override
  void initState() {
    super.initState();
    editedText = widget.message.text;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.message.isSentByUser ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: widget.message.isSentByUser ? Colors.grey : Colors.blueGrey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                editedText,
                style: TextStyle(color: Colors.white),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => widget.onDelete(widget.index),
                    color: Colors.white,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showEditDialog(context),
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    TextEditingController textController = TextEditingController(text: widget.message.text);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Message'),
          content: TextFormField(
            controller: textController,
            decoration: InputDecoration(
              hintText: 'Enter your edited message...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  editedText = textController.text;
                });
                widget.onUpdate(widget.message.documentId, textController.text); // Updated this line
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
