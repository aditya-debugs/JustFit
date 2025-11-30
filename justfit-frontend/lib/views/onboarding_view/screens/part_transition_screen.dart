import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PartTransitionScreen extends StatefulWidget {
  final int? partNumber;
  final String partTitle;
  final VoidCallback onComplete;
  final bool showPartLabel;

  const PartTransitionScreen({
    Key? key,
    this.partNumber,
    required this.partTitle,
    required this.onComplete,
    this.showPartLabel = true,
  }) : super(key: key);

  @override
  State<PartTransitionScreen> createState() => _PartTransitionScreenState();
}

class _PartTransitionScreenState extends State<PartTransitionScreen>
    with TickerProviderStateMixin {
  late AnimationController _partController;
  late AnimationController _lineController;
  late AnimationController _goalController;
  late AnimationController _fadeController;

  late Animation<Offset> _partSlideAnimation;
  late Animation<double> _lineAnimation;
  late Animation<double> _lineOpacityAnimation;
  late Animation<Offset> _goalSlideAnimation;
  late Animation<double> _goalOpacityAnimation; // ✅ NEW: Opacity for title
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _partController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _lineController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _goalController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _partSlideAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _partController,
      curve: Curves.easeOutCubic,
    ));

    _lineAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _lineController,
      curve: Curves.easeInCubic,
    ));

    _lineOpacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _lineController,
      curve: Curves.easeIn,
    ));

    _goalSlideAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _goalController,
      curve: Curves.easeOutCubic,
    ));

    // ✅ NEW: Opacity animation for title text
    _goalOpacityAnimation = Tween<double>(
      begin: 0.0, // Start invisible
      end: 1.0,   // Fade to visible
    ).animate(CurvedAnimation(
      parent: _goalController,
      curve: Curves.easeIn,
    ));

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
  // Part number slides in
  _partController.forward();
  
  // Wait, then line appears
  await Future.delayed(const Duration(milliseconds: 300));
  _lineController.forward();
  
  // ✅ REDUCED: Wait less time before title appears (line + title overlap)
  await Future.delayed(const Duration(milliseconds: 150));
  _goalController.forward();
  
  // Wait, then fade out entire screen
  await Future.delayed(const Duration(milliseconds: 800));
  await _fadeController.forward();
  widget.onComplete();
}

  @override
  void dispose() {
    _partController.dispose();
    _lineController.dispose();
    _goalController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // "Part X" text - only shown if showPartLabel is true
              if (widget.showPartLabel && widget.partNumber != null) ...[
                SlideTransition(
                  position: _partSlideAnimation,
                  child: Text(
                    'Part ${widget.partNumber}',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFFA2A55),
                      letterSpacing: 0.5,
                      height: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],

              // Animated line - only shown if showPartLabel is true
              if (widget.showPartLabel) ...[
                AnimatedBuilder(
                  animation: _lineController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _lineOpacityAnimation.value,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 100 * _lineAnimation.value,
                          height: 3,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFA2A55),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
              ],

              // ✅ FIXED: Title text with opacity animation
              FadeTransition(
                opacity: _goalOpacityAnimation,
                child: SlideTransition(
                  position: _goalSlideAnimation,
                  child: Text(
                    widget.partTitle,
                    style: GoogleFonts.poppins(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF000000),
                      letterSpacing: -2.0,
                      height: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}