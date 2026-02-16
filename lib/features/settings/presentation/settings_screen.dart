import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 840;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              'Customize your experience',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 800 : double.infinity,
            ),
            child: ListView(
              padding: EdgeInsets.all(
                isDesktop ? 32 : (isTablet ? 24 : 16),
              ),
              children: [
                // Appearance Section
                _SettingsSection(
                  title: 'Appearance',
                  icon: Icons.palette_outlined,
                  children: [
                    _SettingsTile(
                      title: 'Theme Mode',
                      subtitle: 'Choose your preferred theme',
                      leading: const Icon(Icons.brightness_6_outlined),
                      trailing: SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                            value: 'light',
                            label: Text('Light'),
                          ),
                          ButtonSegment(
                            value: 'dark',
                            label: Text('Dark'),
                          ),
                          ButtonSegment(
                            value: 'system',
                            label: Text('System'),
                          ),
                        ],
                        selected: const {'system'},
                        onSelectionChanged: (Set<String> selected) {
                          // Handle theme change
                        },
                      ),
                    ),
                    _SettingsTile(
                      title: 'Dynamic Color',
                      subtitle: 'Use colors from your wallpaper',
                      leading: const Icon(Icons.color_lens_outlined),
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {
                          // Toggle dynamic color
                        },
                      ),
                    ),
                    _SettingsTile(
                      title: 'Color Scheme',
                      subtitle: 'Purple',
                      leading: const Icon(Icons.format_paint_outlined),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ColorDot(color: Colors.deepPurple, selected: true),
                          const SizedBox(width: 8),
                          _ColorDot(color: Colors.blue, selected: false),
                          const SizedBox(width: 8),
                          _ColorDot(color: Colors.green, selected: false),
                          const SizedBox(width: 8),
                          _ColorDot(color: Colors.orange, selected: false),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Task Settings Section
                _SettingsSection(
                  title: 'Task Settings',
                  icon: Icons.task_outlined,
                  children: [
                    _SettingsTile(
                      title: 'Auto-delete completed tasks',
                      subtitle: 'Remove completed tasks after 7 days',
                      leading: const Icon(Icons.auto_delete_outlined),
                      trailing: Switch(
                        value: false,
                        onChanged: (value) {
                          // Toggle auto-delete
                        },
                      ),
                    ),
                    _SettingsTile(
                      title: 'Default category',
                      subtitle: 'Personal',
                      leading: const Icon(Icons.category_outlined),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Show category picker
                      },
                    ),
                    _SettingsTile(
                      title: 'Task notifications',
                      subtitle: 'Get reminders for due tasks',
                      leading: const Icon(Icons.notifications_outlined),
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {
                          // Toggle notifications
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Display Settings Section
                _SettingsSection(
                  title: 'Display',
                  icon: Icons.display_settings_outlined,
                  children: [
                    _SettingsTile(
                      title: 'Show completed tasks',
                      subtitle: 'Display completed tasks in the list',
                      leading: const Icon(Icons.visibility_outlined),
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {
                          // Toggle show completed
                        },
                      ),
                    ),
                    _SettingsTile(
                      title: 'Compact view',
                      subtitle: 'Show more tasks on screen',
                      leading: const Icon(Icons.view_compact_outlined),
                      trailing: Switch(
                        value: false,
                        onChanged: (value) {
                          // Toggle compact view
                        },
                      ),
                    ),
                    _SettingsTile(
                      title: 'Font size',
                      subtitle: 'Medium',
                      leading: const Icon(Icons.text_fields_outlined),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Show font size picker
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Data & Privacy Section
                _SettingsSection(
                  title: 'Data & Privacy',
                  icon: Icons.security_outlined,
                  children: [
                    _SettingsTile(
                      title: 'Export data',
                      subtitle: 'Download all your tasks',
                      leading: const Icon(Icons.download_outlined),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Export data
                      },
                    ),
                    _SettingsTile(
                      title: 'Import data',
                      subtitle: 'Restore from backup',
                      leading: const Icon(Icons.upload_outlined),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Import data
                      },
                    ),
                    _SettingsTile(
                      title: 'Clear all data',
                      subtitle: 'Delete all tasks and settings',
                      leading: Icon(
                        Icons.delete_forever_outlined,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Show confirmation dialog
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // About Section
                _SettingsSection(
                  title: 'About',
                  icon: Icons.info_outlined,
                  children: [
                    _SettingsTile(
                      title: 'Version',
                      subtitle: '1.0.0',
                      leading: const Icon(Icons.info_outlined),
                    ),
                    _SettingsTile(
                      title: 'Privacy Policy',
                      leading: const Icon(Icons.privacy_tip_outlined),
                      trailing: const Icon(Icons.open_in_new, size: 16),
                      onTap: () {
                        // Open privacy policy
                      },
                    ),
                    _SettingsTile(
                      title: 'Terms of Service',
                      leading: const Icon(Icons.description_outlined),
                      trailing: const Icon(Icons.open_in_new, size: 16),
                      onTap: () {
                        // Open terms of service
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: leading,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  final bool selected;

  const _ColorDot({
    required this.color,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Change color scheme
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: selected
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                )
              : null,
        ),
        child: selected
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              )
            : null,
      ),
    );
  }
}