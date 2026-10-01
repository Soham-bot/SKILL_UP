import 'package:flutter/material.dart';
import '../models/learner_profile.dart';
import '../services/course_service.dart';
import '../theme/app_colors.dart';
import '../utils/glitch_page_route.dart';
import '../widgets/wireframe_grid_background.dart';
import '../widgets/brutal_button.dart';
import 'main_navigation_screen.dart';

class WelcomeScreen extends StatefulWidget {
  final CourseService courseService;

  const WelcomeScreen({super.key, required this.courseService});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Soham Ahirrao');
  final _emailController = TextEditingController(text: 'soham@skillup.edu');
  final _phoneController = TextEditingController(text: '+91 98765 43210');
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleContinue() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final profile = LearnerProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
      phone: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
      xp: 150,
      streakDays: 1,
    );

    await widget.courseService.saveProfile(profile);

    if (mounted) {
      GlitchPageRoute.pushReplacement(
        context,
        MainNavigationScreen(courseService: widget.courseService),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: WireframeGridBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top Status Ticker
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        color: AppColors.acidGreen,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '>>> BOOT_SEQUENCE: ACTIVE',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'monospace',
                                color: AppColors.pitchBlack,
                              ),
                            ),
                            Text(
                              '// LATENCY: 0.00ms',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'monospace',
                                color: AppColors.pitchBlack,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Asymmetric Rotated Brand Header Sticker (-3deg / -0.05 rad)
                      Transform.rotate(
                        angle: -0.04,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                            border: Border.all(
                              color: isDark ? Colors.white : AppColors.pitchBlack,
                              width: 3.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isDark ? AppColors.acidGreen : AppColors.pitchBlack,
                                offset: const Offset(5, 5),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'SKILLUP',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'monospace',
                                      letterSpacing: -1.0,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    color: AppColors.neonYellow,
                                    child: const Text(
                                      '// V2.0',
                                      style: TextStyle(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'monospace',
                                        color: AppColors.pitchBlack,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'LEARN. LEVEL UP. GET CERTIFIED.',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'monospace',
                                  letterSpacing: 0.8,
                                  color: AppColors.acidGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Terminal Initialization Prompt Box
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF141414) : const Color(0xFFEBEBE5),
                          border: Border.all(
                            color: isDark ? Colors.white : AppColors.pitchBlack,
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '// OPERATOR_CREDENTIAL_SETUP:',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'monospace',
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Input operator telemetry. Entered name will be immutably embedded into verified certification records.',
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'monospace',
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Input 1: Name (Required)
                      Text(
                        '// OPERATOR_NAME *',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                          color: isDark ? AppColors.acidGreen : AppColors.pitchBlack,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700),
                        decoration: InputDecoration(
                          hintText: 'e.g. SOHAM AHIRRAO',
                          filled: true,
                          fillColor: isDark ? AppColors.darkSurface : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                              color: isDark ? Colors.white : AppColors.pitchBlack,
                              width: 2.0,
                            ),
                          ),
                        ),
                        validator: (value) => (value == null || value.trim().isEmpty)
                            ? 'Name required for certification protocol'
                            : null,
                      ),

                      const SizedBox(height: 12),

                      // Input 2: Email (Optional)
                      Text(
                        '// COMM_EMAIL (OPTIONAL)',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                          color: isDark ? AppColors.cyberCyan : AppColors.pitchBlack,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700),
                        decoration: InputDecoration(
                          hintText: 'e.g. operator@skillup.edu',
                          filled: true,
                          fillColor: isDark ? AppColors.darkSurface : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                              color: isDark ? Colors.white : AppColors.pitchBlack,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Input 3: Phone (Optional)
                      Text(
                        '// PHONE_IDENTIFIER (OPTIONAL)',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                          color: isDark ? AppColors.neonYellow : AppColors.pitchBlack,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700),
                        decoration: InputDecoration(
                          hintText: 'e.g. +91 98765 43210',
                          filled: true,
                          fillColor: isDark ? AppColors.darkSurface : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                              color: isDark ? Colors.white : AppColors.pitchBlack,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Tactile Hard-Border Continue Button (Bottom Single-Thumb Zone)
                      _isSubmitting
                          ? const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.acidGreen,
                              ),
                            )
                          : BrutalButton(
                              text: '>>> INITIALIZE_DASHBOARD >>>',
                              onPressed: _handleContinue,
                              backgroundColor: AppColors.acidGreen,
                              foregroundColor: AppColors.pitchBlack,
                              shadowColor: isDark ? Colors.white : AppColors.pitchBlack,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                            ),

                      const SizedBox(height: 14),

                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFDDDDDD),
                            child: const Text(
                              '100%_OFFLINE // ZERO_NETWORK_IO // ON_DEVICE_DART',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
