import 'package:chatting/model/message.dart';

class LeaveMessage extends Message {

  final String username;

  LeaveMessage(this.username) : super(username);

}