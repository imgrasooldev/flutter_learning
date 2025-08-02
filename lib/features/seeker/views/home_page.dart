import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_learning/features/seeker/bloc/category_bloc.dart';
import 'package:flutter_learning/features/seeker/bloc/category_event.dart';
import 'package:flutter_learning/features/seeker/bloc/category_state.dart';
import 'package:flutter_learning/features/seeker/models/category_model.dart';
import 'package:flutter_learning/features/seeker/views/provider_detail_page.dart';
import 'package:flutter_learning/features/seeker/views/components/search_bar.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';

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

  final List<Map<String, dynamic>> _providers = [
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
  ];

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: buildAppBar(context),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
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
    final horizontalPadding = screenWidth > 768 ? 32.0 : 16.0;

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
                  buildPopularServicesGrid(crossAxisCount, horizontalPadding),
                  buildTopProvidersSection(horizontalPadding),
                ],
              ),
            ),
            buildCTAButton(),
          ],
        );
      },
    );
  }

  Widget buildPopularServicesGrid(
    int crossAxisCount,
    double horizontalPadding,
  ) {
    return Padding(
      padding: EdgeInsets.all(horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popular Services',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children:
                _popularServices.map((service) {
                  final width =
                      (MediaQuery.of(context).size.width -
                          (crossAxisCount - 1) * 14 -
                          32) /
                      crossAxisCount;
                  return SizedBox(
                    width: width,
                    child: serviceTile(service['title'], service['icon']),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildTopProvidersSection(double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Providers Near You',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          ListView.builder(
            itemCount: _providers.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final p = _providers[index];
              return providerCard(
                p['name'],
                p['area'],
                p['rating'],
                p['online'] ?? false,
              );
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget buildCTAButton() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: ElevatedButton.icon(
        onPressed: () => context.go('/provider_home'),
        icon: const Icon(Icons.handyman_outlined, color: Colors.white),
        label: const Text(
          'Offer your service',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: AppColors.primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          elevation: 4,
        ),
      ),
    );
  }

  Widget serviceTile(String title, IconData icon) {
    return GestureDetector(
      onTap: () => debugPrint("Clicked: $title"),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: AppColors.primaryDark),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget providerCard(String name, String area, double rating, bool online) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => ProviderDetailPage(
                    name: name,
                    area: area,
                    rating: rating,
                    online: online,
                  ),
            ),
          );
        },
        leading: Stack(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFFEDF0F5),
              child: Icon(Icons.person, color: AppColors.primary),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: CircleAvatar(
                radius: 6,
                backgroundColor: online ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('$area • ${online ? 'Online' : 'Offline'}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Text(rating.toStringAsFixed(1)),
          ],
        ),
      ),
    );
  }
}
