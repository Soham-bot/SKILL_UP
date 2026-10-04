import 'package:flutter/material.dart';
import '../models/learner_profile.dart';
import '../services/progress_scope.dart';
import '../widgets/responsive_container.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;
  bool _isEditingName = false;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isEditingName) {
      final progress = ProgressScope.of(context);
      _nameController.text = progress.profile.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    final error = LearnerProfile.validateName(_nameController.text);
    if (error != null) {
      setState(() => _nameError = error);
      return;
    }

    final progress = ProgressScope.of(context);
    await progress.updateName(_nameController.text.trim());
    if (mounted) {
      setState(() {
        _isEditingName = false;
        _nameError = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name updated successfully.')),
      );
    }
  }

  Future<void> _confirmResetProgress() async {
    final theme = Theme.of(context);
    bool keepName = true;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Reset All Learning Progress?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This action will clear all course enrollments, lesson completion checkmarks, and earned certificate history on this device.',
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: keepName,
                title: const Text('Keep profile name'),
                subtitle: const Text('Do not delete your saved name'),
                onChanged: (val) {
                  setDialogState(() {
                    keepName = val ?? true;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Reset Progress'),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true && mounted) {
      final progress = ProgressScope.of(context);
      await progress.resetAll(keepProfileName: keepName);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All learning progress has been reset.')),
        );
        if (!keepName) {
          Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (_) => false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progress = ProgressScope.of(context);
    final profile = progress.profile;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Learner Profile'),
      ),
      body: SingleChildScrollView(
        child: ResponsiveContainer(
          maxWidth: 680,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar & Name Card
              Card(
                color: colorScheme.surfaceContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: colorScheme.primaryContainer,
                        child: Text(
                          profile.firstName.isNotEmpty
                              ? profile.firstName[0].toUpperCase()
                              : 'L',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      if (!_isEditingName) ...[
                        Text(
                          profile.name.isNotEmpty ? profile.name : 'Learner',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Name on Certificates',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                          ),
                          icon: const Icon(Icons.edit_outlined, size: 16),
                          label: const Text('Edit Name'),
                          onPressed: () {
                            setState(() {
                              _isEditingName = true;
                              _nameController.text = profile.name;
                              _nameError = null;
                            });
                          },
                        ),
                      ] else ...[
                        TextField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            labelText: 'Full name',
                            errorText: _nameError,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Note: Existing certificates retain the name they were originally issued with.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isEditingName = false;
                                  _nameController.text = profile.name;
                                  _nameError = null;
                                });
                              },
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 8),
                            FilledButton(
                              onPressed: _saveName,
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Appearance / Theme Section
              Text(
                'Appearance',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                color: colorScheme.surfaceContainer,
                child: Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      title: const Text('System Default'),
                      subtitle: const Text('Match operating system appearance'),
                      value: ThemeMode.system,
                      groupValue: profile.themeMode,
                      onChanged: (mode) {
                        if (mode != null) progress.updateThemeMode(mode);
                      },
                    ),
                    const Divider(height: 1),
                    RadioListTile<ThemeMode>(
                      title: const Text('Light'),
                      subtitle: const Text('Warm ivory and classic typography'),
                      value: ThemeMode.light,
                      groupValue: profile.themeMode,
                      onChanged: (mode) {
                        if (mode != null) progress.updateThemeMode(mode);
                      },
                    ),
                    const Divider(height: 1),
                    RadioListTile<ThemeMode>(
                      title: const Text('Dark'),
                      subtitle: const Text('Deep ink surfaces and high contrast'),
                      value: ThemeMode.dark,
                      groupValue: profile.themeMode,
                      onChanged: (mode) {
                        if (mode != null) progress.updateThemeMode(mode);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Data Management
              Text(
                'Data & Privacy',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                color: colorScheme.surfaceContainer,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.shield_outlined,
                        color: colorScheme.primary,
                      ),
                      title: const Text('100% Offline Storage'),
                      subtitle: const Text(
                        'All progress, scores, and names are stored locally on your device.',
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(
                        Icons.delete_outline,
                        color: theme.colorScheme.error,
                      ),
                      title: Text(
                        'Reset All Progress',
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                      subtitle: const Text(
                        'Clear all lesson completion records and certificate history.',
                      ),
                      onTap: _confirmResetProgress,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // About Section
              Text(
                'About SkillUp',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                color: colorScheme.surfaceContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'SkillUp Platform',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'v1.0.0',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'An on-device, offline-first skill certification platform built with Flutter and Material Design 3. Designed in the spirit of Coursera, Google Skillshop, and freeCodeCamp.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.75),
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
