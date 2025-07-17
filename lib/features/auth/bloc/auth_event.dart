import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email, password;
  LoginEvent(this.email, this.password);
}

class LogoutEvent extends AuthEvent {}

class RegisterEvent extends AuthEvent {
  final String name, email, password, confirmPassword;
  RegisterEvent(this.name, this.email, this.password, this.confirmPassword);

  @override
  List<Object?> get props => [name, email, password, confirmPassword];
}
