import 'dart:math';

class Message {
  int id;
  String message;
  bool sentByMe;
  String imageUrl;

  Message({this.id, this.message, this.sentByMe, this.imageUrl});

  static Future<List<Message>> getByConversationId(
    String conversationId,
  ) async {
    print('Getting messages for conversation $conversationId');
    Random randomGenerator = Random.secure();
    List<String> sentences = [
      'How are you doing today?',
      'Cool, great stuff!',
      'What were you thinking about today? You looked to be dreaming about something.',
      'Where should we have lunch today?',
      'This is probably a silly sentence. But I need to write something that is long to be able to give a full example to the developers. This is probably long enough, soon, in a while, maybe now? Long enough! Stop!!!',
    ];

    List<Message> messages = [];

    for (var i = 0; i < 100; i++) {
      String imageUrl;
      int randomNumber = randomGenerator.nextInt(100);
      if (randomNumber > 90) {
        imageUrl = 'images/message-portrait.jpg';
      } else if (randomNumber > 80 && randomNumber <= 90) {
        imageUrl = 'images/message-landscape.jpg';
      }

      messages.add(
        Message(
          id: i,
          message: sentences[randomGenerator.nextInt(sentences.length)],
          sentByMe: randomGenerator.nextBool(),
          imageUrl: imageUrl,
        ),
      );
    }

    await Future.delayed(Duration(seconds: 2), () {});

    return messages;
  }
}

class Conversation {
  int id;
  String name;
  String type;
  String imageUrl;
  int unread;

  Conversation({
    this.id,
    this.name,
    this.type,
    this.imageUrl,
    this.unread,
  });

  static Future<List<Conversation>> getAll() async {
    Random randomGenerator = Random.secure();

    final numberOfConversationsGenerated = 50;
    List<Conversation> conversations = [];

    for (var i = 0; i < numberOfConversationsGenerated; i++) {
      // we distribute the type as this is just static data, for development purpose...
      String type;
      if (i % 3 == 0) {
        type = 'default';
      } else if (i % 3 == 1) {
        type = 'team_conversation';
      } else {
        type = 'group_conversation';
      }

      // The image URL is now referencing assets in the project, in the final version it will reference
      // a network image, but for now we can just support asset images.
      String imageUrl;
      if (i % 4 == 0) {
        imageUrl = 'images/conversation.png';
      }

      int unread = 0;
      if (randomGenerator.nextInt(100) > 80) {
        unread = randomGenerator.nextInt(5) + 1;
      }

      Random.secure();

      List<String> names = [
        'Saksham',
        'Rohan',
        'Aniriddh',
        'John',
        'Sourabh',
        'Mitasha',
        'Namita',
        'Kuldeep',
        'Virat',
        'Umesh',
        'Minal',
        'Rohit',
        'Shubham',
        'Simmi',
        'Chahal',
        'Chanchal',
        'Ankit',
        'Jyoti',
        'Monika',
        'Ravi'
      ];

      conversations.add(
        Conversation(
          id: i,
          name: names[randomGenerator.nextInt(names.length)],
          type: type,
          imageUrl: imageUrl,
          unread: unread,
        ),
      );
    }

    await Future.delayed(Duration(seconds: 3), () {});

    return conversations;
  }
}
