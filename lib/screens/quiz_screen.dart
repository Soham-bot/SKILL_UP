import 'dart:async';
import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/question.dart';
import '../services/course_service.dart';
import '../services/quiz_service.dart';
import '../theme/app_colors.dart';
import '../utils/glitch_page_route.dart';
import '../widgets/wireframe_grid_background.dart';
import '../widgets/brutal_button.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final CourseService courseService;
  final Course course;

  const QuizScreen({
    super.key,
    required this.courseService,
    required this.course,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  late List<Question> _quizQuestions;
  final Map<int, int> _selectedAnswers = {};
  int _currentIndex = 0;
  bool _isSubmitting = false;
  bool _showHint = false;

  // Anti-Palette Engine: Cognitive Latency / Hesitation Detection
  Timer? _hesitationTimer;
  double _questionSecondsElapsed = 0.0;
  bool _isHesitating = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _quizQuestions = QuizService.generateRandomQuestions(widget.course);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _pulseController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          if (_isHesitating) _pulseController.forward();
        }
      });

    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );

    _startHesitationWatchdog();
  }

  @override
  void dispose() {
    _hesitationTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startHesitationWatchdog() {
    _hesitationTimer?.cancel();
    _questionSecondsElapsed = 0.0;
    _isHesitating = false;
    _pulseController.reset();

    // Check every 200ms
    _hesitationTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      // If user hasn't selected an answer for this question yet
      if (!_selectedAnswers.containsKey(_currentIndex)) {
        _questionSecondsElapsed += 0.2;
        // Trigger hesitation blood orange pulse after 4.2 seconds
        if (_questionSecondsElapsed >= 4.2 && !_isHesitating) {
          setState(() {
            _isHesitating = true;
          });
          _pulseController.forward();
        }
      } else {
        if (_isHesitating) {
          setState(() {
            _isHesitating = false;
          });
          _pulseController.reset();
        }
      }
    });
  }

  void _onOptionSelected(int optionIndex) {
    setState(() {
      _selectedAnswers[_currentIndex] = optionIndex;
      _isHesitating = false;
    });
    _pulseController.reset();
  }

  void _nextQuestion() {
    if (_currentIndex < _quizQuestions.length - 1) {
      setState(() {
        _currentIndex++;
        _showHint = false;
      });
      _startHesitationWatchdog();
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showHint = false;
      });
      _startHesitationWatchdog();
    }
  }

  void _attemptSubmit() {
    if (_selectedAnswers.length < _quizQuestions.length) {
      final unansweredCount = _quizQuestions.length - _selectedAnswers.length;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          backgroundColor: AppColors.pitchBlack,
          title: const Text(
            '<ERR_INCOMPLETE_EVALUATION>',
            style: TextStyle(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w900,
              color: AppColors.glitchCrimson,
            ),
          ),
          content: Text(
            'Answer all 10 questions before submitting.\n\n$unansweredCount question(s) remain in unselected buffer.',
            style: const TextStyle(
              fontFamily: 'monospace',
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          actions: [
            BrutalButton(
              text: 'RESUME_QUESTIONS',
              onPressed: () => Navigator.pop(ctx),
              backgroundColor: AppColors.glitchCrimson,
              foregroundColor: Colors.white,
              isFullWidth: false,
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: AppColors.pitchBlack,
        title: const Text(
          '<SUBMIT_PROTOCOL_READY>',
          style: TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.w900,
            color: AppColors.acidGreen,
          ),
        ),
        content: const Text(
          '10/10 questions locked into on-device memory.\n\nScoring will execute instantaneously using pure Dart arithmetic (Passing mark: 60%).\n\nConfirm final submission?',
          style: TextStyle(
            fontFamily: 'monospace',
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('// REVIEW_LOGS',
                style: TextStyle(fontFamily: 'monospace', color: Colors.white)),
          ),
          BrutalButton(
            text: 'CONFIRM_SUBMISSION',
            onPressed: () {
              Navigator.pop(ctx);
              _finalizeSubmission();
            },
            backgroundColor: AppColors.acidGreen,
            foregroundColor: AppColors.pitchBlack,
            isFullWidth: false,
          ),
        ],
      ),
    );
  }

  void _finalizeSubmission() async {
    setState(() => _isSubmitting = true);

    final result = QuizService.evaluateQuiz(
      course: widget.course,
      questions: _quizQuestions,
      selectedAnswers: _selectedAnswers,
    );

    await widget.courseService.recordQuizResult(widget.course.id, result);

    if (mounted) {
      // Kinetic glitch tear transition into Result Screen
      GlitchPageRoute.pushReplacement(
        context,
        ResultScreen(
          courseService: widget.courseService,
          course: widget.course,
          quizResult: result,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentQ = _quizQuestions[_currentIndex];
    final selectedOption = _selectedAnswers[_currentIndex];
    final progress = (_currentIndex + 1) / _quizQuestions.length;
    final isLastQuestion = _currentIndex == _quizQuestions.length - 1;

    // Ambient background color reactivity from Anti-Palette Engine
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, _) {
        Color baseBg = isDark ? AppColors.voidBlack : AppColors.lightBg;
        if (_isHesitating) {
          // Pulse from Void Black into Blood Orange / Glitch Crimson
          final orangeTone = Color.lerp(
            baseBg,
            const Color(0xFF550C00), // Intense blood orange ambient glow
            _pulseAnimation.value * 0.85,
          )!;
          baseBg = orangeTone;
        }

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            final shouldLeave = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                backgroundColor: AppColors.pitchBlack,
                title: const Text(
                  '<ABORT_ASSESSMENT?>',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w900,
                    color: AppColors.glitchCrimson,
                  ),
                ),
                content: const Text(
                  'Unsubmitted responses will be purged from active session.',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('RESUME',
                        style: TextStyle(fontFamily: 'monospace', color: Colors.white)),
                  ),
                  BrutalButton(
                    text: 'ABORT_NOW',
                    onPressed: () => Navigator.pop(ctx, true),
                    backgroundColor: AppColors.glitchCrimson,
                    foregroundColor: Colors.white,
                    isFullWidth: false,
                  ),
                ],
              ),
            );
            if (shouldLeave == true && context.mounted) {
              Navigator.pop(context);
            }
          },
          child: Scaffold(
            backgroundColor: baseBg,
            appBar: AppBar(
              backgroundColor: baseBg,
              title: Text('// ${widget.course.title.toUpperCase()} // EXAM'),
              actions: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _isHesitating
                          ? AppColors.glitchCrimson
                          : (isDark ? const Color(0xFF1E1E1E) : const Color(0xFFE5E5DE)),
                      border: Border.all(
                        color: _isHesitating ? Colors.white : AppColors.acidGreen,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      '${_selectedAnswers.length}/10 LOCKED',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        color: _isHesitating ? Colors.white : AppColors.acidGreen,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: _isSubmitting
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColors.acidGreen),
                        SizedBox(height: 16),
                        Text(
                          '>>> COMPUTING SCORE ON-DEVICE >>>',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  )
                : WireframeGridBackground(
                    child: SafeArea(
                      child: Column(
                        children: [
                          // -----------------------------------------------------------
                          // TOP 58%: MONITOR & TELEMETRY DISPLAY ZONE
                          // -----------------------------------------------------------
                          Expanded(
                            flex: 58,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Cognitive Latency Warning Ticker (Anti-Palette State)
                                  if (_isHesitating)
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppColors.glitchCrimson,
                                        border: Border.all(
                                            color: Colors.white, width: 2.0),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.warning_amber_rounded,
                                              color: Colors.white, size: 18),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              '// COGNITIVE_LATENCY_DETECTED [${_questionSecondsElapsed.toStringAsFixed(1)}s] // OPERATOR_HESITATION',
                                              style: const TextStyle(
                                                fontSize: 9.5,
                                                fontWeight: FontWeight.w900,
                                                fontFamily: 'monospace',
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  else
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      color: isDark
                                          ? const Color(0xFF141414)
                                          : const Color(0xFFE5E5DE),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            '<STATUS: OPERATOR_INPUT_ACTIVE>',
                                            style: TextStyle(
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'monospace',
                                              color: AppColors.acidGreen,
                                            ),
                                          ),
                                          Text(
                                            selectedOption != null
                                                ? '// INPUT_LOCKED'
                                                : '// WAITING_RESPONSE',
                                            style: TextStyle(
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'monospace',
                                              color: selectedOption != null
                                                  ? AppColors.acidGreen
                                                  : (isDark
                                                      ? AppColors.darkTextMuted
                                                      : AppColors.lightTextMuted),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  // Question Progress Bar & Index Tag
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '// QUESTION [0${_currentIndex + 1}/10]',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'monospace',
                                          color: isDark
                                              ? AppColors.acidGreen
                                              : AppColors.pitchBlack,
                                        ),
                                      ),
                                      Text(
                                        '${(progress * 100).toInt()}% COMPLETE',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),

                                  // Hard Progress Bar
                                  Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF222222)
                                          : const Color(0xFFDDDDDD),
                                      border: Border.all(
                                        color: isDark
                                            ? Colors.white
                                            : AppColors.pitchBlack,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: progress.clamp(0.0, 1.0),
                                      child: Container(
                                        color: _isHesitating
                                            ? AppColors.glitchCrimson
                                            : AppColors.acidGreen,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  // 10-Question Matrix Palette
                                  SizedBox(
                                    height: 32,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _quizQuestions.length,
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(width: 5),
                                      itemBuilder: (context, idx) {
                                        final isAnswered =
                                            _selectedAnswers.containsKey(idx);
                                        final isCur = idx == _currentIndex;

                                        Color cellBg;
                                        Color cellFg;
                                        if (isCur) {
                                          cellBg = _isHesitating
                                              ? AppColors.glitchCrimson
                                              : AppColors.acidGreen;
                                          cellFg = isCur && _isHesitating
                                              ? Colors.white
                                              : AppColors.pitchBlack;
                                        } else if (isAnswered) {
                                          cellBg = isDark
                                              ? const Color(0xFF1E2E1E)
                                              : const Color(0xFFDCFCE7);
                                          cellFg = isDark
                                              ? AppColors.acidGreen
                                              : const Color(0xFF166534);
                                        } else {
                                          cellBg = isDark
                                              ? const Color(0xFF161616)
                                              : Colors.white;
                                          cellFg = isDark
                                              ? AppColors.darkTextMuted
                                              : AppColors.lightTextMuted;
                                        }

                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _currentIndex = idx;
                                              _showHint = false;
                                            });
                                            _startHesitationWatchdog();
                                          },
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: cellBg,
                                              border: Border.all(
                                                color: isCur
                                                    ? (isDark
                                                        ? Colors.white
                                                        : AppColors.pitchBlack)
                                                    : (isDark
                                                        ? const Color(0xFF444444)
                                                        : const Color(0xFFCCCCCC)),
                                                width: isCur ? 2.0 : 1.2,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${idx + 1}',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w900,
                                                  fontFamily: 'monospace',
                                                  color: cellFg,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // Question Prompt Card
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.darkSurface
                                          : AppColors.lightSurface,
                                      border: Border.all(
                                        color: _isHesitating
                                            ? AppColors.glitchCrimson
                                            : (isDark
                                                ? AppColors.darkBorder
                                                : AppColors.lightBorder),
                                        width: 2.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _isHesitating
                                              ? AppColors.glitchCrimson
                                              : (isDark
                                                  ? AppColors.acidGreen
                                                  : AppColors.pitchBlack),
                                          offset: const Offset(4, 4),
                                          blurRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2),
                                              color: isDark
                                                  ? Colors.white
                                                  : AppColors.pitchBlack,
                                              child: Text(
                                                'MODULE_ID: 0${currentQ.moduleId}',
                                                style: TextStyle(
                                                  fontSize: 9.5,
                                                  fontWeight: FontWeight.w900,
                                                  fontFamily: 'monospace',
                                                  color: isDark
                                                      ? AppColors.pitchBlack
                                                      : AppColors.acidGreen,
                                                ),
                                              ),
                                            ),

                                            if (currentQ.hint != null)
                                              GestureDetector(
                                                onTap: () => setState(() =>
                                                    _showHint = !_showHint),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 6,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.neonYellow,
                                                    border: Border.all(
                                                        color: AppColors
                                                            .pitchBlack,
                                                        width: 1.5),
                                                  ),
                                                  child: Text(
                                                    _showHint
                                                        ? '[HIDE_HINT]'
                                                        : '[DEBUG_HINT]',
                                                    style: const TextStyle(
                                                      fontSize: 9.5,
                                                      fontWeight: FontWeight.w900,
                                                      fontFamily: 'monospace',
                                                      color: AppColors.pitchBlack,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),

                                        const SizedBox(height: 10),

                                        Text(
                                          currentQ.questionText,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'monospace',
                                            height: 1.35,
                                            color: isDark
                                                ? AppColors.darkTextPrimary
                                                : AppColors.lightTextPrimary,
                                          ),
                                        ),

                                        if (_showHint &&
                                            currentQ.hint != null) ...[
                                          const SizedBox(height: 10),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: isDark
                                                  ? const Color(0xFF1E1A00)
                                                  : const Color(0xFFFFFBEB),
                                              border: Border.all(
                                                  color: AppColors.neonYellow,
                                                  width: 1.5),
                                            ),
                                            child: Text(
                                              '// HINT: ${currentQ.hint!}',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontFamily: 'monospace',
                                                fontWeight: FontWeight.w700,
                                                color: isDark
                                                    ? AppColors.darkTextPrimary
                                                    : AppColors.lightTextPrimary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // -----------------------------------------------------------
                          // BOTTOM 42%: SINGLE-THUMB VELOCITY REACH ZONE
                          // All critical interactions mapped strictly here!
                          // -----------------------------------------------------------
                          Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurface
                                  : AppColors.lightSurface,
                              border: Border(
                                top: BorderSide(
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.pitchBlack,
                                  width: 2.5,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.1)
                                      : AppColors.pitchBlack
                                          .withValues(alpha: 0.15),
                                  offset: const Offset(0, -3),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  '// SINGLE_THUMB_SELECTION_MATRIX:',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'monospace',
                                    color: isDark
                                        ? AppColors.darkTextMuted
                                        : AppColors.lightTextMuted,
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // 4 High-Density Option Buttons
                                ...List.generate(currentQ.options.length, (optIdx) {
                                  final isSelected = selectedOption == optIdx;
                                  const letters = ['A', 'B', 'C', 'D'];
                                  final letter = optIdx < letters.length
                                      ? letters[optIdx]
                                      : '${optIdx + 1}';
                                  final text = currentQ.options[optIdx];

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: GestureDetector(
                                      onTap: () => _onOptionSelected(optIdx),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 60),
                                        transform: Matrix4.translationValues(
                                          isSelected ? 3.0 : 0.0,
                                          isSelected ? 3.0 : 0.0,
                                          0.0,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 9),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? (isDark
                                                  ? AppColors.acidGreen
                                                  : AppColors.pitchBlack)
                                              : (isDark
                                                  ? const Color(0xFF141414)
                                                  : Colors.white),
                                          border: Border.all(
                                            color: isSelected
                                                ? (isDark
                                                    ? Colors.white
                                                    : AppColors.acidGreen)
                                                : (isDark
                                                    ? Colors.white
                                                    : AppColors.pitchBlack),
                                            width: isSelected ? 2.5 : 1.8,
                                          ),
                                          boxShadow: isSelected
                                              ? null
                                              : [
                                                  BoxShadow(
                                                    color: isDark
                                                        ? Colors.white.withValues(
                                                            alpha: 0.25)
                                                        : AppColors.pitchBlack,
                                                    offset: const Offset(3, 3),
                                                    blurRadius: 0,
                                                  ),
                                                ],
                                        ),
                                        child: Row(
                                          children: [
                                            // Letter Box
                                            Container(
                                              width: 22,
                                              height: 22,
                                              color: isSelected
                                                  ? (isDark
                                                      ? AppColors.pitchBlack
                                                      : AppColors.acidGreen)
                                                  : (isDark
                                                      ? Colors.white
                                                      : AppColors.pitchBlack),
                                              child: Center(
                                                child: Text(
                                                  letter,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w900,
                                                    fontFamily: 'monospace',
                                                    color: isSelected
                                                        ? (isDark
                                                            ? AppColors.acidGreen
                                                            : AppColors.pitchBlack)
                                                        : (isDark
                                                            ? AppColors.pitchBlack
                                                            : Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),

                                            Expanded(
                                              child: Text(
                                                text,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: isSelected
                                                      ? FontWeight.w900
                                                      : FontWeight.w600,
                                                  fontFamily: 'monospace',
                                                  color: isSelected
                                                      ? (isDark
                                                          ? AppColors.pitchBlack
                                                          : Colors.white)
                                                      : (isDark
                                                          ? AppColors
                                                              .darkTextPrimary
                                                          : AppColors
                                                              .lightTextPrimary),
                                                ),
                                              ),
                                            ),

                                            if (isSelected)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                        vertical: 2),
                                                color: isDark
                                                    ? AppColors.pitchBlack
                                                    : AppColors.acidGreen,
                                                child: Text(
                                                  'LOCKED',
                                                  style: TextStyle(
                                                    fontSize: 8.5,
                                                    fontWeight: FontWeight.w900,
                                                    fontFamily: 'monospace',
                                                    color: isDark
                                                        ? AppColors.acidGreen
                                                        : AppColors.pitchBlack,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),

                                const SizedBox(height: 6),

                                // Velocity Navigation Bar (Previous & Next/Submit)
                                Row(
                                  children: [
                                    if (_currentIndex > 0) ...[
                                      BrutalButton(
                                        text: '< PREV',
                                        onPressed: _previousQuestion,
                                        isFullWidth: false,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 12),
                                        backgroundColor: isDark
                                            ? const Color(0xFF222222)
                                            : const Color(0xFFE5E5DE),
                                        foregroundColor: isDark
                                            ? Colors.white
                                            : AppColors.pitchBlack,
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    Expanded(
                                      child: BrutalButton(
                                        text: isLastQuestion
                                            ? '>>> SUBMIT_EVALUATION >>>'
                                            : 'NEXT_QUESTION >',
                                        onPressed: isLastQuestion
                                            ? _attemptSubmit
                                            : _nextQuestion,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 12),
                                        backgroundColor: isLastQuestion
                                            ? AppColors.acidGreen
                                            : (isDark
                                                ? Colors.white
                                                : AppColors.pitchBlack),
                                        foregroundColor: isLastQuestion
                                            ? AppColors.pitchBlack
                                            : (isDark
                                                ? AppColors.pitchBlack
                                                : AppColors.acidGreen),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
