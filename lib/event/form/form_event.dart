part of 'form_bloc.dart';

abstract class FormEvent extends Equatable {
  const FormEvent();
}

class UsernameSubmitEvent extends FormEvent {

  final String username;
  const UsernameSubmitEvent(this.username);

  @override
  List<Object?> get props => [username];
}

class SubmitEvent extends FormEvent {

  final String username;
  final int? roomId;
  const SubmitEvent(this.username, [this.roomId]);

  @override
  List<Object?> get props => [roomId];
}