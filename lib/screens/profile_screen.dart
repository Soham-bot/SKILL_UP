import 'package:flutter/material.dart';
import '../models/learner_profile.dart';
import '../services/course_service.dart';
import '../theme/app_colors.dart';
import '../utils/glitch_page_route.dart';
import '../widgets/wireframe_grid_background.dart';
import '../widgets/brutal_button.dart';
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
          '<EDIT YOUR LORE>',
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
                    labelText: 'GAMER TAG / NAME *',
                    labelStyle: TextStyle(fontFamily: 'monospace', color: AppColors.acidGreen),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Drop a name!' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailCtrl,
                  style: const TextStyle(fontFamily: 'monospace', color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'EMAIL (OPTIONAL)',
                    labelStyle: TextStyle(fontFamily: 'monospace', color: AppColors.cyberCyan),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneCtrl,
                  style: const TextStyle(fontFamily: 'monospace', color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'PHONE DIGITS (OPTIONAL)',
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
            child: const Text('// CANCEL', style: TextStyle(fontFamily: 'monospace', color: Colors.white)),
          ),
          BrutalButton(
            text: 'SAVE CHANGES',
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final updated = (profile ?? LearnerProfile(name: 'MAIN CHARACTER')).copyWith(
                name: nameCtrl.text.trim(),
                email: emailCtrl.text.trim().isNotEmpty ? emailCtrl.text.trim() : null,
                phone: phoneCtrl.text.trim().isNotEmpty ? phoneCtrl.text.trim() : null,
              );
              await widget.courseService.saveProfile(updated);
              if (ctx.mounted) Navigator.pop(ctx);
              setState(() {});
            },
            backgroundColor: AppColors.acidGreen,
            foregroundColor: AppColors.pitchBlack,
            isFullWidth: false,
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
        title: const Text('// AURA_STATS // YOUR LORE'),
        actions: [
          IconButton(
            tooltip: 'EDIT LORE',
            icon: const Icon(Icons.edit_note_sharp),
            onPressed: _editProfileDialog,
          ),
        ],
      ),
      body: WireframeGridBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(14),
            children: [
              // System Health Terminal Ticker
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF141414) : const Color(0xFFE5E5DE),
                  border: Border.all(
                    color: isDark ? Colors.white : AppColors.pitchBlack,
                    width: 1.5,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '<SYS_STATUS: ZERO L\'S // IMMACULATE>',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        color: AppColors.acidGreen,
                      ),
                    ),
                    Text(
                      '// 100% NO CAP',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Operator Identity Box
              Container(
                padding: const EdgeInsets.all(16),
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
                      width: 58,
                      height: 58,
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

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '// GAMER TAG:',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'monospace',
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                          Text(
                            (profile?.name ?? 'MAIN CHARACTER').toUpperCase(),
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
                                fontSize: 10.5,
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

              const SizedBox(height: 14),

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
                      title: 'BIG W\'S',
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
                      title: 'STREAK 🔥',
                      value: '${profile?.streakDays ?? 1}D',
                      color: const Color(0xFFFF5500),
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricTile(
                      title: 'AURA POINTS ✨',
                      value: '${profile?.xp ?? 0}',
                      color: AppColors.neonYellow,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // THEME INVERSION CONTROL
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                          '// VIBE_CHECK:',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          color: isDark ? AppColors.pitchBlack : Colors.white,
                          child: Text(
                            isDark ? 'VOID_DARK' : 'FLASHBANG',
                            style: TextStyle(
                              fontSize: 9.5,
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

              const SizedBox(height: 22),

              // EARNED CERTIFICATES GALLERY
              Text(
                '// CERTIFIED RECEIPTS (BIG FLEXES) 🧾:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  letterSpacing: 1.0,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(height: 8),

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
                    '<NO RECEIPTS YET 💀>\nFinish 5 modules and score ≥ 60% on the final boss to get your official certificate.',
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
                          child: const Icon(Icons.workspace_premium_sharp, color: AppColors.pitchBlack, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.title.toUpperCase(),
                                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, fontFamily: 'monospace'),
                              ),
                              Text(
                                'SCORE: ${result.score}/10 (${result.percentage.toInt()}%) // ${result.certificateId}',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontFamily: 'monospace',
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            GlitchPageRoute.push(
                              context,
                              CertificateScreen(
                                courseService: widget.courseService,
                                quizResult: result,
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            color: isDark ? Colors.white : AppColors.pitchBlack,
                            child: Text(
                              'FLEX',
                              style: TextStyle(
                                fontSize: 9.5,
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

              const SizedBox(height: 18),

              // Academic Capstone Info
              Container(
                padding: const EdgeInsets.all(12),
                color: isDark ? const Color(0xFF161616) : const Color(0xFFE5E5DE),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '// B.TECH CAPSTONE PROJECT // CSE & AI',
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, fontFamily: 'monospace', color: AppColors.acidGreen),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'CREATOR: SOHAM AHIRRAO // CROSS-PLATFORM FLUTTER // NO CAP',
                      style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, fontFamily: 'monospace'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),
            ],
          ),
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
              fontSize: 8.5,
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 17,
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
