import 'package:chatting/model/message.dart';

class JoinMessage extends Message {

  final String username;

  JoinMessage(this.username) : super(username);

}