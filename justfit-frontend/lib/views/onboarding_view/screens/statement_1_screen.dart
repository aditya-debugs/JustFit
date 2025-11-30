import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/onboarding_layout.dart';
import '../widgets/statement_card_widget.dart';
import '../../../controllers/onboarding_controller.dart';

class Statement1Screen extends StatefulWidget {
  final String partTitle;
  final int currentPart;
  final int currentQuestionInPart;
  final int totalQuestionsInPart;
  final int totalParts;
  final VoidCallback? onBack;
  final void Function(bool)? onNext;

  const Statement1Screen({
    Key? key,
    required this.partTitle,
    this.currentPart = 4,
    this.currentQuestionInPart = 9,
    this.totalQuestionsInPart = 11,
    this.totalParts = 4,
    this.onBack,
    this.onNext,
  }) : super(key: key);

  @override
  State<Statement1Screen> createState() => _Statement1ScreenState();
}

class _Statement1ScreenState extends State<Statement1Screen>
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
    print('Statement 1 answered: ${answer ? "Yes" : "No"}');
    
    // Save to controller
    _controller.setBodyDissatisfaction(answer);
    
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
            statement: 'I always feel unsatisfied with my body when I see the mirror.',
            imagePath: 'assets/images/onboarding/statement_1.png',
            onAnswer: _handleAnswer,
          ),
        ),
      ),
    );
  }
}