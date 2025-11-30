// lib/views/onboarding_view/screens/body_type_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/onboarding_layout.dart';
import '../../../controllers/onboarding_controller.dart';
import '../widgets/custom_dot_slider.dart';


class BodyTypeSelectionScreen extends StatefulWidget {
  final String partTitle;
  final String question;
  final int currentPart;
  final int currentQuestionInPart;
  final int totalQuestionsInPart;
  final int totalParts;
  final void Function(int selectedBodyFatIndex)? onNext;
  final VoidCallback? onBack;

  const BodyTypeSelectionScreen({
    Key? key,
    required this.partTitle,
    required this.question,
    this.currentPart = 2,
    this.currentQuestionInPart = 4,
    this.totalQuestionsInPart = 4,
    this.totalParts = 4,
    this.onNext,
    this.onBack,
  }) : super(key: key);

  @override
  State<BodyTypeSelectionScreen> createState() => _BodyTypeSelectionScreenState();
}

class _BodyTypeSelectionScreenState extends State<BodyTypeSelectionScreen>
    with SingleTickerProviderStateMixin {
  final OnboardingController _controller = Get.find<OnboardingController>();
  int _selectedBodyFatIndex = 2;
  bool _imagesLoaded = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Colors
  final Color _redColor = const Color(0xFFFA2A55);
  final Color _lightGreyColor = const Color(0xFFE0E0E0);

  // Body fat ranges and labels - 6 TYPES
  final List<String> _bodyFatLabels = [
    '< 15%',
    '15 - 20%',
    '21 - 25%',
    '26 - 30%',
    '31 - 40%',
    '> 40%',
  ];

  final List<String> _bodyTypeNames = [
    'Athletic',
    'Lean',
    'Fit',
    'Average',
    'Curvy',
    'Plus Size',
  ];

  // Image paths - 6 IMAGES
  final List<String> _bodyTypeImages = [
    'assets/images/onboarding/body_type_1.png',
    'assets/images/onboarding/body_type_2.png',
    'assets/images/onboarding/body_type_3.png',
    'assets/images/onboarding/body_type_4.png',
    'assets/images/onboarding/body_type_5.png',
    'assets/images/onboarding/body_type_6.png',
  ];

    @override
  void initState() {
    super.initState();

    // ✅ LOAD SAVED BODY TYPE
    final savedBodyType = _controller.currentBodyType.value;
    if (savedBodyType != null) {
      final bodyTypeValues = ['athletic', 'lean', 'fit', 'average', 'curvy', 'plus_size'];
      final savedIndex = bodyTypeValues.indexOf(savedBodyType);
      if (savedIndex != -1) {
        _selectedBodyFatIndex = savedIndex;
        print('✅ Loaded saved body type: $savedBodyType (index: $savedIndex)');
      }
    }

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();

    // Precache all images immediately for instant transitions
    _precacheImages();
  }

  Future<void> _precacheImages() async {
    try {
      final List<Future<void>> precacheFutures = _bodyTypeImages.map((imagePath) {
        return precacheImage(
          AssetImage(imagePath),
          context,
          onError: (exception, stackTrace) {
            print('Error loading image: $imagePath');
            print('Exception: $exception');
          },
        );
      }).toList();
      
      await Future.wait(precacheFutures);
      
      if (mounted) {
        setState(() {
          _imagesLoaded = true;
        });
      }
    } catch (e) {
      print('Error precaching images: $e');
      // Still allow the screen to show even if precaching fails
      if (mounted) {
        setState(() {
          _imagesLoaded = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onBodyFatChanged(int index) {
  setState(() {
    _selectedBodyFatIndex = index;
  });
  
  // ✅ SAVE TO CONTROLLER IMMEDIATELY
  final bodyTypeValues = ['athletic', 'lean', 'fit', 'average', 'curvy', 'plus_size'];
  _controller.setCurrentBodyType(bodyTypeValues[index]);
  print('✅ Saved body type: ${bodyTypeValues[index]}');
}

void _handleNext() {
  // ✅ SAVE FINAL BODY TYPE
  final bodyTypeValues = ['athletic', 'lean', 'fit', 'average', 'curvy', 'plus_size'];
  _controller.setCurrentBodyType(bodyTypeValues[_selectedBodyFatIndex]);
  
  print('Selected body type: ${_bodyTypeNames[_selectedBodyFatIndex]}');
  print('Body fat range: ${_bodyFatLabels[_selectedBodyFatIndex]}');
  print('✅ Saved to controller: ${bodyTypeValues[_selectedBodyFatIndex]}');
  
  if (widget.onNext != null) {
    widget.onNext!(_selectedBodyFatIndex);
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
          child: Column(
            children: [
              const SizedBox(height: 32),

              Text(
                widget.question,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Body image with instant transition
              Expanded(
                child: Center(
                  child: _imagesLoaded
                      ? AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          switchInCurve: Curves.easeInOut,
                          switchOutCurve: Curves.easeInOut,
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: Image.asset(
                            _bodyTypeImages[_selectedBodyFatIndex],
                            key: ValueKey<int>(_selectedBodyFatIndex),
                            height: MediaQuery.of(context).size.height * 0.45,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.image_not_supported,
                                    size: 64,
                                    color: Color(0xFFE8E8E8),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Image not found:\n${_bodyTypeImages[_selectedBodyFatIndex]}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: const Color(0xFF666666),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(
                                color: Color(0xFFFA2A55),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Loading images...',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: const Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // Body fat percentage label
              Text(
                _bodyFatLabels[_selectedBodyFatIndex],
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                ),
              ),

              const SizedBox(height: 30),

              // Slider with dots
              _buildBodyFatSlider(),

              const SizedBox(height: 20),

              const SizedBox(height: 40),

              _buildNextButton(),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildBodyFatSlider() {
  return CustomDotSlider(
    totalDots: 6,
    selectedIndex: _selectedBodyFatIndex,
    onChanged: _onBodyFatChanged,
    leftLabel: 'Body fat < 15%',
    rightLabel: '> 40%',
  );
}

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: const Color(0xFF000000),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _handleNext,
            borderRadius: BorderRadius.circular(14),
            child: Center(
              child: Text(
                'Next',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}