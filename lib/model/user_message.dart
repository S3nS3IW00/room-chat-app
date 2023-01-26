import 'package:chatting/model/message.dart';

class UserMessage extends Message {

  final int id;
  final int roomId;
  final String sender;
  final DateTime date;

  UserMessage({required this.id, required this.roomId, required this.sender, required this.date, required String content}) : super(content);

}