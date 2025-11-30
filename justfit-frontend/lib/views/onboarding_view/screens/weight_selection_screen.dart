// lib/views/onboarding_view/screens/weight_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/onboarding_layout.dart';
import '../../../controllers/onboarding_controller.dart';

class WeightSelectionScreen extends StatefulWidget {
  final String partTitle;
  final String question;
  final int currentPart;
  final int currentQuestionInPart;
  final int totalQuestionsInPart;
  final int totalParts;
  final double? userHeightCm;
  final VoidCallback? onNext;
  final VoidCallback? onBack;

  const WeightSelectionScreen({
    Key? key,
    required this.partTitle,
    required this.question,
    this.currentPart = 2,
    this.currentQuestionInPart = 2,
    this.totalQuestionsInPart = 3,
    this.totalParts = 4,
    this.userHeightCm,
    this.onNext,
    this.onBack,
  }) : super(key: key);

  @override
  State<WeightSelectionScreen> createState() => _WeightSelectionScreenState();
}

class _WeightSelectionScreenState extends State<WeightSelectionScreen>
    with SingleTickerProviderStateMixin {
  final OnboardingController _controller = Get.find<OnboardingController>();
  bool _isKg = false;
  
  double _selectedLbs = 150.0;
  double _selectedKg = 68.0;
  
  final double _minLbs = 80.0;
  final double _maxLbs = 400.0;
  final double _lbsStep = 1.0;
  final double _minKg = 35.0;
  final double _maxKg = 180.0;
  final double _kgStep = 0.1;
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // ✅ LOAD SAVED WEIGHT
  double savedWeight = _controller.weight.value;
  if (savedWeight > 0) {
    _selectedKg = savedWeight;
    _selectedLbs = savedWeight * 2.20462;
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
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  int _lbsToIndex(double lbs) {
    return ((lbs - _minLbs) / _lbsStep).round();
  }

  double _indexToLbs(int index) {
    return _minLbs + (index * _lbsStep);
  }

  int _kgToIndex(double kg) {
    return ((kg - _minKg) / _kgStep).round();
  }

  double _indexToKg(int index) {
    return _minKg + (index * _kgStep);
  }

  void _toggleUnit() {
    setState(() {
      if (_isKg) {
        // Converting FROM kg TO lbs - maintain the weight value
        _selectedLbs = _selectedKg * 2.20462;
      } else {
        // Converting FROM lbs TO kg - maintain the weight value
        _selectedKg = _selectedLbs / 2.20462;
      }
      _isKg = !_isKg;
    });
  }

  void _onWeightChanged(double value) {
  setState(() {
    if (_isKg) {
      _selectedKg = value;
    } else {
      _selectedLbs = value;
    }
  });
  
  // ✅ SAVE TO CONTROLLER IMMEDIATELY
  double weightInKg = _isKg ? _selectedKg : (_selectedLbs / 2.20462);
  _controller.setWeight(weightInKg);
}

  String _getDisplayValue() {
    if (_isKg) {
      return '${_selectedKg.toStringAsFixed(1)} kg';
    } else {
      return '${_selectedLbs.toInt()} lbs';
    }
  }

  double _calculateBMI() {
    double heightCm = widget.userHeightCm ?? 165.0;
    double heightM = heightCm / 100;
    double weightKg = _isKg ? _selectedKg : (_selectedLbs / 2.20462);
    
    return weightKg / (heightM * heightM);
  }

  String _getBMIMessage(double bmi) {
    if (bmi < 18.5) {
      return "You have great potential to get in better shape. Move now!";
    } else if (bmi >= 18.5 && bmi < 25) {
      return "You've got a great figure, keep it up!";
    } else if (bmi >= 25 && bmi < 30) {
      return "You only need a bit more sweat exercise to see a fitter you!";
    } else {
      return "You have great potential to get fitter. We will use your index to tailor a personal plan for you.";
    }
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) {
      return const Color(0xFF2196F3);
    } else if (bmi >= 18.5 && bmi < 25) {
      return const Color(0xFF4CAF50);
    } else if (bmi >= 25 && bmi < 30) {
      return const Color(0xFFFF9800);
    } else {
      return const Color(0xFFFF5252);
    }
  }

  void _handleNext() {
  // ✅ SAVE FINAL WEIGHT IN KG
  double weightInKg = _isKg ? _selectedKg : (_selectedLbs / 2.20462);
  _controller.setWeight(weightInKg);
  
  print('Selected weight: ${_getDisplayValue()} (${weightInKg.toStringAsFixed(1)} kg)');
  print('BMI: ${_calculateBMI().toStringAsFixed(1)}');
  print('✅ Saved to controller');
  
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),

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

                        const SizedBox(height: 24),

                        _buildUnitToggle(),

                        const SizedBox(height: 30),

                        Text(
                          _getDisplayValue(),
                          style: GoogleFonts.poppins(
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF000000),
                          ),
                        ),

                        const Spacer(),

                        _buildHorizontalRuler(),

                        const SizedBox(height: 20),

                        _buildBMICard(),

                        const SizedBox(height: 20),

                        _buildNextButton(),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildUnitToggle() {
    return Center(
      child: Container(
        width: 160,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFFA2A55),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              left: _isKg ? 80 : 0,
              top: 0,
              bottom: 0,
              width: 80,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFA2A55),
                  borderRadius: BorderRadius.circular(23),
                ),
              ),
            ),
            
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (_isKg) _toggleUnit();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'lbs',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _isKg ? const Color(0xFFFA2A55) : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (!_isKg) _toggleUnit();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'kg',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _isKg ? Colors.white : const Color(0xFFFA2A55),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBMICard() {
    double bmi = _calculateBMI();
    Color bmiColor = _getBMIColor(bmi);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE8E8E8),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your BMI:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF000000),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  bmi.toStringAsFixed(1),
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: bmiColor,
                  ),
                ),
              ],
            ),
            
            const SizedBox(width: 20),
            
            Expanded(
              child: Text(
                _getBMIMessage(bmi),
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF666666),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalRuler() {
  final double minValue = _isKg ? _minKg : _minLbs;
  final double maxValue = _isKg ? _maxKg : _maxLbs;
  final double step = _isKg ? _kgStep : _lbsStep;
  final double currentValue = _isKg ? _selectedKg : _selectedLbs;
  
  final int totalTicks = ((maxValue - minValue) / step).ceil() + 1;

  return Container(
    height: 80,
    color: Colors.transparent,
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Horizontal scrollable ruler
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            final double sensitivity = _isKg ? 0.08 : 0.2; // ADJUSTED for better feel with new spacing
            double delta = -details.delta.dx * sensitivity;
            double newValue = (currentValue + delta).clamp(minValue, maxValue);
            
            // Snap to step
            if (_isKg) {
              newValue = (newValue / step).round() * step;
            } else {
              newValue = newValue.roundToDouble();
            }
            
            if (newValue != currentValue) {
              _onWeightChanged(newValue);
            }
          },
          child: Container(
            color: Colors.transparent,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 80),
              painter: HorizontalRulerPainter(
                minValue: minValue,
                maxValue: maxValue,
                currentValue: currentValue,
                step: step,
                isKg: _isKg,
              ),
            ),
          ),
        ),
        
        // Center red indicator line (fixed in center)
        Positioned(
          bottom: 0,
          child: Container(
            width: 3,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFFA2A55),
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
        ),
      ],
    ),
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

// Custom painter for horizontal ruler
// Custom painter for horizontal ruler
class HorizontalRulerPainter extends CustomPainter {
  final double minValue;
  final double maxValue;
  final double currentValue;
  final double step;
  final bool isKg;

  HorizontalRulerPainter({
    required this.minValue,
    required this.maxValue,
    required this.currentValue,
    required this.step,
    required this.isKg,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double tickSpacing = isKg ? 12.0 : 8.0; // INCREASED spacing for kg
    
    // Calculate which ticks to show
    final int centerIndex = ((currentValue - minValue) / step).round();
    final int visibleTicks = (size.width / tickSpacing).ceil();
    final int startIndex = (centerIndex - visibleTicks ~/ 2 - 10).clamp(0, ((maxValue - minValue) / step).ceil());
    final int endIndex = (centerIndex + visibleTicks ~/ 2 + 10).clamp(0, ((maxValue - minValue) / step).ceil() + 1);
    
    for (int i = startIndex; i < endIndex; i++) {
      final double value = minValue + (i * step);
      final double offset = (i - centerIndex) * tickSpacing;
      final double x = centerX + offset;
      
      if (x < 0 || x > size.width) continue;
      
      // CHANGED: For kg, show label every 1kg instead of every 5kg
      bool isMajor = isKg ? (value % 1 == 0) : (value % 10 == 0);
      bool isMinor = isKg ? (value % 0.5 == 0) : (value % 5 == 0);
      
      // Draw tick
      final Paint tickPaint = Paint()
        ..color = Colors.black.withOpacity(isMajor ? 0.7 : 0.3)
        ..strokeWidth = 1.5;
      
      double tickHeight = isMajor ? 24 : (isMinor ? 16 : 10);
      canvas.drawLine(
        Offset(x, size.height - tickHeight),
        Offset(x, size.height),
        tickPaint,
      );
      
      // Draw number for major ticks
      if (isMajor) {
        final textSpan = TextSpan(
          text: isKg ? value.toInt().toString() : value.toInt().toString(),
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF666666),
          ),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, size.height - tickHeight - textPainter.height - 4),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant HorizontalRulerPainter oldDelegate) {
    return oldDelegate.currentValue != currentValue ||
        oldDelegate.isKg != isKg;
  }
}