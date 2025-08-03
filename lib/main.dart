import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_learning/features/seeker/bloc/category/category_bloc.dart';
import 'package:flutter_learning/features/seeker/bloc/service_providers/service_provider_bloc.dart';
import 'package:flutter_learning/features/seeker/repo/category_repository.dart';
import 'package:flutter_learning/features/seeker/repo/top_service_providers_repository.dart';

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
        RepositoryProvider<CategoryRepository>(
          create: (_) => CategoryRepository(),
        ),
        RepositoryProvider<ServiceProviderRepository>(
          create: (_) => ServiceProviderRepository(),
        ),
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
                (context) => CategoryBloc(context.read<CategoryRepository>()),
          ),
          BlocProvider<ServiceProviderBloc>(
            create:
                (context) => ServiceProviderBloc(
                  context.read<ServiceProviderRepository>(),
                ),
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
