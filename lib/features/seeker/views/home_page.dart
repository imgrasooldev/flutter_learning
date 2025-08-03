import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_learning/features/seeker/bloc/category/category_bloc.dart';
import 'package:flutter_learning/features/seeker/bloc/category/category_event.dart';
import 'package:flutter_learning/features/seeker/bloc/category/category_state.dart';
import 'package:flutter_learning/features/seeker/bloc/service_providers/service_provider_bloc.dart';
import 'package:flutter_learning/features/seeker/bloc/service_providers/service_provider_event.dart';
import 'package:flutter_learning/features/seeker/bloc/service_providers/service_provider_state.dart';
import 'package:flutter_learning/features/seeker/models/category_model.dart';
import 'package:flutter_learning/features/seeker/models/service_providers_model.dart';
import 'package:flutter_learning/features/seeker/repo/service_providers_repository.dart';
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

  List<ServiceProvider> _providers = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _perPage = 10;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(FetchCategories());

    _fetchProviders(); // <-- Fetch first page

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _fetchProviders(); // <-- Fetch next page
      }
    });

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        _filteredServices =
            _allServices
                .where((s) => s.name.toLowerCase().contains(query))
                .toList();
      });
    });
  }

  Future<void> _fetchProviders() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);
    try {
      final repository = ServiceProviderRepository();
      final newProviders = await repository.fetchTopProviders(
        subcategoryId: 3,
        areaId: 5,
        page: _currentPage,
        perPage: _perPage,
      );

      setState(() {
        _providers.addAll(newProviders);
        _currentPage++;
        if (newProviders.length < _perPage) {
          _hasMore = false;
        }
      });
    } catch (e) {
      print('Failed to fetch providers: $e');
    } finally {
      setState(() => _isLoading = false);
    }
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

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget buildContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 800 ? 5 : (screenWidth > 600 ? 4 : 3);

    return Stack(
      children: [
        ListView(
          controller: _scrollController, // <-- Add Controller Here
          padding: const EdgeInsets.only(bottom: 80),
          children: [
            SearchBarWidget(
              controller: _searchController,
              filteredServices: _filteredServices,
              onSelect: (service) {
                _searchController.text = service.name;
                setState(() => _filteredServices.clear());
              },
            ),
            PopularServicesGrid(
              services: _popularServices,
              crossAxisCount: crossAxisCount,
            ),
            TopProvidersList(providers: _providers), // <-- Pass Providers Here
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
        const Positioned(bottom: 16, left: 16, right: 16, child: CTAButton()),
      ],
    );
  }
}
