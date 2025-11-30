import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../controllers/workout_plan_controller.dart';
import '../../../data/models/achievement_model.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import '../../../core/services/firestore_service.dart';
import '../../../core/services/user_service.dart';
import '../widgets/settings_drawer.dart';
import '../widgets/profile_edit_screen.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final WorkoutPlanController _controller = Get.find<WorkoutPlanController>();
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final UserService _userService = Get.find<UserService>();

  // Weight tracking
  double currentWeight = 0.0;
  double? goalWeight;
  List<WeightEntry> weightHistory = [];
  DateTime _selectedWeightMonth = DateTime.now();

  // Duration tracking (independent)
  DateTime _selectedDurationWeekStart =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  Map<int, int> weeklyDurations = {};

  // Calories tracking (independent)
  DateTime _selectedCaloriesWeekStart =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  Map<int, int> weeklyCalories = {};

  // Monthly workout days
  Set<int> completedDays = {};
  DateTime _selectedCalendarMonth = DateTime.now();
  // Profile stats
  int totalWorkoutsCompleted = 0;
  int totalMinutesExercised = 0;
  int totalCaloriesBurned = 0;
  double? initialWeight; // ✅ ADD THIS

  @override
  void initState() {
    super.initState();
    _loadProgressData();
  }

  Future<void> _loadProgressData() async {
    final user = _userService.currentUser.value;
    if (user == null) return;

    await _loadProfileStats(); // ✅ ADD THIS LINE

    // Load weight history
    await _loadWeightHistory();

    // Load weekly stats
    await _loadWeeklyDurations();
    await _loadWeeklyCalories();

    // Load monthly workout days
    await _loadMonthlyWorkoutDays();
  }

  Future<void> _loadWeightHistory() async {
    final user = _userService.currentUser.value;
    if (user == null) return;

    print(
        '⚖️ Loading weight for ${_selectedWeightMonth.year}-${_selectedWeightMonth.month}');

    try {
      // 1. Load initial weight (one time only)
      if (initialWeight == null) {
        initialWeight = await _firestoreService.getUserCurrentWeight(user.uid);
        if (initialWeight != null) {
          currentWeight = initialWeight!;
          print('⚖️ Initial weight: $initialWeight kg');
        }
      }

      // 2. Load goal weight (one time only)
      if (goalWeight == null) {
        goalWeight = await _firestoreService.getWeightGoal(user.uid);
        print('⚖️ Goal weight: $goalWeight kg');
      }

      // 3. Load weight entries for THIS month only
      final monthEntries = await _firestoreService.getWeightHistory(
        userId: user.uid,
        year: _selectedWeightMonth.year,
        month: _selectedWeightMonth.month,
      );

      print('⚖️ Found ${monthEntries.length} logged entries for this month');

      setState(() {
        weightHistory = monthEntries
            .map((data) => WeightEntry(
                  date: data['date'] as DateTime,
                  weight: (data['weight'] as num).toDouble(),
                ))
            .toList();

        // Sort by date
        weightHistory.sort((a, b) => a.date.compareTo(b.date));

        // ✅ NEW: If no entries exist but we have initial weight, create a virtual entry
        if (weightHistory.isEmpty && initialWeight != null) {
          // Check if user signed up in this month
          final userDoc = _userService.currentUser.value;
          if (userDoc != null) {
            // Use current month as signup month for display
            final signupDate = DateTime
                .now(); // You can get actual signup date from user.createdAt

            // Only show initial weight in current month or signup month
            if (_selectedWeightMonth.year == DateTime.now().year &&
                _selectedWeightMonth.month == DateTime.now().month) {
              weightHistory = [
                WeightEntry(
                  date: signupDate,
                  weight: initialWeight!,
                ),
              ];
              print('⚖️ Showing initial weight on graph: $initialWeight kg');
            }
          }
        }

        // Update current weight to latest entry
        if (weightHistory.isNotEmpty) {
          currentWeight = weightHistory.last.weight;
          print('⚖️ Current weight updated: $currentWeight kg');
        } else if (initialWeight != null) {
          currentWeight = initialWeight!;
          print('⚖️ Current weight (initial): $currentWeight kg');
        }
      });
    } catch (e) {
      print('❌ Error loading weight: $e');
    }
  }

  Future<void> _loadWeeklyDurations() async {
    final user = _userService.currentUser.value;
    if (user == null) return;

    print(
        '⏱️ Loading weekly durations for week starting: $_selectedDurationWeekStart');

    try {
      final durations = await _firestoreService.getWeeklyDuration(
        userId: user.uid,
        weekStart: _selectedDurationWeekStart,
      );

      setState(() {
        weeklyDurations =
            durations; // ✅ Data is already in minutes from Firestore
      });
    } catch (e) {
      print('❌ Error loading weekly durations: $e');
    }
  }

  Future<void> _loadWeeklyCalories() async {
    final user = _userService.currentUser.value;
    if (user == null) return;

    print(
        '🔥 Loading weekly calories for week starting: $_selectedCaloriesWeekStart');

    try {
      final calories = await _firestoreService.getWeeklyCalories(
        userId: user.uid,
        weekStart: _selectedCaloriesWeekStart,
      );

      setState(() {
        weeklyCalories = calories; // ✅ Pure Firestore data, no static fallback
      });
    } catch (e) {
      print('❌ Error loading weekly calories: $e');
    }
  }

  Future<void> _loadMonthlyWorkoutDays() async {
    final user = _userService.currentUser.value;
    if (user == null) {
      print('❌ Cannot load monthly workout days - no user logged in');
      return;
    }

    print('🔄 Loading monthly workout days for calendar...');
    print(
        '   Selected month: ${_selectedCalendarMonth.year}-${_selectedCalendarMonth.month}');

    try {
      final days = await _firestoreService.getMonthlyWorkoutDays(
        userId: user.uid,
        year: _selectedCalendarMonth.year,
        month: _selectedCalendarMonth.month,
      );

      print('✅ Received ${days.length} workout days for UI: $days');

      setState(() {
        completedDays = days;
      });

      print('✅ UI updated with completed days');
    } catch (e) {
      print('❌ Error loading monthly workout days: $e');
    }
  }

  Future<void> _loadProfileStats() async {
    final user = _userService.currentUser.value;
    if (user == null) {
      print('❌ No user logged in for profile stats');
      return;
    }

    print('📊 Loading profile stats for user: ${user.uid}');

    try {
      final stats = await _firestoreService.getUserProgressStats(user.uid);
      print('📊 Fetched stats from Firestore: $stats');

      if (stats != null) {
        setState(() {
          totalWorkoutsCompleted = stats['totalWorkoutsCompleted'] ?? 0;
          totalMinutesExercised = stats['totalMinutesExercised'] ?? 0;
          totalCaloriesBurned = stats['totalCaloriesBurned'] ?? 0;
        });
        print(
            '✅ Profile stats loaded: $totalWorkoutsCompleted workouts, $totalMinutesExercised min, $totalCaloriesBurned cal');
      } else {
        print('⚠️ No stats document found in Firestore');
      }
    } catch (e) {
      print('❌ Error loading profile stats: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),

            // Profile Section
            SliverToBoxAdapter(
              child: _buildProfileSection(),
            ),

            // Achievement Section
            SliverToBoxAdapter(
              child: _buildAchievementSection(),
            ),

            // Weight Section
            SliverToBoxAdapter(
              child: _buildWeightSection(),
            ),

            // Monthly Achievement Calendar
            SliverToBoxAdapter(
              child: _buildMonthlyAchievementSection(),
            ),

            // Workout Duration Section
            SliverToBoxAdapter(
              child: _buildWorkoutDurationSection(),
            ),

            // Calories Burned Section
            SliverToBoxAdapter(
              child: _buildCaloriesBurnedSection(),
            ),

            // Bottom padding
            SliverToBoxAdapter(
              child: const SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }

  // ========== HEADER ==========
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          Text(
            'Progress',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          // Feedback button
          TextButton.icon(
            onPressed: () {
              Get.snackbar(
                'Feedback',
                'We value your feedback!',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            icon: const Icon(Icons.headset_mic,
                color: Color(0xFFE91E63), size: 20),
            label: Text(
              'Feedback',
              style: GoogleFonts.poppins(
                color: const Color(0xFFE91E63),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
          ),
          const SizedBox(width: 8),
          // Settings icon
          GestureDetector(
            onTap: () {
              Get.to(
                () => SettingsScreen(),
                transition: Transition.rightToLeft,
                duration: Duration(milliseconds: 300),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.settings_outlined,
                color: Colors.black54,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== PROFILE SECTION ==========
  Widget _buildProfileSection() {
    final user = _userService.currentUser.value;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile avatar with edit button
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: user?.photoUrl != null && user!.photoUrl!.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          user.photoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildDefaultAvatar(user);
                          },
                        ),
                      )
                    : _buildDefaultAvatar(user),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
                    // Navigate to profile edit
                    Get.to(() => ProfileEditScreen());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE31E52),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // User info and stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.displayName ?? 'User',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSmallStat(
                        '$totalWorkoutsCompleted', 'Workouts'), // ✅ DYNAMIC
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.grey[300],
                    ),
                    _buildSmallStat(
                        '$totalCaloriesBurned', 'Kcal'), // ✅ DYNAMIC
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.grey[300],
                    ),
                    _buildSmallStat(
                        '$totalMinutesExercised', 'Minutes'), // ✅ DYNAMIC
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(dynamic user) {
    return Center(
      child: Text(
        (user?.displayName ?? 'U')[0].toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildSmallStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // ========== ACHIEVEMENT SECTION ==========
  Widget _buildAchievementSection() {
    final userId = _userService.currentUser.value?.uid;

    if (userId == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header without "All" button
          Text(
            'Achievement',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          // Horizontal scrollable achievement badges
          SizedBox(
            height: 170,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _firestoreService.getAchievements(userId: userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'Complete workouts to earn achievements!',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                  );
                }

                final achievements = snapshot.data!;

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(right: 20),
                  itemCount: achievements.length,
                  itemBuilder: (context, index) {
                    final data = achievements[index];
                    final achievementType = AchievementType.values.firstWhere(
                      (e) => e.toString() == data['achievementType'],
                      orElse: () => AchievementType.firstWorkout,
                    );

                    // Get the correct badge style based on achievement type
                    final achievement =
                        _getAchievementByType(achievementType, data);

                    return _buildAchievementBadge(
                      achievement,
                      isLast: index == achievements.length - 1,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge(AchievementModel achievement,
      {bool isLast = false}) {
    return Container(
      width: 120, // ✅ Reduced width to fit more badges
      margin: EdgeInsets.only(
          right: isLast ? 0 : 12), // ✅ Less spacing, no margin on last
      child: Column(
        mainAxisSize: MainAxisSize.min, // ✅ Prevent overflow
        children: [
          // Badge with gradient background
          Container(
            width: 90, // ✅ Reduced size
            height: 90, // ✅ Reduced size
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  achievement.badgeStyle.primaryColor,
                  achievement.badgeStyle.accentColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: achievement.badgeStyle.primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Stripes pattern
                CustomPaint(
                  painter: _StripePainter(),
                  size: const Size(100, 100),
                ),
                // Badge number
                Center(
                  child: Text(
                    achievement.badgeNumber.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 36, // ✅ Slightly smaller
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8), // ✅ Reduced spacing
          Flexible(
            // ✅ Added Flexible to prevent overflow
            child: Text(
              achievement.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 13, // ✅ Slightly smaller
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          // Date
          Text(
            DateFormat('MM.dd.yyyy').format(DateTime.now()),
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get achievement with proper badge style
  AchievementModel _getAchievementByType(
      AchievementType type, Map<String, dynamic> data) {
    // Get the predefined achievement which has the correct badge style
    AchievementModel baseAchievement;

    switch (type) {
      case AchievementType.firstWorkout:
        baseAchievement = AchievementModel.firstWorkout;
        break;
      case AchievementType.twoWorkouts:
        baseAchievement = AchievementModel.twoWorkouts;
        break;
      case AchievementType.threeWorkouts:
        baseAchievement = AchievementModel.threeWorkouts;
        break;
      case AchievementType.fiveWorkouts:
        baseAchievement = AchievementModel.fiveWorkouts;
        break;
      case AchievementType.tenWorkouts:
        baseAchievement = AchievementModel.tenWorkouts;
        break;
      case AchievementType.twoDayStreak:
        baseAchievement = AchievementModel.twoDayStreak;
        break;
      case AchievementType.threeDayStreak:
        baseAchievement = AchievementModel.threeDayStreak;
        break;
      case AchievementType.fiveDayStreak:
        baseAchievement = AchievementModel.fiveDayStreak;
        break;
      case AchievementType.sevenDayStreak:
        baseAchievement = AchievementModel.sevenDayStreak;
        break;
      case AchievementType.tenDayStreak:
        baseAchievement = AchievementModel.tenDayStreak;
        break;
      case AchievementType.thirtyDayStreak:
        baseAchievement = AchievementModel.thirtyDayStreak;
        break;
    }

    // Return achievement with correct badge style
    return baseAchievement;
  }

  // ========== WEIGHT SECTION ==========
  Widget _buildWeightSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weight',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          // Month selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _canGoPreviousMonth() ? _goToPreviousMonth : null,
                icon: const Icon(Icons.chevron_left),
                color:
                    _canGoPreviousMonth() ? Colors.grey[700] : Colors.grey[300],
              ),
              Text(
                DateFormat('MMM, yyyy').format(_selectedWeightMonth),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: _canGoNextMonth() ? _goToNextMonth : null,
                icon: const Icon(Icons.chevron_right),
                color: _canGoNextMonth() ? Colors.grey[700] : Colors.grey[300],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Current weight and button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${currentWeight.toStringAsFixed(1)} kg',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _showLogWeightDialog();
                },
                icon: const Icon(Icons.edit, size: 18),
                label: Text(
                  'Log weight',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  elevation: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Weight graph - compact and clean
          Container(
            height: 150,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: CustomPaint(
              painter: _WeightGraphPainter(
                weightHistory,
                goalWeight: goalWeight,
                selectedMonth: _selectedWeightMonth,
                initialWeight: initialWeight, // ✅ ADD THIS LINE
              ),
              child: Container(),
            ),
          ),

          const SizedBox(height: 8),

          // Goal indicator
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'Goal',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Month navigation helpers
  bool _canGoPreviousMonth() {
    final firstDate = DateTime(2023, 1);
    return _selectedWeightMonth.isAfter(firstDate);
  }

  bool _canGoNextMonth() {
    final now = DateTime.now();
    return _selectedWeightMonth.year < now.year ||
        (_selectedWeightMonth.year == now.year &&
            _selectedWeightMonth.month < now.month);
  }

  void _goToPreviousMonth() {
    setState(() {
      _selectedWeightMonth = DateTime(
        _selectedWeightMonth.year,
        _selectedWeightMonth.month - 1,
      );
    });

    // ✅ Show loading state with animation
    _loadWeightHistory();
  }

  void _goToNextMonth() {
    setState(() {
      _selectedWeightMonth = DateTime(
        _selectedWeightMonth.year,
        _selectedWeightMonth.month + 1,
      );
    });

    // ✅ Show loading state with animation
    _loadWeightHistory();
  }

  // ========== MONTHLY ACHIEVEMENT SECTION ==========
  Widget _buildMonthlyAchievementSection() {
    final firstDayOfMonth =
        DateTime(_selectedCalendarMonth.year, _selectedCalendarMonth.month, 1);
    final lastDayOfMonth = DateTime(
        _selectedCalendarMonth.year, _selectedCalendarMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday % 7; // 0 = Sunday

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Achievement',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          // Month selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _canGoPreviousCalendarMonth()
                    ? _goToPreviousCalendarMonth
                    : null,
                icon: const Icon(Icons.chevron_left),
                color: _canGoPreviousCalendarMonth()
                    ? Colors.grey[700]
                    : Colors.grey[300],
              ),
              Text(
                DateFormat('MMM, yyyy').format(_selectedCalendarMonth),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed:
                    _canGoNextCalendarMonth() ? _goToNextCalendarMonth : null,
                icon: const Icon(Icons.chevron_right),
                color: _canGoNextCalendarMonth()
                    ? Colors.grey[700]
                    : Colors.grey[300],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Calendar
          Column(
            children: [
              // Weekday headers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                    .map((day) => SizedBox(
                          width: 40,
                          child: Text(
                            day,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 12),

              // Calendar days (up to 6 weeks)
              ...List.generate(6, (weekIndex) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(7, (dayIndex) {
                      final dayNumber =
                          weekIndex * 7 + dayIndex - firstWeekday + 1;

                      if (dayNumber < 1 || dayNumber > daysInMonth) {
                        return const SizedBox(width: 40, height: 40);
                      }

                      final isCompleted = completedDays.contains(dayNumber);

                      return _buildCalendarDay(dayNumber, isCompleted);
                    }),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarDay(int day, bool isCompleted) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isCompleted ? const Color(0xFFE91E63) : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$day',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: isCompleted ? FontWeight.w600 : FontWeight.w400,
            color: isCompleted ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // Calendar month navigation helpers
  bool _canGoPreviousCalendarMonth() {
    // Can go back to user registration or Jan 2023
    final firstDate = DateTime(2023, 1);
    return _selectedCalendarMonth.isAfter(firstDate);
  }

  bool _canGoNextCalendarMonth() {
    final now = DateTime.now();
    // Cannot go beyond current month
    return _selectedCalendarMonth.year < now.year ||
        (_selectedCalendarMonth.year == now.year &&
            _selectedCalendarMonth.month < now.month);
  }

  void _goToPreviousCalendarMonth() {
    setState(() {
      _selectedCalendarMonth = DateTime(
        _selectedCalendarMonth.year,
        _selectedCalendarMonth.month - 1,
      );
    });

    // ✅ Smooth transition
    _loadMonthlyWorkoutDays();
  }

  void _goToNextCalendarMonth() {
    setState(() {
      _selectedCalendarMonth = DateTime(
        _selectedCalendarMonth.year,
        _selectedCalendarMonth.month + 1,
      );
    });
    _loadMonthlyWorkoutDays();
  }

  // ========== WORKOUT DURATION SECTION ==========
  Widget _buildWorkoutDurationSection() {
    return _buildBarGraphSection(
      title: 'Workout Duration',
      data: weeklyDurations,
      unit: 'min',
      color: const Color(0xFFE91E63),
      average: _calculateAverage(weeklyDurations),
      weekStart: _selectedDurationWeekStart,
      onPrevious: () {
        setState(() {
          _selectedDurationWeekStart =
              _selectedDurationWeekStart.subtract(const Duration(days: 7));
        });
        _loadWeeklyDurations();
      },
      onNext: () {
        setState(() {
          _selectedDurationWeekStart =
              _selectedDurationWeekStart.add(const Duration(days: 7));
        });
        _loadWeeklyDurations();
      },
      canGoNext: _canGoNextWeek(_selectedDurationWeekStart),
    );
  }

  // ========== CALORIES BURNED SECTION ==========
  Widget _buildCaloriesBurnedSection() {
    return _buildBarGraphSection(
      title: 'Calories Burned',
      data: weeklyCalories,
      unit: 'kCal',
      color: const Color(0xFFE91E63),
      average: _calculateAverage(weeklyCalories),
      weekStart: _selectedCaloriesWeekStart,
      onPrevious: () {
        setState(() {
          _selectedCaloriesWeekStart =
              _selectedCaloriesWeekStart.subtract(const Duration(days: 7));
        });
        _loadWeeklyCalories();
      },
      onNext: () {
        setState(() {
          _selectedCaloriesWeekStart =
              _selectedCaloriesWeekStart.add(const Duration(days: 7));
        });
        _loadWeeklyCalories();
      },
      canGoNext: _canGoNextWeek(_selectedCaloriesWeekStart),
    );
  }

  Widget _buildBarGraphSection({
    required String title,
    required Map<int, int> data,
    required String unit,
    required Color color,
    required double average,
    required DateTime weekStart,
    required VoidCallback onPrevious,
    required VoidCallback onNext,
    required bool canGoNext,
  }) {
    final weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    // ✅ Set realistic minimum scale based on metric type
    final dataMax =
        data.values.isEmpty ? 0 : data.values.reduce((a, b) => a > b ? a : b);
    final minScale =
        unit == 'min' ? 30 : 200; // 30 min or 200 kcal minimum Y-axis
    final maxValue = dataMax > minScale ? dataMax : minScale;
    final weekEnd = weekStart.add(const Duration(days: 6));

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 22, // ✅ Slightly bigger title
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          // Date range selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onPrevious,
                icon: const Icon(Icons.chevron_left),
                color: Colors.grey[700],
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Text(
                '${DateFormat('MMM d, yyyy').format(weekStart)} - ${DateFormat('MMM d, yyyy').format(weekEnd)}',
                style: GoogleFonts.poppins(
                  fontSize: 14, // ✅ Slightly bigger date range
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: canGoNext ? onNext : null,
                icon: const Icon(Icons.chevron_right),
                color: canGoNext ? Colors.grey[700] : Colors.grey[300],
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Bar graph with Y-axis labels
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Y-axis labels
              SizedBox(
                width: 30,
                height: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildYAxisLabel(maxValue.toDouble()),
                    _buildYAxisLabel(maxValue * 0.75),
                    _buildYAxisLabel(maxValue * 0.5),
                    _buildYAxisLabel(maxValue * 0.25),
                    _buildYAxisLabel(0),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Bar graph
              Expanded(
                child: SizedBox(
                  height: 180, // ✅ Increased from 150
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(7, (index) {
                      final value = data[index] ?? 0;
                      final barHeight = maxValue > 0
                          ? (value / maxValue) * 140
                          : 0.0; // ✅ Increased from 120

                      return Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2), // Small spacing between bars
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize
                                .min, // ✅ CRITICAL: Minimize vertical space
                            children: [
                              // Value label on top of bar
                              if (value > 0)
                                Container(
                                  constraints:
                                      const BoxConstraints(maxWidth: 45),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    value.toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 8.5,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                  ),
                                ),
                              if (value > 0)
                                const SizedBox(height: 3), // ✅ Reduced from 4

                              // Bar
                              Container(
                                width: 22,
                                height:
                                    barHeight < 2 && value > 0 ? 2 : barHeight,
                                decoration: BoxDecoration(
                                  color: value > 0 ? color : Colors.transparent,
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(4)),
                                ),
                              ),
                              const SizedBox(height: 6), // ✅ Reduced from 8

                              // Day label
                              Text(
                                weekDays[index],
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Average
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Average',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE91E63),
                ),
              ),
              Text(
                '${average.toStringAsFixed(0)} $unit',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildYAxisLabel(double value) {
    return Text(
      value.toInt().toString(),
      style: GoogleFonts.poppins(
        fontSize: 10,
        color: Colors.grey[500],
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // ========== HELPERS ==========
  double _calculateAverage(Map<int, int> data) {
    if (data.isEmpty) return 0;
    final sum = data.values.reduce((a, b) => a + b);
    return sum / data.length;
  }

  bool _canGoNextWeek(DateTime weekStart) {
    final now = DateTime.now();
    final currentWeekStart = now.subtract(Duration(days: now.weekday % 7));
    return weekStart.isBefore(currentWeekStart);
  }

  void _showLogWeightDialog() {
    final TextEditingController weightController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Log Weight',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        content: TextField(
          controller: weightController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Enter weight (kg)',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final weight = double.tryParse(weightController.text);
              if (weight != null) {
                final user = _userService.currentUser.value;
                if (user != null) {
                  await _firestoreService.logWeight(
                    userId: user.uid,
                    weight: weight,
                  );

                  setState(() {
                    currentWeight = weight;
                    weightHistory.add(WeightEntry(
                      date: DateTime.now(),
                      weight: weight,
                    ));
                  });
                }
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE91E63),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// ========== CUSTOM PAINTERS ==========

class _StripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 10; i++) {
      final x = (size.width / 10) * i;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WeightGraphPainter extends CustomPainter {
  final List<WeightEntry> weightHistory;
  final double? goalWeight;
  final DateTime selectedMonth;
  final double? initialWeight; // ✅ ADD THIS LINE

  _WeightGraphPainter(
    this.weightHistory, {
    this.goalWeight,
    required this.selectedMonth,
    this.initialWeight, // ✅ ADD THIS LINE
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (weightHistory.isEmpty) return;

    // Calculate min and max for Y-axis
    final weights = weightHistory.map((e) => e.weight).toList();
    if (goalWeight != null) weights.add(goalWeight!);

    final minWeight =
        (weights.reduce((a, b) => a < b ? a : b) / 10).floor() * 10.0;
    final maxWeight =
        (weights.reduce((a, b) => a > b ? a : b) / 10).ceil() * 10.0 + 10;

    // Define graph area (leaving space for labels)
    final graphLeft = 30.0;
    final graphTop = 10.0;
    final graphRight = size.width - 10;
    final graphBottom = size.height - 25;
    final graphWidth = graphRight - graphLeft;
    final graphHeight = graphBottom - graphTop;

    // Paint definitions
    final gridPaint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = 1;

    final linePaint = Paint()
      ..color = const Color(0xFFE91E63)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFE91E63).withOpacity(0.15),
          const Color(0xFFE91E63).withOpacity(0.02),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(
          Rect.fromLTRB(graphLeft, graphTop, graphRight, graphBottom));

    final pointPaint = Paint()
      ..color = const Color(0xFFE91E63)
      ..style = PaintingStyle.fill;

    final pointBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final goalPaint = Paint()
      ..color = Colors.grey[350]!
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final textPainter = TextPainter(
      textDirection: ui.TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Draw Y-axis labels and horizontal grid lines
    final ySteps = 3; // 3 labels: min, mid, max
    for (int i = 0; i <= ySteps; i++) {
      final weight =
          minWeight + (maxWeight - minWeight) * (ySteps - i) / ySteps;
      final y = graphTop + graphHeight * i / ySteps;

      // Draw horizontal grid line
      if (i > 0 && i < ySteps) {
        canvas.drawLine(
          Offset(graphLeft, y),
          Offset(graphRight, y),
          gridPaint,
        );
      }

      // Draw Y-axis label
      textPainter.text = TextSpan(
        text: weight.toInt().toString(),
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(5, y - textPainter.height / 2),
      );
    }

    // Calculate data points
    final points = <Offset>[];
    final daysInMonth = DateTime(
      selectedMonth.year,
      selectedMonth.month + 1,
      0,
    ).day;

    for (int i = 0; i < weightHistory.length; i++) {
      final dayOfMonth = weightHistory[i].date.day;
      final x = graphLeft + (graphWidth * (dayOfMonth - 1) / (daysInMonth - 1));
      final normalizedY =
          (weightHistory[i].weight - minWeight) / (maxWeight - minWeight);
      final y = graphBottom - (normalizedY * graphHeight);
      points.add(Offset(x, y));
    }

    if (points.isEmpty) return;

    // Draw gradient fill area
    final fillPath = Path();
    fillPath.moveTo(points[0].dx, graphBottom);

    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        fillPath.lineTo(points[i].dx, points[i].dy);
      } else {
        // Smooth curve
        final prevPoint = points[i - 1];
        final currentPoint = points[i];
        final controlPoint = Offset(
          prevPoint.dx + (currentPoint.dx - prevPoint.dx) / 2,
          prevPoint.dy,
        );
        fillPath.quadraticBezierTo(
          controlPoint.dx,
          controlPoint.dy,
          currentPoint.dx,
          currentPoint.dy,
        );
      }
    }

    fillPath.lineTo(points.last.dx, graphBottom);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);

    // Draw the main line
    final linePath = Path();
    linePath.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      final prevPoint = points[i - 1];
      final currentPoint = points[i];
      final controlPoint = Offset(
        prevPoint.dx + (currentPoint.dx - prevPoint.dx) / 2,
        prevPoint.dy,
      );
      linePath.quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        currentPoint.dx,
        currentPoint.dy,
      );
    }
    canvas.drawPath(linePath, linePaint);

    // Draw data points
    for (var point in points) {
      canvas.drawCircle(point, 5, pointBorderPaint);
      canvas.drawCircle(point, 3.5, pointPaint);
    }

    // Draw goal line (dashed)
    if (goalWeight != null) {
      final normalizedGoalY =
          (goalWeight! - minWeight) / (maxWeight - minWeight);
      final goalY = graphBottom - (normalizedGoalY * graphHeight);

      const dashWidth = 6.0;
      const dashSpace = 4.0;
      double startX = graphLeft;

      while (startX < graphRight) {
        canvas.drawLine(
          Offset(startX, goalY),
          Offset(startX + dashWidth, goalY),
          goalPaint,
        );
        startX += dashWidth + dashSpace;
      }
      // ✅ ADD ONLY THIS PART (11 lines):
      // Draw "Goal" label
      textPainter.text = TextSpan(
        text: 'Goal',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 9,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(
          canvas, Offset(graphRight - textPainter.width - 5, goalY - 12));
      // ✅ END OF ADDITION
    }

    // Draw X-axis labels (selected days: 1, 7, 14, 21, 28)
    final xLabels = [1, 7, 14, 21, 28];
    for (final day in xLabels) {
      if (day <= daysInMonth) {
        final x = graphLeft + (graphWidth * (day - 1) / (daysInMonth - 1));

        textPainter.text = TextSpan(
          text: '$day',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, graphBottom + 8),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ========== DATA MODELS ==========

class WeightEntry {
  final DateTime date;
  final double weight;

  WeightEntry({required this.date, required this.weight});
}
