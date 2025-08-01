import 'package:flutter/material.dart';
import 'package:flutter_learning/features/seeker/views/provider_detail_page.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _allServices = [
    'Electrician', 'Plumber', 'Mechanic', 'Tutor', 'Cleaner',
    'Tailor', 'Painter', 'Driver', 'AC Repair', "Bike Mechanic",
    "Car Mechanic", "Car AC Mechanic", "Teacher", "Religious Teacher", "Math Teacher",
  ];

  final List<Map<String, dynamic>> _providers = [
    {'name': 'Ali Electrician', 'area': 'Gulshan-e-Maymar', 'rating': 4.9, 'online': true},
    {'name': 'Zara Tutor', 'area': 'Nazimabad', 'rating': 4.8, 'online': true},
    {'name': 'Asif Mechanic', 'area': 'Ahsanabad', 'rating': 4.7, 'online': false},
    {'name': 'Qasim Plumber', 'area': 'Gulistan-e-Johar', 'rating': 4.6, 'online': true},
  ];

  List<String> _filteredServices = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        _filteredServices = _allServices
            .where((s) => s.toLowerCase().contains(query))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1.5,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.home_repair_service, color: AppColors.primary),
        ),
        title: const Text(
          'Kaam',
          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.location_on, color: AppColors.primary),
          ),
          IconButton(
            onPressed: () => context.push('/profile'),
            icon: const Icon(Icons.person, color: AppColors.primary),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Box
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Material(
                        elevation: 2,
                        shadowColor: Colors.black12,
                        borderRadius: BorderRadius.circular(12),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search for electrician, plumber...',
                            prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                            filled: true,
                            fillColor: AppColors.fieldFill,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      if (_filteredServices.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          constraints: const BoxConstraints(maxHeight: 200),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _filteredServices.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(_filteredServices[index]),
                                onTap: () {
                                  _searchController.text = _filteredServices[index];
                                  setState(() => _filteredServices.clear());
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),

                // Services Header
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Services',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                // Services Grid
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = screenWidth > 600 ? 4 : 3;
                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      padding: const EdgeInsets.all(16),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      children: [
                        serviceTile('Electrician', Icons.electrical_services),
                        serviceTile('Plumber', Icons.plumbing),
                        serviceTile('Mechanic', Icons.build),
                        serviceTile('Tutor', Icons.school),
                        serviceTile('Cleaner', Icons.cleaning_services),
                        serviceTile('Tailor', Icons.checkroom),
                      ],
                    );
                  },
                ),

                // Providers Header
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Top Providers Near You',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                // Providers List
                ListView.builder(
                  itemCount: _providers.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final provider = _providers[index];
                    return providerCard(
                      provider['name'],
                      provider['area'],
                      provider['rating'],
                      provider['online'] ?? false,
                    );
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),

          // Sticky CTA Button
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: ElevatedButton.icon(
              onPressed: () => context.go('/provider_home'),
              icon: const Icon(Icons.handyman, color: AppColors.white),
              label: const Text('Offer your service', style: TextStyle(color: AppColors.white)),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: AppColors.primaryDark,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget serviceTile(String title, IconData icon) {
    return GestureDetector(
      onTap: () => debugPrint("Clicked: $title"),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 6,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 34, color: AppColors.primaryDark),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget providerCard(String name, String area, double rating, bool online) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProviderDetailPage(
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
            const CircleAvatar(child: Icon(Icons.person)),
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
            const Icon(Icons.star, color: Colors.orangeAccent, size: 20),
            const SizedBox(width: 4),
            Text(rating.toStringAsFixed(1)),
          ],
        ),
      ),
    );
  }
}
