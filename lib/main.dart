import 'package:chat_proj/helper/method_helper.dart';
import 'package:chat_proj/screens/screen_conversation.dart';
import 'package:flutter/material.dart';

import 'models.dart';

/*

Description of work to be done for chat display poc. Do not modify this text.

There will be two views. Use WhatsApp as an inspiration for basic details.

Conversation listing view
-------------------------

The main view is a conversation / chat listing, meaning listing a set of conversatinos. 

In the bottom there should be a bottom navigation bar with four menu items/icons, when clicking on it, show a Snackbar
telling what bottom navigation icon that was pressed. It is only there for display purposes. There should also be a 
FAB docked to the bottom navigation bar (FloatingActionButtonLocation.centerDocked).

Conversation.getAll() is a future method that returns a list of conversation. Please look in the models file.

Build a list based on material ListTile.

> Conversation.id - just the id (integer), to be used to reference the conversation in the listing page.
> Conversation.type - the conversation type:
  - default: show the first letter of the conversation.name as tile head.
  - group_conversation: show some icon as the tile head.
  - team_conversation: show some other icon than the group_conversation as the tile head.
> Conversation.imageurl - if not null, show the image insteaad of the conversation.type description above.
> Conversation.name - string that is the name of the conversation.
> Conversation.unread - number of unread messages. If > 0 the count should be shown somehow, and the list tile
  should be different somehow to stand out from the other conversations.

Clicking on one of the conversations will load open new page / route referencing the conversation.id for the item 
clicked on.


Messages view
--------------------------

This is the view that one is routed to when clicking on one of the conversations in the Conversation listing view.

There should not be any bottom navigation bar nor FAB.

The top bar should have a back button to the left, and show the conversation details similar as in the
conversation listing view.

In the bottom there should be a text field together with a
send button. When adding text, the send button gets enabled, and when clicking on it append it to the messages (no
need to persist the message).

Message.getByConversationId(int id) returns a Future that contains a list of Message objects. The objects are for this concept implementation very simple, and not fully realistic, but enought for this exercise. The first item in the returned list is the last message sent.

> Message.id (not used)
> Message.message (the actual text)
> Message.sentByMe (boolean to indicate if the app user was the sender of the message or not). If false the
  message should be on the left sidee, if true then it should be on the right side.
> Message.imageUrl asset url to an image. The image should be shown as a cropped square. Use some resonable size. When clicking on the image full image should be shown.



Extra stuff to prove your greatness :)

- demonstrate how this could be done using the Bloc design pattern
- have different view on large device, where the conversation listing is on the left, and conversation is on the right.
  Similar to how WhatsApp Desktop does.


How your code will be reviewed:

- the final look and feel of the app
- how well the separation between business logic and presentation is done


*/

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Amazing chat'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showSecondScreen = false;
  int conversationId = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isMobile(context)
          ? getFirstPart(
              (id) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScreenConversation(
                    id: id,
                    showAppbar: true,
                  ),
                ),
              ),
            )
          : Row(
              children: <Widget>[
                Expanded(
                  child: getFirstPart(
                    (id) => setState(() => conversationId = id),
                  ),
                  flex: 1,
                ),
                VerticalDivider(),
                Expanded(
                  child: ScreenConversation(
                    id: conversationId,
                    showAppbar: false,
                  ),
                  flex: 2,
                )
              ],
            ),
    );
  }
}

Widget getFirstPart(Function(int) callback) {
  return Center(
    child: FutureBuilder(
      future: Conversation.getAll(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<Conversation>> snapshot,
      ) {
        if (snapshot.data == null) {
          return CircularProgressIndicator();
        } else {
          return ConversationListing(snapshot.data, callback: callback);
        }
      },
    ),
  );
}

class ConversationListing extends StatelessWidget {
  final List<Conversation> conversations;
  final Function(int) callback;

  const ConversationListing(this.conversations, {Key key, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: conversations.length,
      separatorBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(left: 56.0),
        height: 1,
        color: Colors.grey.shade500,
      ),
      itemBuilder: (context, index) {
        Conversation conversation = conversations[index];
        return ListTile(
          contentPadding:
              EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
          onTap: () {
            callback(conversation.id);
          },
          leading: getLeading(context, conversation.type,
              name: conversation.name, url: conversation.imageUrl),
          title: Text(
            conversation.name,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: conversation.unread == 0
              ? SizedBox.shrink()
              : getUnreadCountUI(
                  context,
                  conversation.unread.toString(),
                ),
        );
      },
    );
  }
}

Widget getLeading(BuildContext context, String type,
    {String name, String url}) {
  // if (url != null)
  //   return Image.asset(
  //     url,
  //     width: 36,
  //     height: 36,
  //   );

  if (url != null) {
    return Icon(
      Icons.web,
      size: 36,
    );
  }

  switch (type) {
    case 'team_conversation':
      return Icon(
        Icons.person,
        size: 36,
      );
    case 'group_conversation':
      return Icon(
        Icons.group,
        size: 36,
      );
    default:
      return CircleAvatar(
        radius: 18,
        child: Text(
          name.substring(0, 1),
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.white),
        ),
      );
  }
}

Widget getUnreadCountUI(BuildContext context, String count) {
  return ClipRect(
    child: Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      padding: EdgeInsets.all(8),
      child: Text(
        count,
        style:
            Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.white),
      ),
    ),
  );
}
