abstract class ServiceProviderEvent {}

class FetchServiceProviders extends ServiceProviderEvent {
  final int subcategoryId;
  final int areaId;

  FetchServiceProviders({required this.subcategoryId, required this.areaId});
}
