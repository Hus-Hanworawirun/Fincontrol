import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/theme/theme_cubit.dart';
import '../../data/repositories/auth_repository.dart';
import '../widgets/glass_container.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthRepository _authRepo = AuthRepository();
  bool _biometricEnabled = true;
  String _selectedCurrency = 'USD';
  bool _isUploadingProfilePic = false;
  
  Map<String, dynamic>? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() => _isLoading = true);
    try {
      final user = await _authRepo.getUser();
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickAndUploadImage() async {
    if (_isUploadingProfilePic || _user == null) return;

    setState(() {
      _isUploadingProfilePic = true;
    });

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        await _authRepo.uploadAvatar(pickedFile.path);
        // Reload user to get new avatar URL
        await _loadUser();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingProfilePic = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final mutedTextColor = Theme.of(context).textTheme.bodySmall?.color;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    String displayName = _user?['name'] ?? 'User Name';
    String email = _user?['email'] ?? 'No email provided';
    String uid = _user?['id']?.toString() ?? 'Unknown';
    if (uid.length > 8) uid = uid.substring(0, 8);
    
    String? photoUrl = _user?['photo_url'];
    if (photoUrl != null && !photoUrl.startsWith('http')) {
      photoUrl = '${_authRepo.baseUrl}$photoUrl';
    }

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
                      GestureDetector(
                        onTap: _isUploadingProfilePic ? null : _pickAndUploadImage,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.primary,
                                image: photoUrl != null
                                    ? DecorationImage(
                                        image: NetworkImage(photoUrl),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: photoUrl == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            if (_isUploadingProfilePic)
                              const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                          ],
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
                              displayName,
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
                  _buildDetailRow(context, 'Username', email),
                  const SizedBox(height: 16),
                  _buildDetailRow(context, 'Account No.', uid),
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
                      onChanged: (val) {
                        setState(() => _biometricEnabled = val);
                      },
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
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Change Password coming soon!')),
                      );
                    },
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
                        Text('USD', style: TextStyle(fontWeight: _selectedCurrency == 'USD' ? FontWeight.bold : FontWeight.normal, color: _selectedCurrency == 'USD' ? textColor : mutedTextColor)),
                        const SizedBox(width: 8),
                        Container(width: 1, height: 16, color: textColor?.withValues(alpha: 0.2)),
                        const SizedBox(width: 8),
                        Text('THB', style: TextStyle(fontWeight: _selectedCurrency == 'THB' ? FontWeight.bold : FontWeight.normal, color: _selectedCurrency == 'THB' ? textColor : mutedTextColor)),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        _selectedCurrency = _selectedCurrency == 'USD' ? 'THB' : 'USD';
                      });
                    },
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
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Language selection coming soon!')),
                      );
                    },
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
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Help Center coming soon!')),
                      );
                    },
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
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Terms & Privacy coming soon!')),
                      );
                    },
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
