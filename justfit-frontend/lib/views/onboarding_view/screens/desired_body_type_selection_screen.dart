// lib/views/onboarding_view/screens/desired_body_type_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/onboarding_layout.dart';
import '../../../controllers/onboarding_controller.dart';

class DesiredBodyTypeSelectionScreen extends StatefulWidget {
  final String partTitle;
  final String question;
  final int currentPart;
  final int currentQuestionInPart;
  final int totalQuestionsInPart;
  final int totalParts;
  final int currentBodyFatIndex; // Index from previous screen
  final VoidCallback? onNext;
  final VoidCallback? onBack;

  const DesiredBodyTypeSelectionScreen({
    Key? key,
    required this.partTitle,
    required this.question,
    required this.currentBodyFatIndex,
    this.currentPart = 2,
    this.currentQuestionInPart = 5,
    this.totalQuestionsInPart = 5,
    this.totalParts = 4,
    this.onNext,
    this.onBack,
  }) : super(key: key);

  @override
  State<DesiredBodyTypeSelectionScreen> createState() => _DesiredBodyTypeSelectionScreenState();
}

class _DesiredBodyTypeSelectionScreenState extends State<DesiredBodyTypeSelectionScreen>
    with SingleTickerProviderStateMixin {
  late int _selectedDesiredBodyFatIndex;
  bool _imagesLoaded = false;

  // Get OnboardingController instance
  final OnboardingController _controller = Get.find<OnboardingController>();

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

    // Load previously selected value from controller, or default to one level below current
    final savedValue = _controller.desiredBodyType.value;
    if (savedValue != null) {
      _selectedDesiredBodyFatIndex = _bodyTypeNames.indexOf(savedValue);
      if (_selectedDesiredBodyFatIndex == -1 || _selectedDesiredBodyFatIndex >= widget.currentBodyFatIndex) {
        _selectedDesiredBodyFatIndex = (widget.currentBodyFatIndex - 1).clamp(0, 5);
      }
    } else {
      _selectedDesiredBodyFatIndex = (widget.currentBodyFatIndex - 1).clamp(0, 5);
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
    // Only allow selection of body types STRICTLY BELOW current (not equal)
    if (index < widget.currentBodyFatIndex) {
      setState(() {
        _selectedDesiredBodyFatIndex = index;
      });
      // Update controller immediately
      _controller.setDesiredBodyType(_bodyTypeNames[index]);
    }
  }

  void _handleNext() {
    // Save to controller before proceeding
    _controller.setDesiredBodyType(_bodyTypeNames[_selectedDesiredBodyFatIndex]);
    print('Current body type: ${_bodyTypeNames[widget.currentBodyFatIndex]} (${_bodyFatLabels[widget.currentBodyFatIndex]})');
    print('Desired body type: ${_bodyTypeNames[_selectedDesiredBodyFatIndex]} (${_bodyFatLabels[_selectedDesiredBodyFatIndex]})');
    if (widget.onNext != null) {
      widget.onNext!();
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
                            _bodyTypeImages[_selectedDesiredBodyFatIndex],
                            key: ValueKey<int>(_selectedDesiredBodyFatIndex),
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
                                    'Image not found:\n${_bodyTypeImages[_selectedDesiredBodyFatIndex]}',
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
                _bodyFatLabels[_selectedDesiredBodyFatIndex],
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                ),
              ),

              const SizedBox(height: 30),

              // Slider with progress bar and dots
              _buildBodyFatSlider(),

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: (details) => _handleSliderInteraction(details.localPosition.dx),
            onHorizontalDragUpdate: (details) => _handleSliderInteraction(details.localPosition.dx),
            onPanUpdate: (details) => _handleSliderInteraction(details.localPosition.dx),
            child: SizedBox(
              height: 50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background gray track (thick, rounded)
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 16.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E8E8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  
                  // Red progress line from DESIRED to CURRENT position
                  Positioned(
                    left: 0,
                    right: 0,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double totalWidth = constraints.maxWidth;
                        
                        // Calculate dot positions (dots are evenly spaced)
                        double dotSpacing = totalWidth / 5; // 6 dots = 5 gaps
                        
                        // Calculate actual pixel positions of the centers of dots
                        double desiredDotCenter = _selectedDesiredBodyFatIndex * dotSpacing;
                        double currentDotCenter = widget.currentBodyFatIndex * dotSpacing;
                        
                        // Red line spans from desired to current
                        double redLineLeft = desiredDotCenter;
                        double redLineWidth = currentDotCenter - desiredDotCenter;
                        
                        return Stack(
                          children: [
                            if (redLineWidth > 0) // Only show if there's a gap to fill
                              Positioned(
                                left: redLineLeft,
                                child: Container(
                                  width: redLineWidth,
                                  height: 16.0,
                                  decoration: BoxDecoration(
                                    color: _redColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  
                  // Dots row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      bool isCurrent = index == widget.currentBodyFatIndex;
                      bool isDesired = index == _selectedDesiredBodyFatIndex;
                      
                      return GestureDetector(
                        onTap: () {
                          if (index < widget.currentBodyFatIndex) {
                            _onBodyFatChanged(index);
                          }
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                          color: Colors.transparent,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            width: isDesired ? 28 : (isCurrent ? 16 : 7),
                            height: isDesired ? 28 : (isCurrent ? 16 : 7),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCurrent
                                  ? _redColor
                                  : isDesired
                                      ? Colors.white
                                      : const Color(0xFFB0B0B0),
                              border: isDesired
                                  ? Border.all(
                                      color: _redColor,
                                      width: 3.0,
                                    )
                                  : null,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Body fat < 15%',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF666666),
                ),
              ),
              Text(
                '> 40%',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF666666),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleSliderInteraction(double localX) {
    double sliderWidth = MediaQuery.of(context).size.width - 80;
    double percentage = localX / sliderWidth;
    int newIndex = (percentage * 5).round().clamp(0, widget.currentBodyFatIndex - 1);
    
    if (newIndex != _selectedDesiredBodyFatIndex && newIndex < widget.currentBodyFatIndex) {
      _onBodyFatChanged(newIndex);
    }
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
