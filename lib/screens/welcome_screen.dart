import 'package:flutter/material.dart';
import '../models/learner_profile.dart';
import '../services/progress_scope.dart';
import '../widgets/responsive_container.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _controller = TextEditingController();
  String? _errorText;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_validate);
  }

  void _validate() {
    final text = _controller.text;
    if (text.isEmpty) {
      setState(() {
        _errorText = null;
        _isValid = false;
      });
      return;
    }

    final error = LearnerProfile.validateName(text);
    setState(() {
      _errorText = error;
      _isValid = error == null;
    });
  }

  Future<void> _submit() async {
    if (!_isValid) return;
    final progress = ProgressScope.of(context);
    await progress.updateName(_controller.text.trim());
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/main');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ResponsiveContainer(
              maxWidth: 520,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Icon Mark
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.school_outlined,
                        size: 32,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Headline
                  Text(
                    'Welcome to SkillUp',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // One sentence of value
                  Text(
                    'Master essential engineering skills offline, test your mastery on-device, and earn verifiable certificates.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.75),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Name Field
                  Text(
                    'Full name (as it should appear on your certificate)',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    key: const Key('name_input_field'),
                    controller: _controller,
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.words,
                    onSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      hintText: 'e.g. Eleanor Vance',
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      errorText: _errorText,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Privacy Note
                  Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 14,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Your name is stored only on this device.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),

                  // Continue Button (disabled until valid)
                  FilledButton(
                    key: const Key('continue_button'),
                    onPressed: _isValid ? _submit : null,
                    child: const Text('Continue to Courses'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
