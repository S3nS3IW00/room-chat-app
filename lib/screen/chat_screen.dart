import 'package:chatting/event/socket/socket_bloc.dart';
import 'package:chatting/handler/socket_handler.dart';
import 'package:chatting/model/join_message.dart';
import 'package:chatting/model/message.dart';
import 'package:chatting/model/user_message.dart';
import 'package:chatting/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  final SocketHandler _socketHandler;
  late SocketBloc _socketBloc;

  ChatScreen(this._socketHandler, {Key? key}) : super(key: key) {
    _socketHandler.onJoin = (username) => _socketBloc.add(JoinEvent(username));
    _socketHandler.onLeave =
        (username) => _socketBloc.add(LeaveEvent(username));
    _socketHandler.onMessage =
        (message) => _socketBloc.add(NewMessageEvent(message));
    _socketBloc = SocketBloc(_socketHandler);
  }

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.red,
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${widget._socketHandler.username} (#${widget._socketHandler.roomId})",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      widget._socketHandler.disconnect();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => MainScreen()));
                    },
                    child: Text(
                      "Leave",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: BlocBuilder(
                  bloc: widget._socketBloc,
                  builder: (context, state) {
                    List<Message> messages = state as List<Message>;
                    return ListView.separated(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        if (messages[index] is UserMessage) {
                          return buildMessageBubble(context, messages[index] as UserMessage);
                        } else {
                          return buildNotificationBubble(messages[index].content, messages[index] is JoinMessage ? true : false);
                        }
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 10.0,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                onFieldSubmitted: (value) {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.reset();
                    widget._socketHandler.sendMessage(value);
                  }
                },
                style: Theme.of(context).textTheme.headline6,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Must be specified";
                  } else {
                    if (value.length > 200) {
                      return "Max length is 200";
                    }
                  }
                },
                decoration: InputDecoration(
                  errorStyle: Theme.of(context).textTheme.headline6,
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Message",
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.5),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 5.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMessageBubble(BuildContext context, UserMessage message) {
    bool isSame = message.sender == widget._socketHandler.username;
    return Row(
      mainAxisAlignment:
      isSame ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 20.0,
          ),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: isSame ? Colors.red : Colors.blue,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message.sender),
                Text(
                  message.content,
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildNotificationBubble(String username, bool join) {
    return SizedBox(
      height: 50.0,
      child: Center(
        child: Text("$username ${join ? "joined" : "left"} the chat"),
      ),
    );
  }

}
