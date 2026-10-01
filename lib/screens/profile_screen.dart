import 'package:flutter/material.dart';
import '../models/learner_profile.dart';
import '../services/course_service.dart';
import '../theme/app_colors.dart';
import 'certificate_screen.dart';

class ProfileScreen extends StatefulWidget {
  final CourseService courseService;

  const ProfileScreen({super.key, required this.courseService});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _editProfileDialog() {
    final profile = widget.courseService.profile;
    final nameCtrl = TextEditingController(text: profile?.name ?? '');
    final emailCtrl = TextEditingController(text: profile?.email ?? '');
    final phoneCtrl = TextEditingController(text: profile?.phone ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: AppColors.pitchBlack,
        title: const Text(
          '// EDIT_OPERATOR_TELEMETRY',
          style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w900, color: AppColors.acidGreen),
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  style: const TextStyle(fontFamily: 'monospace', color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'OPERATOR_NAME *',
                    labelStyle: TextStyle(fontFamily: 'monospace', color: AppColors.acidGreen),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Name required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailCtrl,
                  style: const TextStyle(fontFamily: 'monospace', color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'COMM_EMAIL',
                    labelStyle: TextStyle(fontFamily: 'monospace', color: AppColors.cyberCyan),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneCtrl,
                  style: const TextStyle(fontFamily: 'monospace', color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'PHONE_ID',
                    labelStyle: TextStyle(fontFamily: 'monospace', color: AppColors.neonYellow),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('// CANCEL', style: TextStyle(fontFamily: 'monospace')),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final updated = (profile ?? LearnerProfile(name: 'OPERATOR')).copyWith(
                name: nameCtrl.text.trim(),
                email: emailCtrl.text.trim().isNotEmpty ? emailCtrl.text.trim() : null,
                phone: phoneCtrl.text.trim().isNotEmpty ? phoneCtrl.text.trim() : null,
              );
              await widget.courseService.saveProfile(updated);
              if (ctx.mounted) Navigator.pop(ctx);
              setState(() {});
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.acidGreen, foregroundColor: AppColors.pitchBlack),
            child: const Text('COMMIT_CHANGES'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profile = widget.courseService.profile;
    final enrolledCount = widget.courseService.enrolledCourses.length;
    final completedCourses = widget.courseService.completedCourses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('// 04_OPERATOR_TELEMETRY'),
        actions: [
          IconButton(
            tooltip: 'EDIT_OPERATOR',
            icon: const Icon(Icons.edit_note_rounded),
            onPressed: _editProfileDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Operator Identity Box (Hard Brutalist Container)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? AppColors.acidGreen : AppColors.pitchBlack,
                    offset: const Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Square Avatar
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.acidGreen,
                      border: Border.all(
                        color: isDark ? Colors.white : AppColors.pitchBlack,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        (profile?.name.isNotEmpty ?? false)
                            ? profile!.name[0].toUpperCase()
                            : 'O',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                          color: AppColors.pitchBlack,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '// OPERATOR:',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                        Text(
                          (profile?.name ?? 'OPERATOR').toUpperCase(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                            letterSpacing: -0.5,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        if (profile?.email != null) ...[
                          Text(
                            profile!.email!,
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'monospace',
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Telemetry 4-Pack Grid
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    title: 'ENROLLED',
                    value: '$enrolledCount',
                    color: AppColors.cyberCyan,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMetricTile(
                    title: 'CERTIFIED',
                    value: '${completedCourses.length}',
                    color: AppColors.acidGreen,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    title: 'STREAK',
                    value: '${profile?.streakDays ?? 1}D',
                    color: const Color(0xFFFF5500),
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMetricTile(
                    title: 'XP_POOL',
                    value: '${profile?.xp ?? 0}',
                    color: AppColors.neonYellow,
                    isDark: isDark,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // THEME INVERSION CONTROL
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF141414) : const Color(0xFFEBEBE5),
                border: Border.all(
                  color: isDark ? Colors.white : AppColors.pitchBlack,
                  width: 2.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        '// THEME_INVERSION:',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        color: isDark ? AppColors.pitchBlack : Colors.white,
                        child: Text(
                          isDark ? 'VOID_DARK' : 'FLASH_LIGHT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                            color: isDark ? AppColors.acidGreen : AppColors.pitchBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: widget.courseService.isDarkMode,
                    onChanged: (_) => widget.courseService.toggleTheme(),
                    activeColor: AppColors.acidGreen,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // EARNED CERTIFICATES GALLERY
            Text(
              '// VERIFIED_CREDENTIAL_LEDGER:',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
                letterSpacing: 1.0,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 10),

            if (completedCourses.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDark ? const Color(0xFF333333) : const Color(0xFFCCCCCC),
                    width: 2,
                  ),
                ),
                child: const Text(
                  '// NO_CREDENTIALS_ISSUED_YET\nComplete 5 modules and score ≥ 60% on assessment to earn credentials.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, fontFamily: 'monospace', height: 1.4),
                ),
              )
            else
              ...completedCourses.map((c) {
                final result = c.bestResult;
                if (result == null) return const SizedBox.shrink();

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    border: Border.all(
                      color: isDark ? Colors.white : AppColors.pitchBlack,
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? AppColors.acidGreen : AppColors.pitchBlack,
                        offset: const Offset(3, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: AppColors.acidGreen,
                        child: const Icon(Icons.workspace_premium_rounded, color: AppColors.pitchBlack, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.title.toUpperCase(),
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, fontFamily: 'monospace'),
                            ),
                            Text(
                              'SCORE: ${result.score}/10 (${result.percentage.toInt()}%) // ${result.certificateId}',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'monospace',
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CertificateScreen(
                                courseService: widget.courseService,
                                quizResult: result,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          color: isDark ? Colors.white : AppColors.pitchBlack,
                          child: Text(
                            'VIEW',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'monospace',
                              color: isDark ? AppColors.pitchBlack : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

            const SizedBox(height: 20),

            // Academic Capstone Info
            Container(
              padding: const EdgeInsets.all(12),
              color: isDark ? const Color(0xFF161616) : const Color(0xFFE5E5DE),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '// B.TECH_CAPSTONE_PROJECT // CSE_&_AI',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, fontFamily: 'monospace', color: AppColors.acidGreen),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'AUTHOR: SOHAM AHIRRAO // CROSS_PLATFORM_APP',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'monospace'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border.all(
          color: isDark ? Colors.white : AppColors.pitchBlack,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: color,
            offset: const Offset(3, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '// $title',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
