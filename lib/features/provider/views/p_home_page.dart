import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';

class ProviderHomePage extends StatelessWidget {
  const ProviderHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final List<Map<String, dynamic>> recentRequests = [
      {'title': 'Waqas needs AC repair', 'location': 'Gulshan-e-Iqbal', 'isNew': true},
      {'title': 'Ahsan needs plumbing', 'location': 'Nazimabad', 'isNew': false},
      {'title': 'Raza needs electrician', 'location': 'FB Area', 'isNew': true},
      {'title': 'GR needs Software Engineer', 'location': 'FB Area', 'isNew': true},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 4,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              // Optional: navigate to a default route if cannot pop
              context.go('/home'); // or replace with your desired route
            }
          },
        ),
        title: const Text("Welcome, Ali", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out')),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                children: [
                  _providerCard(context, screenWidth),
                  const SizedBox(height: 24),
                  _sectionTitle("Your Services"),
                  _serviceItem('Electrician', 'AC repair, wiring', true),
                  _serviceItem('Plumber', 'Pipe fix, bathroom fitting', false),
                  _serviceItem('Mechanic', 'Bike and car work', true),
                  const SizedBox(height: 16),
                  _gradientButton(
                    icon: Icons.add,
                    label: "Add New Service",
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Add service clicked')),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  _sectionTitle("Recent Requests"),
                  const SizedBox(height: 12),
                  ...recentRequests.map((req) => _requestTile(
                        req['title']!,
                        req['location']!,
                        req['isNew']!,
                      )),
                ],
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: _gradientButton(
                  icon: Icons.home_repair_service,
                  label: "Find a worker",
                  onPressed: () => context.go('/home'),
                  color: Colors.orange,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryDark,
      ),
    );
  }

  Widget _gradientButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.primaryDark,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 8,
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }

  Widget _providerCard(BuildContext context, double screenWidth) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, size: 30, color: AppColors.white),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ali Electrician", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text("Gulshan-e-Maymar", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          if (screenWidth > 320)
            const Icon(Icons.verified, color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _serviceItem(String title, String subtitle, bool active) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: const Icon(Icons.build_circle, color: AppColors.primaryDark, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: Switch(
          value: active,
          onChanged: (_) {},
          activeColor: AppColors.primary,
        ),
      ),
    );
  }

  Widget _requestTile(String title, String location, bool isNew) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.assignment_turned_in, color: AppColors.primary),
        title: Text(title),
        subtitle: Text(location),
        trailing: isNew
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'NEW',
                  style: TextStyle(color: AppColors.white, fontSize: 11),
                ),
              )
            : null,
      ),
    );
  }
}
