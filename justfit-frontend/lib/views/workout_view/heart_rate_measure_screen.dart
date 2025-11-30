import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../common_widgets/heart_rate_gauge.dart';
import 'heart_rate_result_screen.dart';
import '../../data/models/workout/workout_exercise.dart';
import '../../data/models/workout/simple_workout_models.dart'; // ✅ ADD THIS

class HeartRateMeasureScreen extends StatefulWidget {
  final int dayNumber;
  final int duration;
  final List<WorkoutExercise> exercises;
  final int calories;
  final String? discoveryWorkoutId; // ✅ NEW
  final String? discoveryWorkoutTitle; // ✅ NEW
  final String? discoveryCategory; // ✅ NEW
  final List<WorkoutSet>? fullWorkoutSets; // ✅ NEW

  const HeartRateMeasureScreen({
    Key? key,
    required this.dayNumber,
    required this.duration,
    required this.calories,
    required this.exercises,
    this.discoveryWorkoutId, // ✅ NEW
    this.discoveryWorkoutTitle, // ✅ NEW
    this.discoveryCategory, // ✅ NEW
    this.fullWorkoutSets, // ✅ NEW
  }) : super(key: key);

  @override
  State<HeartRateMeasureScreen> createState() => _HeartRateMeasureScreenState();
}

class _HeartRateMeasureScreenState extends State<HeartRateMeasureScreen>
    with TickerProviderStateMixin {
  // Measurement states
  bool _showInstructions = true;
  bool _isMeasuring = false;
  bool _fingerDetected = false;
  int _currentHeartRate = 0;
  double _measurementProgress = 0.0;
  
  // Camera
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  
  // Heart rate detection
  final List<double> _redValues = [];
  DateTime? _measurementStartTime;
  final int _measurementDurationSeconds = 15;
  StreamSubscription<CameraImage>? _imageStreamSubscription;
  
  // Finger detection
  double _currentBrightness = 0.0;
  final double _brightnessThreshold = 180.0; // Threshold for finger detection
  Timer? _fingerCheckTimer;
  
  // Animations
  late AnimationController _pulseController;
  late AnimationController _travelController;
  late AnimationController _promptController;
  Timer? _measurementTimer;
  Timer? _heartRateTimer;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation for camera highlight
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    // Traveling line animation (smooth, continuous)
    _travelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    
    // Prompt animation (pulsing)
    _promptController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _travelController.dispose();
    _promptController.dispose();
    _measurementTimer?.cancel();
    _heartRateTimer?.cancel();
    _fingerCheckTimer?.cancel();
    _imageStreamSubscription?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    
    if (status.isGranted) {
      await _initializeCamera();
    } else if (status.isDenied) {
      _showPermissionDeniedDialog();
    } else if (status.isPermanentlyDenied) {
      _showPermissionPermanentlyDeniedDialog();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _showNoCameraDialog();
        return;
      }

      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.low,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await _cameraController!.initialize();
      
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          _showInstructions = false;
        });
        
        await _cameraController!.setFlashMode(FlashMode.torch);
        _startFingerDetection();
      }
    } catch (e) {
      print('Camera initialization error: $e');
      _showCameraErrorDialog();
    }
  }

  void _startFingerDetection() {
    // Start processing camera frames for finger detection
    _cameraController!.startImageStream((CameraImage image) {
      final brightness = _getAverageRedValue(image);
      
      setState(() {
        _currentBrightness = brightness;
      });
      
      // Check if finger is properly placed (high brightness from flashlight reflection)
      if (brightness > _brightnessThreshold) {
        if (!_fingerDetected) {
          setState(() {
            _fingerDetected = true;
          });
          
          // Start measurement after finger is detected for 1 second
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (_fingerDetected && !_isMeasuring && mounted) {
              _startMeasurement();
            }
          });
        }
        
        // Continue collecting data if measuring
        if (_isMeasuring) {
          _redValues.add(brightness);
        }
      } else {
        // Finger removed
        if (_fingerDetected || _isMeasuring) {
          setState(() {
            _fingerDetected = false;
          });
          
          // Pause measurement if it was ongoing
          if (_isMeasuring) {
            _pauseMeasurement();
          }
        }
      }
    });
  }

  void _startMeasurement() {
    if (_isMeasuring) return;
    
    setState(() {
      _isMeasuring = true;
      _measurementStartTime = DateTime.now();
    });
    
    _redValues.clear();
    
    // Update progress and heart rate periodically
    _measurementTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted || !_isMeasuring) {
        timer.cancel();
        return;
      }
      
      final elapsed = DateTime.now().difference(_measurementStartTime!).inMilliseconds;
      final progress = (elapsed / (_measurementDurationSeconds * 1000)).clamp(0.0, 1.0);
      
      setState(() {
        _measurementProgress = progress;
        
        // Calculate heart rate from collected data
        if (_redValues.length >= 50) {
          final calculatedHR = _calculateHeartRate();
          if (calculatedHR > 0) {
            _currentHeartRate = calculatedHR;
          }
        }
      });
      
      if (progress >= 1.0) {
        timer.cancel();
        _completeMeasurement();
      }
    });
  }

  void _pauseMeasurement() {
    setState(() {
      _isMeasuring = false;
    });
    _measurementTimer?.cancel();
    _redValues.clear();
    _currentHeartRate = 0;
    _measurementProgress = 0.0;
  }

  double _getAverageRedValue(CameraImage image) {
    try {
      // For YUV420 format, we'll use the Y plane and approximate red channel
      final plane = image.planes[0];
      
      if (plane.bytes.isEmpty) return 0.0;
      
      // Sample from center region of the image (where finger should be)
      final width = image.width;
      final height = image.height;
      final centerX = width ~/ 2;
      final centerY = height ~/ 2;
      final sampleSize = math.min(width ~/ 4, height ~/ 4);
      
      double sum = 0;
      int count = 0;
      
      for (int y = centerY - sampleSize; y < centerY + sampleSize; y += 4) {
        for (int x = centerX - sampleSize; x < centerX + sampleSize; x += 4) {
          if (y >= 0 && y < height && x >= 0 && x < width) {
            final index = y * plane.bytesPerRow + x;
            if (index < plane.bytes.length) {
              sum += plane.bytes[index];
              count++;
            }
          }
        }
      }
      
      return count > 0 ? sum / count : 0.0;
    } catch (e) {
      print('Error processing image: $e');
      return 0.0;
    }
  }

  int _calculateHeartRate() {
    if (_redValues.length < 50) return 0;
    
    try {
      // Smooth the signal using a simple moving average
      final smoothedValues = _smoothSignal(_redValues);
      
      // Find peaks in the signal
      final peaks = _findPeaks(smoothedValues);
      
      if (peaks.length < 2) return 0;
      
      // Calculate average time between peaks
      final intervals = <double>[];
      for (int i = 1; i < peaks.length; i++) {
        intervals.add(peaks[i] - peaks[i - 1]);
      }
      
      if (intervals.isEmpty) return 0;
      
      // Calculate average interval
      final avgInterval = intervals.reduce((a, b) => a + b) / intervals.length;
      
      // Convert to BPM (assuming we sample at ~30 FPS)
      final fps = 30.0;
      final bpm = (60.0 * fps / avgInterval).round();
      
      // Validate BPM is in realistic range
      if (bpm >= 45 && bpm <= 200) {
        return bpm;
      }
      
      return 0;
    } catch (e) {
      print('Error calculating heart rate: $e');
      return 0;
    }
  }

  List<double> _smoothSignal(List<double> signal) {
    const windowSize = 5;
    final smoothed = <double>[];
    
    for (int i = 0; i < signal.length; i++) {
      double sum = 0;
      int count = 0;
      
      for (int j = math.max(0, i - windowSize); 
           j <= math.min(signal.length - 1, i + windowSize); 
           j++) {
        sum += signal[j];
        count++;
      }
      
      smoothed.add(sum / count);
    }
    
    return smoothed;
  }

  List<double> _findPeaks(List<double> signal) {
    final peaks = <double>[];
    
    // Calculate threshold for peak detection
    final mean = signal.reduce((a, b) => a + b) / signal.length;
    final variance = signal.map((v) => math.pow(v - mean, 2)).reduce((a, b) => a + b) / signal.length;
    final stdDev = math.sqrt(variance);
    final threshold = mean + (0.5 * stdDev);
    
    // Find peaks
    for (int i = 1; i < signal.length - 1; i++) {
      if (signal[i] > threshold &&
          signal[i] > signal[i - 1] &&
          signal[i] > signal[i + 1]) {
        // Avoid detecting peaks too close together (minimum 0.3s apart)
        if (peaks.isEmpty || (i - peaks.last) > 9) {
          peaks.add(i.toDouble());
        }
      }
    }
    
    return peaks;
  }

  Future<void> _completeMeasurement() async {
    setState(() {
      _isMeasuring = false;
    });
    
    await _imageStreamSubscription?.cancel();
    await _cameraController?.setFlashMode(FlashMode.off);
    await _cameraController?.dispose();
    
    if (!mounted) return;
    
    // Use calculated heart rate or a default if detection failed
    final finalHeartRate = _currentHeartRate > 0 ? _currentHeartRate : 75;
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HeartRateResultScreen(
        heartRate: finalHeartRate,
        dayNumber: widget.dayNumber,
        duration: widget.duration,
        calories: widget.calories,
        exercises: widget.exercises, // ✅ ADD THIS
        discoveryWorkoutId: widget.discoveryWorkoutId, // ✅ ADD
        discoveryWorkoutTitle: widget.discoveryWorkoutTitle, // ✅ ADD
        discoveryCategory: widget.discoveryCategory, // ✅ ADD
        fullWorkoutSets: widget.fullWorkoutSets, // ✅ ADD
      ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            _isMeasuring = false;
            _imageStreamSubscription?.cancel();
            _cameraController?.dispose();
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Heart Rate',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _showInstructions
            ? _buildInstructionView()
            : _buildMeasurementView(),
      ),
    );
  }

  Widget _buildInstructionView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  
                  // Minimalist phone corner with finger and camera
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      // Responsive height: 35% of screen, min 220px, max 320px
                      final illustrationHeight = (constraints.maxHeight * 0.35).clamp(220.0, 320.0);
                      
                      return SizedBox(
                        height: illustrationHeight,
                        child: CustomPaint(
                          size: Size(340, illustrationHeight),
                          painter: _MinimalistPhoneCornerPainter(
                            pulseProgress: Curves.easeInOut.transform(_pulseController.value),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // "How to measure?" heading
                  Text(
                    'How to measure?',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFE91E63),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Instructions
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      'Put finger to cover the back camera and the flashlight. Hold it until the end.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        height: 1.6,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Start button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _requestCameraPermission,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE91E63),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Text(
                          'TAP TO CONTINUE',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildMeasurementView() {
    return Stack(
      children: [
        // Main content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(),
              
              // Heart rate gauge with live updates
              HeartRateGauge(
                heartRate: _currentHeartRate,
                size: 200,
              ),
              
              const SizedBox(height: 32),
              
              // Instruction text - changes based on state
              Text(
                _getInstructionText(),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: _fingerDetected && _isMeasuring 
                      ? Colors.grey[700] 
                      : const Color(0xFFE91E63),
                  height: 1.5,
                ),
              ),
              
              const Spacer(),
              
              // Traveling pulse animation (centered, limited width)
              Center(
                child: AnimatedBuilder(
                  animation: _travelController,
                  builder: (context, child) {
                    return SizedBox(
                      width: 300,
                      height: 120,
                      child: CustomPaint(
                        size: const Size(300, 120),
                        painter: _TravelingPulsePainter(
                          progress: _travelController.value,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
        
        // Finger placement prompt overlay
        if (!_fingerDetected || !_isMeasuring)
          _buildFingerPromptOverlay(),
      ],
    );
  }

  String _getInstructionText() {
    if (_isMeasuring && _fingerDetected) {
      return 'Measuring heart rate...\nPlease hold still';
    } else {
      return 'Place your finger on the camera';
    }
  }

  Widget _buildFingerPromptOverlay() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _promptController,
        builder: (context, child) {
          final scale = 1.0 + (_promptController.value * 0.05);
          final opacity = 0.9 + (_promptController.value * 0.1);
          
          return Transform.scale(
            scale: scale,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE91E63).withOpacity(opacity),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE91E63).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Please place your finger on the back camera and flashlight',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Camera Permission Required',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Please allow camera access to measure your heart rate.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _requestCameraPermission();
            },
            child: Text(
              'RETRY',
              style: GoogleFonts.poppins(
                color: const Color(0xFFE91E63),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPermissionPermanentlyDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Camera Permission Required',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Camera permission is permanently denied. Please enable it in settings.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: Text(
              'OPEN SETTINGS',
              style: GoogleFonts.poppins(
                color: const Color(0xFFE91E63),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNoCameraDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'No Camera Found',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Your device doesn\'t have a camera.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              'OK',
              style: GoogleFonts.poppins(
                color: const Color(0xFFE91E63),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCameraErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Camera Error',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Failed to initialize camera. Please try again.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              'OK',
              style: GoogleFonts.poppins(
                color: const Color(0xFFE91E63),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Minimalist phone corner illustration
class _MinimalistPhoneCornerPainter extends CustomPainter {
  final double pulseProgress;

  _MinimalistPhoneCornerPainter({required this.pulseProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE91E63)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // === FINGER (simplified, clean lines) ===
    final fingerX = centerX - 100;
    final fingerY = centerY - 80;
    
    paint.strokeWidth = 3.0;
    
    // Fingertip (rounded oval)
    final fingerTipPath = Path();
    fingerTipPath.addOval(
      Rect.fromCenter(
        center: Offset(fingerX, fingerY),
        width: 50,
        height: 68,
      ),
    );
    canvas.drawPath(fingerTipPath, paint);
    
    // Fingernail (simple arc)
    paint.strokeWidth = 2.0;
    final nailPath = Path();
    nailPath.addArc(
      Rect.fromCenter(
        center: Offset(fingerX, fingerY - 26),
        width: 30,
        height: 18,
      ),
      -math.pi,
      math.pi,
    );
    canvas.drawPath(nailPath, paint);
    
    // Finger body (clean lines extending down)
    paint.strokeWidth = 3.0;
    canvas.drawLine(
      Offset(fingerX - 23, fingerY + 22),
      Offset(fingerX - 40, fingerY + 100),
      paint,
    );
    canvas.drawLine(
      Offset(fingerX + 23, fingerY + 22),
      Offset(fingerX + 10, fingerY + 100),
      paint,
    );

    // === MOTION LINES (subtle speed effect) ===
    paint.strokeWidth = 2.0;
    paint.color = const Color(0xFFE91E63).withOpacity(0.25);
    
    for (int i = 0; i < 3; i++) {
      final lineY = fingerY + (i * 8);
      final lineX = fingerX - 70 - (i * 12);
      final lineLength = 22 - (i * 5);
      
      canvas.drawLine(
        Offset(lineX, lineY),
        Offset(lineX + lineLength, lineY),
        paint,
      );
    }

    // === PHONE CORNER (only top-left visible) ===
    paint.color = const Color(0xFFE91E63);
    paint.strokeWidth = 3.0;
    
    final phoneCornerPath = Path();
    phoneCornerPath.moveTo(centerX - 80, centerY + 120);
    phoneCornerPath.lineTo(centerX - 80, centerY - 20);
    phoneCornerPath.arcToPoint(
      Offset(centerX - 60, centerY - 40),
      radius: const Radius.circular(20),
      clockwise: false,
    );
    phoneCornerPath.lineTo(centerX + 120, centerY - 40);
    
    canvas.drawPath(phoneCornerPath, paint);

    // === CAMERA MODULE ===
    final cameraModuleX = centerX - 60;
    final cameraModuleY = centerY - 20;
    
    paint.strokeWidth = 2.5;
    final cameraModule = RRect.fromRectAndRadius(
      Rect.fromLTWH(cameraModuleX + 8, cameraModuleY + 8, 50, 42),
      const Radius.circular(12),
    );
    canvas.drawRRect(cameraModule, paint);

    // === MAIN CAMERA LENS ===
    final mainCameraX = cameraModuleX + 22;
    final mainCameraY = cameraModuleY + 24;
    
    // Pulsing glow
    for (int i = 3; i > 0; i--) {
      final glowRadius = 12 + (pulseProgress * 20 * i / 3);
      final glowOpacity = (1.0 - pulseProgress) * 0.15 * (4 - i) / 3;
      
      final glowPaint = Paint()
        ..color = const Color(0xFFE91E63).withOpacity(glowOpacity)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      
      canvas.drawCircle(Offset(mainCameraX, mainCameraY), glowRadius, glowPaint);
    }
    
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2.5;
    canvas.drawCircle(Offset(mainCameraX, mainCameraY), 10, paint);
    
    paint.strokeWidth = 1.5;
    canvas.drawCircle(Offset(mainCameraX, mainCameraY), 7, paint);
    
    final reflectionPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(mainCameraX - 2.5, mainCameraY - 2.5), 2.5, reflectionPaint);

    // === FLASH LED ===
    final flashX = cameraModuleX + 44;
    final flashY = cameraModuleY + 24;
    
    final flashGlowPaint = Paint()
      ..color = const Color(0xFFE91E63).withOpacity((1.0 - pulseProgress) * 0.12)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(Offset(flashX, flashY), 8 + (pulseProgress * 8), flashGlowPaint);
    
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2.2;
    canvas.drawCircle(Offset(flashX, flashY), 5.5, paint);
    
    paint.strokeWidth = 1.2;
    canvas.drawCircle(Offset(flashX, flashY), 3.5, paint);

    // === SIDE BUTTON ===
    paint.strokeWidth = 2.5;
    canvas.drawLine(
      Offset(centerX - 80, centerY + 30),
      Offset(centerX - 80, centerY + 55),
      paint,
    );
  }

  @override
  bool shouldRepaint(_MinimalistPhoneCornerPainter oldDelegate) =>
      oldDelegate.pulseProgress != pulseProgress;
}

class _TravelingPulsePainter extends CustomPainter {
  final double progress;

  _TravelingPulsePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final centerY = height / 2;

    // Create the ECG/pulse path
    final pulsePath = _createPulsePath(width, centerY);
    
    // Draw the transparent path outline (almost invisible)
    final pathPaint = Paint()
      ..color = Colors.grey.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    
    canvas.drawPath(pulsePath, pathPaint);

    // Calculate the traveling segment
    final pathMetrics = pulsePath.computeMetrics().first;
    final totalLength = pathMetrics.length;
    
    // Animation logic:
    // Phase 1 (0.0 - 0.5): Line enters from right and grows to full length
    // Phase 2 (0.5 - 1.0): Full line slides from right to left
    
    double startPos, endPos;
    
    if (progress < 0.5) {
      // Phase 1: Growing from right
      final growProgress = progress * 2; // 0.0 to 1.0
      startPos = totalLength * (1.0 - growProgress);
      endPos = totalLength;
    } else {
      // Phase 2: Sliding left
      final slideProgress = (progress - 0.5) * 2; // 0.0 to 1.0
      startPos = 0;
      endPos = totalLength * (1.0 - slideProgress);
    }
    
    // Draw the red line with fade effect
    if (startPos < endPos) {
      const steps = 25;
      final segmentLength = endPos - startPos;
      final stepLength = segmentLength / steps;
      
      for (int i = 0; i < steps; i++) {
        final segStart = startPos + (i * stepLength);
        final segEnd = startPos + ((i + 1) * stepLength);
        
        if (segEnd <= endPos && segEnd <= totalLength) {
          final segment = pathMetrics.extractPath(segStart, segEnd);
          
          // Calculate opacity for fade at both ends
          final normalizedPos = i / (steps - 1);
          double opacity;
          
          // Fade distance from each end (20% fade on each side)
          if (normalizedPos < 0.2) {
            // Fade in at left end
            opacity = normalizedPos / 0.2;
          } else if (normalizedPos > 0.8) {
            // Fade out at right end
            opacity = (1.0 - normalizedPos) / 0.2;
          } else {
            // Full opacity in middle
            opacity = 1.0;
          }
          
          final segmentPaint = Paint()
            ..color = const Color(0xFFE91E63).withOpacity(opacity)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3.5
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round;
          
          canvas.drawPath(segment, segmentPaint);
        }
      }
    }
  }

  Path _createPulsePath(double width, double centerY) {
    final path = Path();
    
    // Start position
    path.moveTo(0, centerY);
    
    // Create realistic ECG-like pulse pattern
    final beatWidth = width / 2.5;
    
    for (int beat = 0; beat < 3; beat++) {
      final baseX = beat * beatWidth;
      
      // Flat line before P wave
      path.lineTo(baseX + beatWidth * 0.12, centerY);
      
      // P wave (small bump)
      path.quadraticBezierTo(
        baseX + beatWidth * 0.15, centerY - 18,
        baseX + beatWidth * 0.18, centerY,
      );
      
      // Flat before QRS
      path.lineTo(baseX + beatWidth * 0.24, centerY);
      
      // Q dip
      path.lineTo(baseX + beatWidth * 0.26, centerY + 20);
      
      // R peak (sharp spike)
      path.lineTo(baseX + beatWidth * 0.29, centerY - 70);
      
      // S dip
      path.lineTo(baseX + beatWidth * 0.32, centerY + 25);
      
      // Back to baseline
      path.lineTo(baseX + beatWidth * 0.34, centerY);
      
      // ST segment (slight curve)
      path.quadraticBezierTo(
        baseX + beatWidth * 0.40, centerY + 5,
        baseX + beatWidth * 0.46, centerY,
      );
      
      // T wave (rounded bump)
      path.quadraticBezierTo(
        baseX + beatWidth * 0.54, centerY - 22,
        baseX + beatWidth * 0.62, centerY,
      );
      
      // Flat until next beat
      if (beat < 2) {
        path.lineTo(baseX + beatWidth, centerY);
      }
    }
    
    path.lineTo(width, centerY);
    
    return path;
  }

  @override
  bool shouldRepaint(_TravelingPulsePainter oldDelegate) =>
      oldDelegate.progress != progress;
}