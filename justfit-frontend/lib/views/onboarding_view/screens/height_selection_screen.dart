// lib/views/onboarding_view/screens/height_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/onboarding_layout.dart';
import '../../../controllers/onboarding_controller.dart'; // ← ADDED

class HeightSelectionScreen extends StatefulWidget {
  final String partTitle;
  final String question;
  final int currentPart;
  final int currentQuestionInPart;
  final int totalQuestionsInPart;
  final int totalParts;
  final VoidCallback? onNext;
  final VoidCallback? onBack;

  const HeightSelectionScreen({
    Key? key,
    required this.partTitle,
    required this.question,
    this.currentPart = 2,
    this.currentQuestionInPart = 1,
    this.totalQuestionsInPart = 3,
    this.totalParts = 4,
    this.onNext,
    this.onBack,
  }) : super(key: key);

  @override
  State<HeightSelectionScreen> createState() => _HeightSelectionScreenState();
}

class _HeightSelectionScreenState extends State<HeightSelectionScreen>
    with SingleTickerProviderStateMixin {
  // ✅ ADDED CONTROLLER
  final OnboardingController _controller = Get.find<OnboardingController>();
  
  bool _isCm = false; // false = ft, true = cm
  late FixedExtentScrollController _scrollController;
  
  // Height values
  int _selectedFeet = 5;
  int _selectedInches = 5;
  double _selectedCm = 165.1;
  
  // Ranges
  final int _minFeet = 3;
  final int _maxFeet = 8;
  final double _minCm = 100.0;
  final double _maxCm = 250.0;
  final double _cmStep = 0.1;
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // ✅ LOAD SAVED HEIGHT FROM CONTROLLER
    double savedHeight = _controller.height.value;
    if (savedHeight > 0) {
      if (_isCm) {
        _selectedCm = savedHeight;
      } else {
        // Convert cm to ft/in
        double totalInches = savedHeight / 2.54;
        _selectedFeet = totalInches ~/ 12;
        _selectedInches = (totalInches % 12).round();
      }
    }
    
    // Initialize scroll controller
    _scrollController = FixedExtentScrollController(
      initialItem: _isCm ? _cmToIndex(_selectedCm) : (_selectedFeet - _minFeet) * 12 + _selectedInches,
    );
    
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
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  int _cmToIndex(double cm) {
    return ((cm - _minCm) / _cmStep).round();
  }

  double _indexToCm(int index) {
    return _minCm + (index * _cmStep);
  }

  void _toggleUnit() {
  setState(() {
    if (_isCm) {
      // Convert cm to ft/in
      double totalInches = _selectedCm / 2.54;
      _selectedFeet = totalInches ~/ 12;
      _selectedInches = (totalInches % 12).round();
      
      int newIndex = (_selectedFeet - _minFeet) * 12 + _selectedInches;
      _scrollController.dispose();
      _scrollController = FixedExtentScrollController(
        initialItem: newIndex,
      );
      _isCm = !_isCm;
      
      // Force rebuild after state change
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _scrollController.jumpToItem(newIndex);
        }
      });
    } else {
      // Convert ft/in to cm
      _selectedCm = ((_selectedFeet * 12 + _selectedInches) * 2.54);
      
      int newIndex = _cmToIndex(_selectedCm);
      _scrollController.dispose();
      _scrollController = FixedExtentScrollController(
        initialItem: newIndex,
      );
      _isCm = !_isCm;
      
      // Force rebuild after state change
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _scrollController.jumpToItem(newIndex);
        }
      });
    }
  });
}

  void _onHeightChanged(int index) {
    setState(() {
      if (_isCm) {
        _selectedCm = _indexToCm(index);
      } else {
        int totalInches = index;
        _selectedFeet = _minFeet + (totalInches ~/ 12);
        _selectedInches = totalInches % 12;
      }
    });
    
    // ✅ SAVE TO CONTROLLER IMMEDIATELY
    double heightInCm = _isCm ? _selectedCm : ((_selectedFeet * 12 + _selectedInches) * 2.54);
    _controller.setHeight(heightInCm);
  }

  String _getDisplayValue() {
    if (_isCm) {
      return '${_selectedCm.toStringAsFixed(1)} cm';
    } else {
      return '$_selectedFeet\'$_selectedInches"';
    }
  }

  void _handleNext() {
    // ✅ SAVE FINAL HEIGHT IN CM
    double heightInCm = _isCm ? _selectedCm : ((_selectedFeet * 12 + _selectedInches) * 2.54);
    _controller.setHeight(heightInCm);
    
    print('Selected height: ${_getDisplayValue()} (${heightInCm.toStringAsFixed(1)} cm)');
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
          child: Column(
            children: [
              const SizedBox(height: 32),

              // Question
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

              const SizedBox(height: 32),

              // Unit toggle
              _buildUnitToggle(),

              const SizedBox(height: 40),

              // Ruler with selected value - ENTIRE AREA IS SCROLLABLE
              Expanded(
                child: Stack(
                  children: [
                    // Invisible overlay that captures scroll gestures ANYWHERE
                    Positioned.fill(
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          final double itemExtent = 40.0;
                          final double itemsToScroll = -details.delta.dy / itemExtent;
                          
                          final int currentItem = _scrollController.selectedItem;
                          final int itemCount = _isCm 
                              ? (((_maxCm - _minCm) / _cmStep).ceil() + 1)
                              : ((_maxFeet - _minFeet + 1) * 12);
                          
                          int newItem = (currentItem + itemsToScroll).round();
                          newItem = newItem.clamp(0, itemCount - 1);
                          
                          if (newItem != currentItem) {
                            _scrollController.jumpToItem(newItem);
                          }
                        },
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                    
                    // Ruler on left side
                    _buildRuler(),
                    
                    // Selected value in center
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 80),
                        child: Text(
                          _getDisplayValue(),
                          style: GoogleFonts.poppins(
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF000000),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Next button
              _buildNextButton(),

              const SizedBox(height: 16),
            ],
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
            // Animated background
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              left: _isCm ? 80 : 0,
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
            
            // Buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (_isCm) _toggleUnit();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'ft',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _isCm ? const Color(0xFFFA2A55) : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (!_isCm) _toggleUnit();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'cm',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _isCm ? Colors.white : const Color(0xFFFA2A55),
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

  Widget _buildRuler() {
    final int itemCount = _isCm 
        ? (((_maxCm - _minCm) / _cmStep).ceil() + 1)
        : ((_maxFeet - _minFeet + 1) * 12);

    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        children: [
          // Ruler marks and numbers
          SizedBox(
            width: 60,
            child: IgnorePointer(
              child: ListWheelScrollView.useDelegate(
                controller: _scrollController,
                itemExtent: 40,
                diameterRatio: 2.5,
                perspective: 0.003,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: _onHeightChanged,
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: itemCount,
                  builder: (context, index) {
                    return _buildRulerItem(index);
                  },
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 4),
          
          // Red indicator line
          Container(
            width: 30,
            height: 2,
            color: const Color(0xFFFA2A55),
          ),
        ],
      ),
    );
  }

  Widget _buildRulerItem(int index) {
    if (_isCm) {
      double cmValue = _indexToCm(index);
      bool isWhole = cmValue % 1 == 0;
      
      if (isWhole) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              cmValue.toInt().toString(),
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF000000),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 15,
              height: 2,
              color: const Color(0xFF000000),
            ),
          ],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(width: 30),
            Container(
              width: 8,
              height: 1.5,
              color: const Color(0xFF000000).withOpacity(0.3),
            ),
          ],
        );
      }
    } else {
      // Feet/inches
      int totalInches = index;
      int feet = _minFeet + (totalInches ~/ 12);
      int inches = totalInches % 12;
      
      if (inches == 0) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              feet.toString(),
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF000000),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 15,
              height: 2,
              color: const Color(0xFF000000),
            ),
          ],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(width: 30),
            Container(
              width: 8,
              height: 1.5,
              color: const Color(0xFF000000).withOpacity(0.3),
            ),
          ],
        );
      }
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