import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/learning_module.dart';
import '../services/course_service.dart';
import '../theme/app_colors.dart';
import '../utils/glitch_page_route.dart';
import '../widgets/wireframe_grid_background.dart';
import '../widgets/brutal_button.dart';
import 'quiz_screen.dart';

class LearningModuleScreen extends StatefulWidget {
  final CourseService courseService;
  final Course course;
  final LearningModule module;

  const LearningModuleScreen({
    super.key,
    required this.courseService,
    required this.course,
    required this.module,
  });

  @override
  State<LearningModuleScreen> createState() => _LearningModuleScreenState();
}

class _LearningModuleScreenState extends State<LearningModuleScreen> {
  late LearningModule _currentModule;

  @override
  void initState() {
    super.initState();
    _currentModule = widget.module;
  }

  void _completeAndAdvance() async {
    await widget.courseService.completeModule(widget.course.id, _currentModule.id);
    setState(() {
      _currentModule.isCompleted = true;
    });

    final currentOrder = _currentModule.orderIndex;

    if (currentOrder < widget.course.modules.length) {
      final nextModule = widget.course.modules[currentOrder];
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '// NODE_0$currentOrder SYNCED (+30 XP) >>> OPENING NODE_0${nextModule.orderIndex}...',
              style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700),
            ),
            backgroundColor: AppColors.pitchBlack,
            duration: const Duration(seconds: 2),
          ),
        );
        GlitchPageRoute.pushReplacement(
          context,
          LearningModuleScreen(
            courseService: widget.courseService,
            course: widget.course,
            module: nextModule,
          ),
        );
      }
    } else {
      // Finished Module 5!
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogCtx) => AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            backgroundColor: AppColors.pitchBlack,
            title: const Row(
              children: [
                Icon(Icons.bolt_sharp, color: AppColors.acidGreen, size: 26),
                SizedBox(width: 8),
                Text(
                  'ALL 5 NODES SYNCED',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            content: Text(
              '100% curriculum sync achieved for ${widget.course.title.toUpperCase()}.\n\nFinal assessment protocol is unlocked: 10 randomly drawn MCQs will evaluate competence on-device.',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11.5,
                color: Color(0xFFDDDDDD),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogCtx);
                  Navigator.pop(context);
                },
                child: const Text('// BACK_TO_HUB',
                    style: TextStyle(fontFamily: 'monospace', color: Colors.white)),
              ),
              BrutalButton(
                text: 'EXECUTE_ASSESSMENT',
                onPressed: () {
                  Navigator.pop(dialogCtx);
                  GlitchPageRoute.pushReplacement(
                    context,
                    QuizScreen(
                      courseService: widget.courseService,
                      course: widget.course,
                    ),
                  );
                },
                backgroundColor: AppColors.acidGreen,
                foregroundColor: AppColors.pitchBlack,
                isFullWidth: false,
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLastModule = _currentModule.orderIndex == widget.course.modules.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('// NODE [0${_currentModule.orderIndex}/05]'),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              color: isDark ? const Color(0xFF222222) : const Color(0xFFE5E5DE),
              child: Text(
                '// ${_currentModule.estimatedMinutes.toUpperCase()}',
                style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900, fontFamily: 'monospace'),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 18),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          border: Border(
            top: BorderSide(
              color: isDark ? Colors.white : AppColors.pitchBlack,
              width: 2.5,
            ),
          ),
        ),
        child: SafeArea(
          child: BrutalButton(
            text: isLastModule
                ? (_currentModule.isCompleted
                    ? '>>> EXECUTE_ASSESSMENT >>>'
                    : '>>> SYNC_NODE & TAKE_ASSESSMENT >>>')
                : (_currentModule.isCompleted
                    ? '>>> NEXT_NODE >>>'
                    : '>>> MARK_SYNCED & CONTINUE >>>'),
            onPressed: _completeAndAdvance,
            backgroundColor: isLastModule
                ? AppColors.acidGreen
                : (isDark ? Colors.white : AppColors.pitchBlack),
            foregroundColor: isLastModule
                ? AppColors.pitchBlack
                : (isDark ? AppColors.pitchBlack : AppColors.acidGreen),
            shadowColor: isDark ? Colors.white : AppColors.pitchBlack,
          ),
        ),
      ),
      body: WireframeGridBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Module Node Header Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                color: AppColors.acidGreen,
                child: Text(
                  'NODE_0${_currentModule.orderIndex} // SYLLABUS_UNIT',
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    color: AppColors.pitchBlack,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Module Title
              Text(
                _currentModule.title.toUpperCase(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  letterSpacing: -0.5,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 10),

              // Summary Terminal Box
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
                      '// ABSTRACT_SPECIFICATION:',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _currentModule.summary,
                      style: const TextStyle(
                        fontSize: 11.5,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Modular Educational Sections
              ..._currentModule.sections.map((sec) => _buildSectionCard(context, sec)),

              const SizedBox(height: 14),

              // Key Takeaway Protocol Box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  border: Border.all(
                    color: isDark ? AppColors.neonYellow : AppColors.pitchBlack,
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? AppColors.neonYellow : AppColors.pitchBlack,
                      offset: const Offset(4, 4),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          color: AppColors.neonYellow,
                          child: const Icon(Icons.star_rate_sharp, color: AppColors.pitchBlack, size: 16),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '// CORE_TAKEAWAY_PROTOCOL:',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                            color: AppColors.neonYellow,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _currentModule.keyTakeaway,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'monospace',
                        height: 1.4,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, ModuleSection section) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.white.withValues(alpha: 0.15) : AppColors.pitchBlack,
              offset: const Offset(3, 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section.title.toUpperCase(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              section.body,
              style: TextStyle(
                fontSize: 12,
                height: 1.45,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),

            // High-Contrast Code Box
            if (section.codeSnippet != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF000000), // Pure Black terminal
                  border: Border.all(color: AppColors.acidGreen, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '// SOURCE_SYNTAX:',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        color: AppColors.acidGreen,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SelectableText(
                      section.codeSnippet!,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11.5,
                        height: 1.4,
                        color: Color(0xFF00FF66),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Bullet Points
            if (section.bulletPoints.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...section.bulletPoints.map((bp) => Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '► ',
                          style: TextStyle(
                            color: AppColors.acidGreen,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                          ),
                        ),
                        Expanded(
                          child: Text(
                            bp,
                            style: TextStyle(
                              fontSize: 11.5,
                              height: 1.4,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],

            // Tip Box
            if (section.tip != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1A00) : const Color(0xFFFFFBEB),
                  border: Border.all(color: AppColors.neonYellow, width: 1.5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '// TIP: ',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        color: AppColors.neonYellow,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        section.tip!,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
