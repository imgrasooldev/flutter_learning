import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_learning/features/seeker/bloc/category/category_bloc.dart';
import 'package:flutter_learning/features/seeker/bloc/category/category_event.dart';
import 'package:flutter_learning/features/seeker/bloc/category/category_state.dart';
import 'package:flutter_learning/features/seeker/bloc/service_providers/service_provider_bloc.dart';
import 'package:flutter_learning/features/seeker/bloc/service_providers/service_provider_event.dart';
import 'package:flutter_learning/features/seeker/bloc/service_providers/service_provider_state.dart';
import 'package:flutter_learning/features/seeker/models/category_model.dart';
import 'package:flutter_learning/features/seeker/views/components/popular_services_grid.dart';
import 'package:flutter_learning/features/seeker/views/components/top_providers_list.dart';
import 'package:flutter_learning/features/seeker/views/components/search_bar.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import 'package:flutter_learning/features/seeker/views/components/cta_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  List<CategoryModel> _allServices = [];
  List<CategoryModel> _filteredServices = [];

  final List<Map<String, dynamic>> _popularServices = [
    {'title': 'Electrician', 'icon': Icons.electrical_services},
    {'title': 'Plumber', 'icon': Icons.plumbing},
    {'title': 'Mechanic', 'icon': Icons.build},
    {'title': 'Tutor', 'icon': Icons.school},
    {'title': 'Cleaner', 'icon': Icons.cleaning_services},
    {'title': 'Tailor', 'icon': Icons.checkroom},
  ];

  /* final List<Map<String, dynamic>> _providers = [
    {
      'name': 'Ali Electrician',
      'area': 'Gulshan-e-Maymar',
      'rating': 4.9,
      'online': true,
    },
    {'name': 'Zara Tutor', 'area': 'Nazimabad', 'rating': 4.8, 'online': true},
    {
      'name': 'Asif Mechanic',
      'area': 'Ahsanabad',
      'rating': 4.7,
      'online': false,
    },
    {
      'name': 'Qasim Plumber',
      'area': 'Gulistan-e-Johar',
      'rating': 4.6,
      'online': true,
    },
  ]; */

  @override
  void initState() {
    super.initState();
    // Dispatch FetchCategories event once when page loads
    context.read<CategoryBloc>().add(FetchCategories());

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        _filteredServices =
            _allServices
                .where((s) => s.name.toLowerCase().contains(query))
                .toList();
      });
    });

    // Dispatch FetchServiceProviders event manually
    context.read<ServiceProviderBloc>().add(
      FetchServiceProviders(subcategoryId: 3, areaId: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: buildAppBar(context),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          } else if (state is CategoryLoaded) {
            _allServices = state.categories;
            return buildContent(context);
          } else if (state is CategoryError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 1,
      centerTitle: true,
      leading: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.home_repair_service, color: AppColors.primary),
      ),
      title: const Text(
        'Kaam',
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.location_on_outlined,
            color: AppColors.primary,
          ),
        ),
        IconButton(
          onPressed: () => context.push('/profile'),
          icon: const Icon(Icons.person_outline, color: AppColors.primary),
        ),
      ],
    );
  }

  Widget buildContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount =
        screenWidth > 800
            ? 5
            : (screenWidth > 600
                ? 4
                : 3); // Adjust grid count based on screen width
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchBarWidget(
                    controller: _searchController,
                    filteredServices: _filteredServices,
                    onSelect: (service) {
                      _searchController.text = service.name;
                      setState(() => _filteredServices.clear());
                    },
                  ),
                  /*                   buildPopularServicesGrid(crossAxisCount, horizontalPadding),
                  buildTopProvidersSection(horizontalPadding), */
                  PopularServicesGrid(
                    services: _popularServices,
                    crossAxisCount: crossAxisCount,
                  ),
                  // TopProvidersList(providers: _providers),
                  // 🔥 Add BlocBuilder for ServiceProviderBloc here
                  BlocBuilder<ServiceProviderBloc, ServiceProviderState>(
                    builder: (context, state) {
                      if (state is ServiceProviderLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ServiceProviderLoaded) {
                        return TopProvidersList(providers: state.providers);
                      } else if (state is ServiceProviderError) {
                        return Center(child: Text('Error: ${state.message}'));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            const CTAButton(), // <--- Moved here
          ],
        );
      },
    );
  }
}
