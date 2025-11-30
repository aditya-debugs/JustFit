// lib/views/onboarding_view/screens/height_selection_screen.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/onboarding_layout.dart';
import '../../../controllers/onboarding_controller.dart';

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
  // get controller from GetX
  final OnboardingController _controller = Get.find<OnboardingController>();

  // Unit: false -> ft/in, true -> cm
  bool _isCm = false;

  late FixedExtentScrollController _scrollController;

  // selected values
  int _selectedFeet = 5;
  int _selectedInches = 5;
  double _selectedCm = 165.1;

  // ranges
  final int _minFeet = 3;
  final int _maxFeet = 8;
  final double _minCm = 100.0;
  final double _maxCm = 250.0;
  final double _cmStep = 0.1;

  // animation controllers for screen transition
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // convenience getters for item counts
  int get _cmItemCount =>
      ((_maxCm - _minCm) / _cmStep).round() + 1; // inclusive endpoints

  int get _ftInchItemCount => (_maxFeet - _minFeet + 1) * 12;

  @override
  void initState() {
    super.initState();

    // load saved height from onboarding controller (assume value in cm)
    double saved = _controller.height.value;
    if (saved > 0) {
      // by default _isCm is false; but we set both selected values so toggle works fine
      _selectedCm = saved;
      final double totalInches = saved / 2.54;
      _selectedFeet = totalInches ~/ 12;
      _selectedInches = (totalInches % 12).round();
      // normalize within ranges
      _selectedFeet = _selectedFeet.clamp(_minFeet, _maxFeet);
      _selectedInches = _selectedInches.clamp(0, 11);
    }

    // initialize scroll controller according to initial unit (ft/in)
    final int initialIndex = _isCm
        ? _cmToIndex(_selectedCm)
        : (_selectedFeet - _minFeet) * 12 + _selectedInches;
    _scrollController = FixedExtentScrollController(initialItem: initialIndex);

    // animations
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ).drive(Tween(begin: 0.0, end: 1.0));
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
    _scrollController.dispose();
    super.dispose();
  }

  // Helpers to convert between cm and index
  int _cmToIndex(double cm) {
    final int idx = ((cm - _minCm) / _cmStep).round();
    return idx.clamp(0, _cmItemCount - 1);
  }

  double _indexToCm(int index) {
    return (_minCm + index * _cmStep);
  }

  // toggle unit and keep selected visible
  void _toggleUnit() {
    final bool targetIsCm = !_isCm;

    // current selected height in cm (always derive accurate value)
    final double currentCm =
        _isCm ? _selectedCm : ((_selectedFeet * 12 + _selectedInches) * 2.54);

    // compute new index for target unit
    int newIndex;
    if (targetIsCm) {
      newIndex = _cmToIndex(currentCm);
    } else {
      // convert cm to total inches index for ft/in wheel
      final int totalInches = (currentCm / 2.54).round();
      final int ftIndex = (totalInches ~/ 12) - _minFeet;
      final int inchesIndex = totalInches % 12;
      newIndex = (ftIndex * 12 + inchesIndex).clamp(0, _ftInchItemCount - 1);
    }

    // dispose and replace controller safely
    _scrollController.dispose();
    _scrollController = FixedExtentScrollController(initialItem: newIndex);

    // flip unit state and update selected values based on the new index
    setState(() {
      _isCm = targetIsCm;
      if (_isCm) {
        _selectedCm = _indexToCm(newIndex);
      } else {
        int totalInches = newIndex;
        _selectedFeet = _minFeet + (totalInches ~/ 12);
        _selectedInches = totalInches % 12;
      }
    });

    // save converted height into controller
    final double heightInCm =
        _isCm ? _selectedCm : ((_selectedFeet * 12 + _selectedInches) * 2.54);
    _controller.setHeight(heightInCm);

    // ensure wheel shows the selected item after rebuild
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        try {
          _scrollController.jumpToItem(newIndex);
        } catch (_) {
          // ignore if controller not attached yet
        }
      }
    });
  }

  // when wheel selection changes
  void _onHeightChanged(int index) {
    setState(() {
      if (_isCm) {
        _selectedCm = _indexToCm(index);
      } else {
        final int totalInches = index;
        _selectedFeet = _minFeet + (totalInches ~/ 12);
        _selectedInches = totalInches % 12;
      }
    });

    final double heightInCm =
        _isCm ? _selectedCm : ((_selectedFeet * 12 + _selectedInches) * 2.54);

    // immediately save
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
    final double heightInCm =
        _isCm ? _selectedCm : ((_selectedFeet * 12 + _selectedInches) * 2.54);

    _controller.setHeight(heightInCm);

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
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
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

        // Ruler area - expands to fill remaining height and allows normal scrolling
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Stack(
              children: [
                // Ruler (left)
                Align(
                  alignment: Alignment.centerLeft,
                  child: _buildRuler(),
                ),

                // Display value centered (non-interactive)
                IgnorePointer(
                  child: Center(
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
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Next button
        _buildNextButton(),

        const SizedBox(height: 16),
      ],
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
    final int itemCount = _isCm ? _cmItemCount : _ftInchItemCount;

    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        children: [
          // Wheel
          SizedBox(
            width: 60,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                // We don't need to do extra work here because ListWheelScrollView
                // calls onSelectedItemChanged. But this will ensure scroll notifications
                // don't bubble weirdly.
                return false;
              },
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
      final double cmValue = _indexToCm(index);
      final bool isWhole = (cmValue * 10).round() % 10 == 0; // integer cm

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
      final int totalInches = index;
      final int feet = _minFeet + (totalInches ~/ 12);
      final int inches = totalInches % 12;

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
            Container(width: 15, height: 2, color: const Color(0xFF000000)),
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
