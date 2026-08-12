import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/theme/theme_cubit.dart';
import '../widgets/glass_container.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _biometricEnabled = true;
  bool _aiInsightsEnabled = true;
  bool _smartNotificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final mutedTextColor = Theme.of(context).textTheme.bodySmall?.color;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthLogoutRequested());
                  },
                  icon: Icon(
                    Icons.exit_to_app,
                    size: 32,
                    color: textColor,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 32),
            GlassContainer(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary,
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
                            Text(
                              'User Name',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: mutedTextColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'The One Who Wait',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Divider(color: textColor?.withValues(alpha: 0.1), thickness: 1.5),
                  const SizedBox(height: 24),
                  _buildDetailRow(context, 'Username', 'husvainglory@hotmail.com'),
                  const SizedBox(height: 16),
                  _buildDetailRow(context, 'Account No.', '18019712'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            _buildSectionHeader('Account & Security', textColor),
            GlassContainer(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildListTile(
                    icon: Icons.fingerprint,
                    iconColor: Colors.greenAccent,
                    title: 'Biometric Login',
                    subtitle: 'Use Face ID / Touch ID',
                    textColor: textColor,
                    mutedTextColor: mutedTextColor,
                    trailing: Switch(
                      value: _biometricEnabled,
                      onChanged: (val) => setState(() => _biometricEnabled = val),
                      activeThumbColor: Theme.of(context).colorScheme.primary,
                      activeTrackColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                    ),
                  ),
                  _buildDivider(textColor),
                  _buildListTile(
                    icon: Icons.lock_outline,
                    iconColor: Colors.orangeAccent,
                    title: 'Change Password',
                    subtitle: 'Update your account password',
                    textColor: textColor,
                    mutedTextColor: mutedTextColor,
                    trailing: Icon(Icons.chevron_right, color: mutedTextColor),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            _buildSectionHeader('Preferences', textColor),
            GlassContainer(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildListTile(
                    icon: Icons.attach_money,
                    iconColor: Colors.amberAccent,
                    title: 'Currency',
                    subtitle: 'Default display currency',
                    textColor: textColor,
                    mutedTextColor: mutedTextColor,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('USD', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                        Icon(Icons.chevron_right, color: mutedTextColor),
                      ],
                    ),
                    onTap: () {},
                  ),
                  _buildDivider(textColor),
                  _buildListTile(
                    icon: Icons.language,
                    iconColor: Colors.lightBlueAccent,
                    title: 'Language',
                    subtitle: 'Change app language',
                    textColor: textColor,
                    mutedTextColor: mutedTextColor,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🇺🇸 EN', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                        const SizedBox(width: 8),
                        Container(width: 1, height: 16, color: textColor?.withValues(alpha: 0.2)),
                        const SizedBox(width: 8),
                        Text('🇹🇭 ไทย', style: TextStyle(color: mutedTextColor)),
                      ],
                    ),
                    onTap: () {},
                  ),
                  _buildDivider(textColor),
                  _buildListTile(
                    icon: Icons.dark_mode_outlined,
                    iconColor: Colors.deepPurpleAccent,
                    title: 'Dark Mode',
                    subtitle: 'Perfect for low-light lovers',
                    textColor: textColor,
                    mutedTextColor: mutedTextColor,
                    trailing: Switch(
                      value: isDarkMode,
                      onChanged: (val) {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                      activeThumbColor: Theme.of(context).colorScheme.primary,
                      activeTrackColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionHeader('AI & Automation', textColor),
            GlassContainer(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildListTile(
                    icon: Icons.auto_awesome,
                    iconColor: Colors.purpleAccent,
                    title: 'Gemini AI Insights',
                    subtitle: 'Allow AI to analyze spending habits',
                    textColor: textColor,
                    mutedTextColor: mutedTextColor,
                    trailing: Switch(
                      value: _aiInsightsEnabled,
                      onChanged: (val) => setState(() => _aiInsightsEnabled = val),
                      activeThumbColor: Theme.of(context).colorScheme.primary,
                      activeTrackColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                    ),
                  ),
                  _buildDivider(textColor),
                  _buildListTile(
                    icon: Icons.notifications_active_outlined,
                    iconColor: Colors.redAccent,
                    title: 'Smart Notifications',
                    subtitle: 'Receive automatic budget alerts',
                    textColor: textColor,
                    mutedTextColor: mutedTextColor,
                    trailing: Switch(
                      value: _smartNotificationsEnabled,
                      onChanged: (val) => setState(() => _smartNotificationsEnabled = val),
                      activeThumbColor: Theme.of(context).colorScheme.primary,
                      activeTrackColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionHeader('Support', textColor),
            GlassContainer(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildListTile(
                    icon: Icons.help_outline,
                    iconColor: Colors.tealAccent,
                    title: 'Help Center',
                    subtitle: 'FAQ and support',
                    textColor: textColor,
                    mutedTextColor: mutedTextColor,
                    trailing: Icon(Icons.chevron_right, color: mutedTextColor),
                    onTap: () {},
                  ),
                  _buildDivider(textColor),
                  _buildListTile(
                    icon: Icons.privacy_tip_outlined,
                    iconColor: Colors.indigoAccent,
                    title: 'Terms & Privacy',
                    subtitle: 'Legal information',
                    textColor: textColor,
                    mutedTextColor: mutedTextColor,
                    trailing: Icon(Icons.chevron_right, color: mutedTextColor),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color? textColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Color? textColor,
    required Color? mutedTextColor,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textColor),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: mutedTextColor),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildDivider(Color? textColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 70, right: 20),
      child: Divider(color: textColor?.withValues(alpha: 0.1), height: 1, thickness: 1),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }
}
