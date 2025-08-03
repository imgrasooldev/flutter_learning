import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_learning/features/seeker/repo/service_providers_repository.dart';
import 'service_provider_event.dart';
import 'service_provider_state.dart';

class ServiceProviderBloc
    extends Bloc<ServiceProviderEvent, ServiceProviderState> {
  final ServiceProviderRepository repository;

  ServiceProviderBloc(this.repository) : super(ServiceProviderInitial()) {
    on<FetchServiceProviders>((event, emit) async {
      emit(ServiceProviderLoading());
      try {
        final providers = await repository.fetchTopProviders(
          subcategoryId: event.subcategoryId,
          areaId: event.areaId,
        );
        emit(ServiceProviderLoaded(providers));
      } catch (e) {
        emit(ServiceProviderError(e.toString()));
      }
    });
  }
}
