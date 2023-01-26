part of 'form_bloc.dart';

abstract class FormEventState extends Equatable {
  const FormEventState();
}

class FormInitial extends FormEventState {
  @override
  List<Object> get props => [];
}

class FormRoom extends FormEventState {

  final String username;
  const FormRoom(this.username);

  @override
  List<Object> get props => [];
}

class FormLoading extends FormEventState {
  @override
  List<Object> get props => [];
}

class FormDone extends FormEventState {

  final SocketHandler socketHandler;
  const FormDone(this.socketHandler);

  @override
  List<Object> get props => [socketHandler];
}