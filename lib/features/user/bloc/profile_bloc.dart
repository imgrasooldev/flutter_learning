import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository repository;

  ProfileBloc(this.repository) : super(ProfileInitial()) {
    on<FetchUserProfile>((event, emit) async {
      // Prevent Re-fetch if already Loaded
      if (state is ProfileLoaded) return;

      emit(ProfileLoading());
      try {
        final user = await repository.fetchUserProfile();
        emit(ProfileLoaded(user));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
