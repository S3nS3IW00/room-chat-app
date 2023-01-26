import 'package:chatting/event/form/form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_screen.dart';

class MainScreen extends StatefulWidget {
  final _formBloc = FormBloc();

  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocListener(
        bloc: widget._formBloc,
        listener: (context, state) {
          if (state is FormDone) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => ChatScreen(state.socketHandler)));
          }
        },
        child: Container(
          padding: const EdgeInsets.all(20.0),
          color: Colors.red,
          child: LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Room Chat",
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            BlocBuilder(
                              bloc: widget._formBloc,
                              builder: (context, state) {
                                if (state is FormInitial) {
                                  return Text("Choose a name",
                                      style: Theme.of(context).textTheme.headline4);
                                } else if (state is FormRoom) {
                                  return Text("Join or create room",
                                      style: Theme.of(context).textTheme.headline4);
                                } else {
                                  return Text("Setting up",
                                      style: Theme.of(context).textTheme.headline4);
                                }
                              },
                            ),
                          ],
                        ),
                        Form(
                          key: _formKey,
                          child: SizedBox(
                            width: 500.0,
                            child: BlocBuilder(
                              bloc: widget._formBloc,
                              builder: (context, state) {
                                if (state is FormLoading) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  return Column(
                                    children: [
                                      TextFormField(
                                        controller: _controller,
                                        onFieldSubmitted: (value) {
                                          if (state is FormInitial) {
                                            if (_formKey.currentState!.validate()) {
                                              _formKey.currentState!.reset();
                                              widget._formBloc
                                                  .add(UsernameSubmitEvent(value));
                                            }
                                          }
                                        },
                                        style: Theme.of(context).textTheme.headline5,
                                        keyboardType: state is FormInitial
                                            ? TextInputType.name
                                            : TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Must be specified";
                                          } else {
                                            if (state is FormInitial) {
                                              if (value.length > 16) {
                                                return "Max length is 16";
                                              }
                                            }
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          errorStyle:
                                              Theme.of(context).textTheme.headline6,
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText:
                                              state is FormInitial ? "Name" : "Room ID",
                                          focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black, width: 2.5),
                                          ),
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black, width: 5.0),
                                          ),
                                        ),
                                      ),
                                      if (state is FormRoom) ...[
                                        const Divider(),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState!.validate()) {
                                              widget._formBloc.add(SubmitEvent(
                                                  state.username,
                                                  int.parse(_controller.value.text)));
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.black,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Join",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3!
                                                  .copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                          height: 50.0,
                                        ),
                                        ElevatedButton(
                                          onPressed: () => widget._formBloc
                                              .add(SubmitEvent(state.username)),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.black,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Create new",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3!
                                                  .copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
