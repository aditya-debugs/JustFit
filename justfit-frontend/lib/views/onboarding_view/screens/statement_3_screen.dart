import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/onboarding_layout.dart';
import '../widgets/statement_card_widget.dart';
import '../../../controllers/onboarding_controller.dart';

class Statement3Screen extends StatefulWidget {
  final String partTitle;
  final int currentPart;
  final int currentQuestionInPart;
  final int totalQuestionsInPart;
  final int totalParts;
  final VoidCallback? onBack;
  final void Function(bool)? onNext;

  const Statement3Screen({
    Key? key,
    required this.partTitle,
    this.currentPart = 4,
    this.currentQuestionInPart = 11,
    this.totalQuestionsInPart = 11,
    this.totalParts = 4,
    this.onBack,
    this.onNext,
  }) : super(key: key);

  @override
  State<Statement3Screen> createState() => _Statement3ScreenState();
}

class _Statement3ScreenState extends State<Statement3Screen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  // Get controller instance
  late final OnboardingController _controller;

  @override
  void initState() {
    super.initState();
    
    // Initialize controller
    _controller = Get.find<OnboardingController>();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _handleAnswer(bool answer) {
    print('Statement 3 answered: ${answer ? "Yes" : "No"}');
    
    // Save to controller
    _controller.setEasilyGiveUp(answer);
    
    // Call parent callback
    if (widget.onNext != null) {
      widget.onNext!(answer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      partTitle: widget.partTitle,
      currentPart: widget.currentPart,
      currentQuestionInPart: widget.currentQuestionInPart,
      totalQuestionsInPart: widget.totalQuestionsInPart,
      totalParts: widget.totalParts,
      showBackButton: true,
      onBack: widget.onBack,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: StatementCardWidget(
            statement: 'I can easily give up when the exercises are too hard or boring.',
            imagePath: 'assets/images/onboarding/statement_3.png',
            onAnswer: _handleAnswer,
          ),
        ),
      ),
    );
  }
}