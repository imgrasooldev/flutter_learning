import 'package:flutter_learning/features/seeker/models/service_providers_model.dart';

abstract class ServiceProviderState {}

class ServiceProviderInitial extends ServiceProviderState {}

class ServiceProviderLoading extends ServiceProviderState {}

class ServiceProviderLoaded extends ServiceProviderState {
  final List<ServiceProvider> providers;

  ServiceProviderLoaded(this.providers);
}

class ServiceProviderError extends ServiceProviderState {
  final String message;

  ServiceProviderError(this.message);
}
