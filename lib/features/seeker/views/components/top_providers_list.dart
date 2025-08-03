import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../models/service_providers_model.dart';
import '../../views/provider_detail_page.dart';

class TopProvidersList extends StatelessWidget {
  final List<ServiceProvider> providers;

  const TopProvidersList({super.key, required this.providers});

  @override
  Widget build(BuildContext context) {
    if (providers.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No providers found near you.'),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 768 ? 32.0 : 16.0;

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
            itemCount: providers.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final p = providers[index];
              return _ProviderCard(
                name: p.user.name,
                area: p.area.name ?? 'Unknown Area',
                category: p.category.name,
                rating: 4.5,
                online: true, // <-- You can set this dynamically later.
              );
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _ProviderCard extends StatelessWidget {
  final String name;
  final String area;
  final String category;
  final double rating;
  final bool online;

  const _ProviderCard({
    required this.name,
    required this.area,
    required this.category,
    required this.rating,
    required this.online,
  });

  @override
  Widget build(BuildContext context) {
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(area),
                const Text(' • '),
                Text(
                  online ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: online ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Text(
              category,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
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
