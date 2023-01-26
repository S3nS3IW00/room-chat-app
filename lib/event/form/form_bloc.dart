import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chatting/constants.dart';
import 'package:chatting/handler/socket_handler.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'form_event.dart';

part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormEventState> {
  FormBloc() : super(FormInitial());

  @override
  Stream<FormEventState> mapEventToState(
    FormEvent event,
  ) async* {
    if (event is UsernameSubmitEvent) {
      yield FormRoom(event.username);
    } else if (event is SubmitEvent) {
      yield FormLoading();
      int? _roomId;
      if (event.roomId == null) {
        try {
          final _response =
              await Dio().put("http://${Constants.apiUrl}/api/v1/room");
          if (_response.data["code"] == 200) {
            _roomId = _response.data["data"]["roomId"];
          } else {
            // something happened
            yield FormRoom(event.username);
          }
        } catch (e) {
          // server not responding
          yield FormRoom(event.username);
        }
      } else {
        try {
          final _response = await Dio()
              .get("http://${Constants.apiUrl}/api/v1/room/${event.roomId}");
          if (_response.data["code"] == 200) {
            // good
            _roomId = event.roomId!;
          } else {
            // no room
            yield FormRoom(event.username);
          }
        } catch (e) {
          // server not responding
          yield FormRoom(event.username);
        }
      }
      if (_roomId != null) {
        print("Connected to room: $_roomId");
        SocketHandler socketHandler = SocketHandler(
          username: event.username,
          roomId: _roomId,
        );
        socketHandler.connect();
        yield FormDone(socketHandler);
      }
    }
  }
}
