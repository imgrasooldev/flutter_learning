import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../seeker/views/booking_bottom_sheet.dart';

class ProviderDetailPage extends StatelessWidget {
  final String name;
  final String area;
  final double rating;
  final bool online;

  const ProviderDetailPage({
    super.key,
    required this.name,
    required this.area,
    required this.rating,
    required this.online,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.primary,
                expandedHeight: 260,
                pinned: true,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      ClipPath(
                        clipper: WaveClipper(),
                        child: Container(
                          color: AppColors.primary,
                          height: double.infinity,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 12,
                                      offset: Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Container(
                                    color: Colors.white,
                                    child: const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                area,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    20,
                    20,
                    100,
                  ), // Bottom padding for fixed button
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: _buildStatusRow()),
                      const SizedBox(height: 30),
                      _buildSectionTitle("Services Offered"),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 10,
                        children: [
                          _serviceChip("AC Repair"),
                          _serviceChip("Wiring"),
                          _serviceChip("Fan Installation"),
                        ],
                      ),
                      const SizedBox(height: 30),
                      _buildSectionTitle("Recent Work"),
                      const SizedBox(height: 10),
                      _buildRecentWorkGallery(),
                      const SizedBox(height: 30),
                      _buildSectionTitle("Customer Reviews"),
                      const SizedBox(height: 10),
                      _buildReviewTile(
                        "Ahmed Khan",
                        4.5,
                        "Very professional and timely service.",
                      ),
                      _buildReviewTile(
                        "Sana Malik",
                        5.0,
                        "Highly recommended! Will book again.",
                      ),
                      _buildReviewTile(
                        "Bilal Tariq",
                        4.0,
                        "Work was good but arrived a bit late.",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: _buildBookingButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 20),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 16),
        Chip(
          label: Text(
            online ? "Online" : "Offline",
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          backgroundColor: online ? Colors.green : Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryDark,
      ),
    );
  }

  Widget _serviceChip(String label) {
    return Chip(
      backgroundColor: AppColors.primary.withOpacity(0.08),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            color: AppColors.primaryDark,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildRecentWorkGallery() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 110,
              decoration: const BoxDecoration(
                color: Colors.black12,
                image: DecorationImage(
                  image: AssetImage('assets/images/work_sample.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewTile(String user, double stars, String review) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 18, child: Icon(Icons.person)),
              const SizedBox(width: 10),
              Text(user, style: const TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < stars ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                    size: 18,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(review, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildBookingButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder:
                (context) => BookingBottomSheet(
                  providerName: name,
                  serviceType: 'between', // You can pass 'single' as needed.
                ),
          );
        },
        icon: const Icon(Icons.send, color: AppColors.background),
        label: const Text(
          "Send Booking Request",
          style: TextStyle(color: AppColors.background),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
