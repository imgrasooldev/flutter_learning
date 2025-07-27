import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProviderHomePage extends StatelessWidget {
  const ProviderHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final List<Map<String, dynamic>> recentRequests = [
      {
        'title': 'Waqas needs AC repair',
        'location': 'Gulshan-e-Iqbal',
        'isNew': true,
      },
      {
        'title': 'Ahsan needs plumbing',
        'location': 'Nazimabad',
        'isNew': false,
      },
      {'title': 'Raza needs electrician', 'location': 'FB Area', 'isNew': true},
      {
        'title': 'GR needs Software Engineer',
        'location': 'FB Area',
        'isNew': true,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Welcome, Ali"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Logged out')));
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
                  const Text(
                    'Your Services',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _serviceItem('Electrician', 'AC repair, wiring', true),
                  _serviceItem('Plumber', 'Pipe fix, bathroom fitting', false),
                  _serviceItem('Mechanic', 'Bike and car work', true),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Add service clicked')),
                      );
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      "Add New Service",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Recent Requests',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...recentRequests.map(
                    (request) => _requestTile(
                      request['title']!,
                      request['location']!,
                      request['isNew']!,
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.go('/home');
                  },
                  icon: const Icon(
                    Icons.home_repair_service,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Find a worker",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(double.infinity, 50),
                    elevation: 8,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _providerCard(BuildContext context, double screenWidth) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.green,
            child: Icon(Icons.person, size: 30, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Ali Electrician",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text("Gulshan-e-Maymar"),
              ],
            ),
          ),
          if (screenWidth > 320)
            const Icon(Icons.verified, color: Colors.green),
        ],
      ),
    );
  }

  Widget _serviceItem(String title, String subtitle, bool active) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.build_circle, color: Colors.teal),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Switch(
          value: active,
          onChanged: (val) {},
          activeColor: Colors.green,
        ),
      ),
    );
  }

  Widget _requestTile(String title, String location, bool isNew) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.assignment_turned_in),
        title: Text(title),
        subtitle: Text(location),
        trailing:
            isNew
                ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'NEW',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
                : null,
      ),
    );
  }
}
