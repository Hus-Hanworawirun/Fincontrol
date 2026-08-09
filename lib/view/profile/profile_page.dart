import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthLogoutRequested());
                  },
                  icon: const Icon(
                    Icons.exit_to_app,
                    size: 32,
                    color: Colors.black87,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Material(
              color: Colors.white,
              elevation: 9,
              shadowColor: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(24),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'User Name',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF8A93A6),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'The One Who Wait',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: Color(0xFFF0F0F0), thickness: 1.5),
                    const SizedBox(height: 24),
                    _buildDetailRow('Username', 'husvainglory@hotmail.com'),
                    const SizedBox(height: 16),
                    _buildDetailRow('Account No.', '18019712'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Material(
              color: Colors.white,
              elevation: 9,
              shadowColor: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(24),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 24, top: 24, bottom: 8),
                    child: Text(
                      'General',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    leading: const Icon(Icons.language, color: Colors.black87),
                    title: const Text(
                      'Language',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '🇺🇸 EN',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 1,
                          height: 16,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '🇹🇭 ไทย',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 4,
                    ),
                    leading: const Icon(
                      Icons.dark_mode_outlined,
                      color: Colors.black87,
                    ),
                    title: const Text(
                      'Dark Mode',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    subtitle: const Text(
                      'Perfect for low-light and night lovers',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    trailing: Switch(
                      value: false,
                      onChanged: (val) {},
                      activeTrackColor: Colors.grey.shade400,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF8A93A6),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
