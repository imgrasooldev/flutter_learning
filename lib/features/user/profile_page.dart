import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../theme/app_colors.dart';
import '../user/bloc/profile_bloc.dart';
import '../user/bloc/profile_event.dart';
import '../user/bloc/profile_state.dart';
import '../auth/models/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String email = '';
  String phone = '';

  @override
  void initState() {
    super.initState();
    // context.read<ProfileBloc>().add(FetchUserProfile());
    final bloc = context.read<ProfileBloc>();
    if (bloc.state is! ProfileLoaded) {
      bloc.add(FetchUserProfile());
    }
  }

  void editProfile() {
    String tempName = name;
    String tempEmail = email;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Edit Profile'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  controller: TextEditingController(text: tempName),
                  onChanged: (val) => tempName = val,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  controller: TextEditingController(text: tempEmail),
                  onChanged: (val) => tempEmail = val,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    name = tempName;
                    email = tempEmail;
                  });
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ), // <-- Fix Here
              ),
            ),
          );
        }

        if (state is ProfileError) {
          return Scaffold(body: Center(child: Text('Error: ${state.message}')));
        }

        if (state is ProfileLoaded) {
          UserModel user = state.user;
          name = user.name;
          email = user.email;
          phone = user.phone ?? 'No phone';

          return buildProfileUI();
        }

        return const Scaffold(body: Center(child: Text('Initializing...')));
      },
    );
  }

  Widget buildProfileUI() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            expandedHeight: 320,
            pinned: true,
            backgroundColor: AppColors.primary,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primaryDark, AppColors.primary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          'My Profile',
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            const Hero(
                              tag: 'profile_pic',
                              child: CircleAvatar(
                                radius: 52,
                                backgroundImage: AssetImage(
                                  'assets/images/profile_image.jpg',
                                ),
                              ),
                            ),
                            Positioned(
                              child: InkWell(
                                onTap: () {
                                  // Optional: Add profile pic edit functionality here
                                },
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          name,
                          style: const TextStyle(
                            fontFamily: 'WorkSans',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.email, size: 14, color: Colors.white70),
                            const SizedBox(width: 4),
                            Text(
                              email,
                              style: const TextStyle(
                                fontFamily: 'WorkSans',
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.phone, size: 14, color: Colors.white70),
                            const SizedBox(width: 4),
                            Text(
                              phone,
                              style: const TextStyle(
                                fontFamily: 'WorkSans',
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: editProfile,
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text('Edit Profile'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  profileOption(Icons.history, 'My Bookings', () {}),
                  profileOption(Icons.star_rate_rounded, 'My Reviews', () {}),
                  profileOption(
                    Icons.location_on_rounded,
                    'My Addresses',
                    () {},
                  ),
                  profileOption(Icons.lock_outline, 'Change Password', () {}),
                  profileOption(
                    Icons.help_outline_rounded,
                    'Help & Support',
                    () {},
                  ),
                  profileOption(Icons.logout_rounded, 'Logout', () {
                    // Add logout logic here
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget profileOption(IconData icon, String title, VoidCallback onTap) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.75),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: ListTile(
            onTap: onTap,
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.12),
              child: Icon(icon, color: AppColors.primary),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontFamily: 'WorkSans',
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
