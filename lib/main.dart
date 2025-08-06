import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_learning/features/seeker/bloc/category/category_bloc.dart';
import 'package:flutter_learning/features/seeker/bloc/service_providers/service_provider_bloc.dart';
import 'package:flutter_learning/features/seeker/repo/sub_category_repository.dart';
import 'package:flutter_learning/features/seeker/repo/service_providers_repository.dart';
import 'package:flutter_learning/features/user/bloc/profile_bloc.dart';
import 'package:flutter_learning/features/user/repo/profile_repository.dart';

import 'app/router.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/repository/auth_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (_) => AuthRepository()),
        RepositoryProvider<SubCategoryRepository>(
          create: (_) => SubCategoryRepository(),
        ),
        RepositoryProvider<ServiceProviderRepository>(
          create: (_) => ServiceProviderRepository(),
        ),
        RepositoryProvider<UserRepository>(create: (_) => UserRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create:
                (context) =>
                    AuthBloc(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider(
            create:
                (context) => CategoryBloc(context.read<SubCategoryRepository>()),
          ),
          BlocProvider<ServiceProviderBloc>(
            create:
                (context) => ServiceProviderBloc(
                  context.read<ServiceProviderRepository>(),
                ),
          ),
          BlocProvider<ProfileBloc>(
            create: (_) => ProfileBloc(UserRepository()),
          ),
        ],
        child: MaterialApp.router(
          title: 'Flutter BLoC App',
          theme: ThemeData(
            primarySwatch: Colors.teal,
            scaffoldBackgroundColor: const Color(0xFFF9F9F9),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 1,
            ),
          ),
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
