import 'package:chat_proj/models.dart';
import 'package:flutter/material.dart';

class ScreenConversation extends StatefulWidget {
  final bool showAppbar;
  final int id;

  const ScreenConversation({Key key, this.showAppbar, this.id})
      : super(key: key);

  @override
  _ScreenConversationState createState() => _ScreenConversationState();
}

class _ScreenConversationState extends State<ScreenConversation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppbar ? AppBar(title: Text('Messages')) : null,
      body: Container(
        child: Center(
          child: widget.id == -1
              ? Text(
                  'No Conversation Selected!!!',
                  style: Theme.of(context).textTheme.headline3,
                )
              : FutureBuilder(
                  future: Message.getByConversationId(widget.id.toString()),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<List<Message>> snapshot,
                  ) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.connectionState ==
                            ConnectionState.active &&
                        !snapshot.hasData) {
                      return Center(
                        child: Text(
                          'No Messages Yet!!!',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      );
                    } else {
                      return messageList(snapshot.data);
                    }
                  },
                ),
        ),
      ),
    );
  }
}

Widget messageList(List<Message> messages) {
  return ListView.builder(
    reverse: true,
    itemCount: messages.length,
    itemBuilder: (context, index) {
      Message message = messages[index];
      return MessageBubble(
        isMe: message.sentByMe,
        text: message.message,
      );
    },
  );
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.isMe});
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    bottomLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0))
                : BorderRadius.only(
                    topRight: Radius.circular(12.0),
                    bottomLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0)),
            elevation: 0.0,
            color: isMe ? Colors.blueAccent : Colors.amberAccent,
            child: Padding(
              padding: EdgeInsets.all(isMe ? 4 : 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: Text(
                      text,
                      style: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                          fontSize: 15.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
