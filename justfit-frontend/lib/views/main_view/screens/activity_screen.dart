import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/firestore_service.dart';
import '../../../core/services/user_service.dart';


class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  // ✅ Static method must be in ActivityScreen, not _ActivityScreenState
  static void addWorkout({
    required String title,
    required int duration,
    required int calories,
  }) {
    // Placeholder for now - will implement proper state management later
    print('✅ Workout completed: $title - $duration min - $calories cal');
    // TODO: Implement GetX controller to actually update the activity screen
  }

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

  class _ActivityScreenState extends State<ActivityScreen> with SingleTickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now();
  int _calorieGoal = 430; // Will be calculated dynamically from workout plan
  
  // ✅ Firestore integration
  late FirestoreService _firestoreService;
  late UserService _userService;
  
  // ✅ Reactive workout lists
  final RxList<Map<String, dynamic>> _todayWorkouts = <Map<String, dynamic>>[].obs;
  final RxBool _isLoading = true.obs;
  
  // ✅ Day-specific data storage
  Map<String, DayActivityData> _dayDataMap = {};
  
  // Animation controller for smooth transitions
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // ✅ Initialize services
    _firestoreService = Get.find<FirestoreService>();
    _userService = Get.find<UserService>();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    // ✅ Calculate dynamic calorie goal from workout plan
    _calculateCalorieGoal();
    
    // ✅ Load today's workouts from Firestore
    _loadTodayWorkouts();
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ✅ NEW: Load workouts from Firestore
  Future<void> _loadTodayWorkouts() async {
    _isLoading.value = true;
    
    try {
      final user = _userService.currentUser.value;
      if (user != null) {
        final workouts = await _firestoreService.getTodayWorkouts(userId: user.uid);
        _todayWorkouts.value = workouts;
        print('✅ Loaded ${workouts.length} workouts from Firestore');
        
        // Update calorie count based on real workouts
        if (workouts.isNotEmpty) {
          final totalCalories = workouts.fold<int>(
            0,
            (sum, workout) => sum + ((workout['calories'] as int?) ?? 0),
          );
          
          final today = _formatDate(DateTime.now());
          if (_dayDataMap.containsKey(today)) {
            setState(() {
              _dayDataMap[today]!.caloriesBurned = totalCalories;
            });
          }
        }
      }
    } catch (e) {
      print('❌ Error loading workouts: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// ✅ Calculate calorie goal from workout plan
  Future<void> _calculateCalorieGoal() async {
    try {
      final user = _userService.currentUser.value;
      if (user == null) return;
      
      // Get user's active workout plan from Firestore
      final planSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('workout_plans')
          .where('status', isEqualTo: 'active')
          .limit(1)
          .get();
      
      if (planSnapshot.docs.isEmpty) {
        print('⚠️ No active workout plan found, using default goal');
        return;
      }
      
      final planData = planSnapshot.docs.first.data();
      
      // Try to get dailyWorkouts from the plan
      final dailyWorkouts = planData['dailyWorkouts'] as List<dynamic>?;
      
      if (dailyWorkouts == null || dailyWorkouts.isEmpty) {
        print('⚠️ No daily workouts in plan, using default goal');
        return;
      }
      
      // Calculate average daily calories from all workouts in the plan
      final totalCalories = dailyWorkouts.fold<int>(
        0,
        (sum, day) {
          final calories = day['estimatedCalories'] as int?;
          return sum + (calories ?? 0);
        },
      );
      
      if (totalCalories > 0) {
        final avgCalories = (totalCalories / dailyWorkouts.length).round();
        
        setState(() {
          _calorieGoal = avgCalories;
        });
        
        print('✅ Calorie goal calculated from plan: $_calorieGoal kcal/day');
      }
      
    } catch (e) {
      print('❌ Error calculating calorie goal: $e');
      // Keep default value of 430
    }
  }

  /// ✅ Load workouts for a specific date from Firestore
  Future<void> _loadWorkoutsForDate(DateTime date) async {
    _isLoading.value = true;
    
    try {
      final user = _userService.currentUser.value;
      if (user == null) {
        _isLoading.value = false;
        return;
      }
      
      // Query using timestamp range (more reliable)
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      final dateStr = _formatDate(date);  // ← ADD THIS LINE
      
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('workouts')
          .where('completedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('completedAt', isLessThan: Timestamp.fromDate(endOfDay))
          .get();
      
      final workouts = snapshot.docs.map((doc) => doc.data()).toList();
      print('✅ Loaded ${workouts.length} workouts for ${date.toString().split(' ')[0]}');
      
      // Ensure day data exists
      if (!_dayDataMap.containsKey(dateStr)) {
        _dayDataMap[dateStr] = DayActivityData(
          caloriesBurned: 0,
          todayWorkouts: [],
          activities: [],
        );
      }
      
      // Calculate total calories from workouts
      final totalCalories = workouts.fold<int>(
        0,
        (sum, workout) => sum + ((workout['calories'] as int?) ?? 0),
      );
      
      setState(() {
        _dayDataMap[dateStr]!.todayWorkouts = workouts;
        _dayDataMap[dateStr]!.caloriesBurned = totalCalories;
      });
      
    } catch (e) {
      print('❌ Error loading workouts for date: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void _initializeDummyData() {
    final today = _formatDate(DateTime.now());
    final yesterday = _formatDate(DateTime.now().subtract(const Duration(days: 1)));
    final dayBefore = _formatDate(DateTime.now().subtract(const Duration(days: 2)));
    
    _dayDataMap[today] = DayActivityData(
      caloriesBurned: 0, // Will be updated by Firestore data
      todayWorkouts: [], // Will be populated by Firestore
      activities: [
        ActivityItem(
          name: 'Indoor Walking',
          duration: 30,
          calories: 60,
          icon: Icons.directions_walk,
          date: DateTime.now(),
          isCustom: false,
        ),
        ActivityItem(
          name: 'Fishing',
          duration: 30,
          calories: 30,
          icon: Icons.directions_run,
          date: DateTime.now(),
          isCustom: false,
        ),
      ],
    );
    
    _dayDataMap[yesterday] = DayActivityData(
      caloriesBurned: 120,
      todayWorkouts: [],
      activities: [
        ActivityItem(
          name: 'Yoga',
          duration: 45,
          calories: 120,
          icon: Icons.self_improvement,
          date: DateTime.now().subtract(const Duration(days: 1)),
          isCustom: false,
        ),
      ],
    );
    
    _dayDataMap[dayBefore] = DayActivityData(
      caloriesBurned: 0,
      todayWorkouts: [],
      activities: [],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  DayActivityData _getCurrentDayData() {
    final key = _formatDate(_selectedDate);
    if (!_dayDataMap.containsKey(key)) {
      _dayDataMap[key] = DayActivityData(
        caloriesBurned: 0,
        todayWorkouts: [],
        activities: [],
      );
    }
    return _dayDataMap[key]!;
  }

  void _addActivity(ActivityItem activity) {
    final key = _formatDate(activity.date);
    if (!_dayDataMap.containsKey(key)) {
      _dayDataMap[key] = DayActivityData(
        caloriesBurned: 0,
        todayWorkouts: [],
        activities: [],
      );
    }
    setState(() {
      _dayDataMap[key]!.activities.add(activity);
      _dayDataMap[key]!.caloriesBurned += activity.calories;
    });
  }

  final List<String> _motivationalMessages = [
    "The body achieves what the mind believes.",
    "You have completed 20%, keep going!",
    "The clock is ticking. Are you becoming the person you want to be?",
    "Small progress is still progress.",
    "Your only limit is you.",
  ];

  String get _currentMessage {
    final index = _selectedDate.day % _motivationalMessages.length;
    return _motivationalMessages[index];
  }

  bool get _isRestDay {
    return _selectedDate.day == 10;
  }

  bool get _isToday {
    final now = DateTime.now();
    return _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;
  }

  void _changeDay(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
    
    // ✅ Load workouts for the new date
    _loadWorkoutsForDate(_selectedDate);
    
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final currentData = _getCurrentDayData();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _loadTodayWorkouts(); // ✅ Refresh from Firestore
            setState(() {
              _animationController.reset();
              _animationController.forward();
            });
          },
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    child: _buildDateHeader(),
                  ),
                ),
                
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        _buildCalorieRing(currentData.caloriesBurned),
                        const SizedBox(height: 24),
                        _buildMotivationalMessage(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildTodayWorkouts(currentData.todayWorkouts),
                      const SizedBox(height: 32),
                      _buildActivities(currentData.activities),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateHeader() {
    final displayText = _isToday
        ? 'Today'
        : DateFormat('MMM d, yyyy').format(_selectedDate);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => _changeDay(-1),
            icon: const Icon(Icons.chevron_left, size: 28),
            color: Colors.black,
          ),
          Text(
            displayText,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          // ✅ Disable right arrow if today
          IconButton(
            onPressed: _isToday ? null : () => _changeDay(1),
            icon: const Icon(Icons.chevron_right, size: 28),
            color: _isToday ? Colors.grey[300] : Colors.black,
          ),
        ],
      ),
    );
  }

    Widget _buildCalorieRing(int caloriesBurned) {
    final percentage = caloriesBurned / _calorieGoal;
    final displayPercentage = percentage.clamp(0.0, 1.0); // For ring display
    final isOverGoal = percentage > 1.0;

    return Center(
      child: SizedBox(
        width: 260,
        height: 260,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 260,
              height: 260,
              child: CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 16,
                color: Colors.grey[200],
              ),
            ),
            SizedBox(
              width: 260,
              height: 260,
              child: CircularProgressIndicator(
                value: displayPercentage,
                strokeWidth: 16,
                color: isOverGoal 
                    ? const Color(0xFF4CAF50) // Green when over goal
                    : const Color(0xFFE31E52), // Pink when under goal
                strokeCap: StrokeCap.round,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$caloriesBurned',
                  style: GoogleFonts.poppins(
                    fontSize: 56,
                    fontWeight: FontWeight.w700,
                    color: isOverGoal ? const Color(0xFF4CAF50) : Colors.black,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '/$_calorieGoal kcal',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                if (isOverGoal)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '🎉 Goal Exceeded!',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF4CAF50),
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

  Widget _buildMotivationalMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2C3E50),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.smart_toy_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _currentMessage,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

    Widget _buildTodayWorkouts(List<Map<String, dynamic>> localWorkouts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Today Workouts',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // ✅ Show Firestore workouts if today is selected
        if (_isToday)
          Obx(() {
            if (_isLoading.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE31E52)),
                  ),
                ),
              );
            }
            
            if (_isRestDay) {
              return _buildRestDayCard();
            }
            
            if (_todayWorkouts.isEmpty) {
              return _buildNoWorkoutCard();
            }
            
            // ✅ Display real workouts from Firestore
            return Column(
              children: _todayWorkouts.map((workout) {
                return _buildFirestoreWorkoutCard(workout);
              }).toList(),
            );
          })
        else if (_isRestDay)
          _buildRestDayCard()
        else if (localWorkouts.isEmpty)
          _buildNoWorkoutCard()
        else
          ...localWorkouts.map((workout) => _buildWorkoutCard(workout)).toList(),
      ],
    );
  }

  Widget _buildRestDayCard() {
    // TODO: When AI plan is ready, this card should display:
    // - Rest day message from AI plan (dayPlan.dayTitle or dayPlan.daySubtitle)
    // - Custom rest day instructions if provided by AI
    // For now, showing static "No Workout Day - Rest for energy"
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE5E5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.local_cafe_outlined,
                color: Color(0xFFE31E52),
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No Workout Day',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rest for energy',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoWorkoutCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'No workouts completed yet',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutCard(Map<String, dynamic> workout) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: workout['image'] != null
                      ? Image.asset(
                          workout['image'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.fitness_center,
                              size: 40,
                              color: Colors.grey[500],
                            );
                          },
                        )
                      : Icon(
                          Icons.fitness_center,
                          size: 40,
                          color: Colors.grey[500],
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout['title'] ?? 'Workout', // ✅ Fallback if null
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                      Text(
                        '${workout['duration'] ?? 0} min | ${workout['calories'] ?? 0} kcal',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }


  // ✅ NEW: Build workout card from Firestore data
  Widget _buildFirestoreWorkoutCard(Map<String, dynamic> workout) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 80,
                  height: 80,
                  color: const Color(0xFFFFE5F0),
                  child: const Icon(
                    Icons.fitness_center,
                    size: 40,
                    color: Color(0xFFE31E52),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout['day'] == 0 
                          ? (workout['workoutTitle'] ?? 'Discovery Workout')
                          : 'Day ${workout['day']} Workout',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${workout['duration']} min | ${workout['calories']} kcal',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (workout['completedAt'] != null)
                      Text(
                        _formatFirestoreTime(workout['completedAt']),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[500],
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                workout['isComplete'] == true
                    ? Icons.check_circle
                    : Icons.access_time,
                color: workout['isComplete'] == true
                    ? Colors.green
                    : Colors.orange,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Helper to format Firestore timestamp
  String _formatFirestoreTime(dynamic timestamp) {
    if (timestamp == null) return '';
    try {
      final dateTime = (timestamp as Timestamp).toDate();
      return DateFormat('h:mm a').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  Widget _buildActivities(List<ActivityItem> activities) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'Activities',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      const SizedBox(height: 16),
      // ✅ Show all activity cards (if any)
      ...activities.map((activity) => _buildActivityCard(activity)).toList(),
      // ✅ Always show "Add More Activity" button at the bottom (only once)
      const SizedBox(height: 12),
      _buildAddMoreActivityButton(),
    ],
  );
}

  Widget _buildActivityCard(ActivityItem activity) {
    // ✅ Use fire icon for custom activities, otherwise use provided icon
    final displayIcon = activity.isCustom ? Icons.local_fire_department : activity.icon;
    
    // Generate colors based on activity name
    final colors = _getActivityColors(activity.name);
    
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors['background'],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                displayIcon,
                color: colors['icon'],
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.name,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${activity.duration} min',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${activity.calories} kcal',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFE31E52),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, Color> _getActivityColors(String name) {
    final hash = name.hashCode.abs();
    final colorOptions = [
      {'background': const Color(0xFFFFE5F0), 'icon': const Color(0xFFE31E52)},
      {'background': const Color(0xFFE5F4FF), 'icon': const Color(0xFF2196F3)},
      {'background': const Color(0xFFFFEFE5), 'icon': const Color(0xFFFF9800)},
      {'background': const Color(0xFFE8F5E9), 'icon': const Color(0xFF4CAF50)},
      {'background': const Color(0xFFF3E5F5), 'icon': const Color(0xFF9C27B0)},
      {'background': const Color(0xFFFFF9C4), 'icon': const Color(0xFFFBC02D)},
    ];
    return colorOptions[hash % colorOptions.length];
  }

  Widget _buildAddMoreActivityButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {
          _showAddActivitySheet();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: Text(
            'Add More Activity',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFE31E52),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddActivitySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => AddActivitySheet(
        onActivityAdded: (activity) {
          _addActivity(activity);
        },
      ),
    );
  }
}

// ==================== DATA MODELS ====================
class DayActivityData {
  int caloriesBurned;
  List<Map<String, dynamic>> todayWorkouts;
  List<ActivityItem> activities;

  DayActivityData({
    required this.caloriesBurned,
    required this.todayWorkouts,
    required this.activities,
  });
}

class ActivityItem {
  final String name;
  final int duration;
  final int calories;
  final IconData icon;
  final DateTime date;
  final bool isCustom; // ✅ Track if it's a custom activity

  ActivityItem({
    required this.name,
    required this.duration,
    required this.calories,
    required this.icon,
    required this.date,
    required this.isCustom,
  });
}

// ==================== ADD ACTIVITY BOTTOM SHEET ====================
class AddActivitySheet extends StatefulWidget {
  final Function(ActivityItem) onActivityAdded;
  
  const AddActivitySheet({Key? key, required this.onActivityAdded}) : super(key: key);

  @override
  State<AddActivitySheet> createState() => _AddActivitySheetState();
}

class _AddActivitySheetState extends State<AddActivitySheet> {
  final List<Map<String, dynamic>> _allActivities = [
    {'name': 'Indoor Walking', 'icon': Icons.directions_walk, 'category': 'Popular'},
    {'name': 'Garden Walking', 'icon': Icons.directions_walk, 'category': 'Popular'},
    {'name': 'Dog Walking', 'icon': Icons.directions_walk, 'category': 'Popular'},
    {'name': 'Outdoor Running', 'icon': Icons.directions_run, 'category': 'Popular'},
    {'name': 'House Working', 'icon': Icons.home_work_outlined, 'category': 'Popular'},
    {'name': 'Slow dancing', 'icon': Icons.music_note, 'category': 'Popular'},
    {'name': 'Play with toddlers', 'icon': Icons.child_care, 'category': 'Popular'},
    {'name': 'Aerobics', 'icon': Icons.fitness_center, 'category': 'A'},
    {'name': 'Archery', 'icon': Icons.sports, 'category': 'A'},
    {'name': 'Auto Repairing', 'icon': Icons.build, 'category': 'A'},
    {'name': 'Barre', 'icon': Icons.fitness_center, 'category': 'B'},
    {'name': 'Baseball', 'icon': Icons.sports_baseball, 'category': 'B'},
    {'name': 'City Bike', 'icon': Icons.pedal_bike, 'category': 'C'},
    {'name': 'Cycle Track', 'icon': Icons.pedal_bike, 'category': 'C'},
    {'name': 'Curling', 'icon': Icons.sports, 'category': 'C'},
    {'name': 'Climbing', 'icon': Icons.hiking, 'category': 'C'},
    {'name': 'Car Washing', 'icon': Icons.local_car_wash, 'category': 'C'},
    {'name': 'Capoeira', 'icon': Icons.sports_martial_arts, 'category': 'C'},
    {'name': 'Dog Walking', 'icon': Icons.pets, 'category': 'D'},
    {'name': 'Diving', 'icon': Icons.pool, 'category': 'D'},
    {'name': 'Elliptical', 'icon': Icons.fitness_center, 'category': 'E'},
    {'name': 'Football', 'icon': Icons.sports_football, 'category': 'F'},
    {'name': 'Field Hockey', 'icon': Icons.sports_hockey, 'category': 'F'},
    {'name': 'Fencing', 'icon': Icons.sports, 'category': 'F'},
    {'name': 'Table Tennis', 'icon': Icons.sports_tennis, 'category': 'T'},
    {'name': 'Tae Kwon Do', 'icon': Icons.sports_martial_arts, 'category': 'T'},
    {'name': 'Volleyball', 'icon': Icons.sports_volleyball, 'category': 'V'},
    {'name': 'Vacuuming', 'icon': Icons.cleaning_services, 'category': 'V'},
    {'name': 'Weighting', 'icon': Icons.fitness_center, 'category': 'W'},
    {'name': 'Water Polo', 'icon': Icons.pool, 'category': 'W'},
    {'name': 'Water skiing', 'icon': Icons.water, 'category': 'W'},
    {'name': 'Window Cleaning', 'icon': Icons.cleaning_services, 'category': 'W'},
    {'name': 'Wood Chopping', 'icon': Icons.carpenter, 'category': 'W'},
    {'name': 'Wrestling', 'icon': Icons.sports_martial_arts, 'category': 'W'},
    {'name': 'Yoga', 'icon': Icons.self_improvement, 'category': 'Y'},
    {'name': 'Yard Work', 'icon': Icons.grass, 'category': 'Y'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 40,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                Text(
                  'ADD ACTIVITY',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: InkWell(
              onTap: () {
                _showCustomActivitySheet(context);
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5E5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFB74D), width: 2),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.add_circle_outline,
                        size: 28,
                        color: Color(0xFFFF9800),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Your Own Activity',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Create custom activity',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey[600],
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1),
          ),
          
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _buildCategoryList().length,
              itemBuilder: (context, index) => _buildCategoryList()[index],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCategoryList() {
    final categories = <String>['Popular', 'A', 'B', 'C', 'D', 'E', 'F', 'T', 'V', 'W', 'Y'];
    final widgets = <Widget>[];

    for (final category in categories) {
      final activities = _allActivities.where((a) => a['category'] == category).toList();
      if (activities.isEmpty) continue;

      widgets.add(
        Padding(
          padding: EdgeInsets.fromLTRB(16, category == 'Popular' ? 8 : 16, 16, 8),
          child: Text(
            category,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ),
      );

      for (final activity in activities) {
        widgets.add(_buildActivityItem(activity));
      }
    }

    return widgets;
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return InkWell(
      onTap: () {
        _showActivityDetailSheet(context, activity);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                activity['icon'],
                size: 24,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                activity['name'],
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomActivitySheet(BuildContext parentContext) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomActivitySheet(onActivityAdded: widget.onActivityAdded),
    );
  }

  void _showActivityDetailSheet(BuildContext parentContext, Map<String, dynamic> activity) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => ActivityDetailSheet(
        activity: activity,
        onActivityAdded: widget.onActivityAdded,
      ),
    );
  }
}

// ==================== CUSTOM ACTIVITY SHEET ====================
class CustomActivitySheet extends StatefulWidget {
  final Function(ActivityItem) onActivityAdded;
  
  const CustomActivitySheet({Key? key, required this.onActivityAdded}) : super(key: key);

  @override
  State<CustomActivitySheet> createState() => _CustomActivitySheetState();
}

class _CustomActivitySheetState extends State<CustomActivitySheet> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _durationController = TextEditingController(text: '30');
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _durationFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  @override
  void dispose() {
    _durationController.dispose();
    _descriptionController.dispose();
    _durationFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        height: MediaQuery.of(context).size.height - 40,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.black,
                  ),
                  Expanded(
                    child: Text(
                      'Add Your Own Activity',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activity Description',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _descriptionController,
                      focusNode: _descriptionFocusNode,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Describe your activity...',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[400],
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE31E52), width: 2),
                        ),
                      ),
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedDate = DateTime.now();
                            });
                          },
                          child: Text(
                            'Today',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFE31E52),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFFE31E52),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedDate = picked;
                          });
                        // Date changed - parent will reload on return
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('MMMM d, yyyy').format(_selectedDate),
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    Text(
                      'Duration (minutes)',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _durationController,
                      focusNode: _durationFocusNode,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        hintText: '30',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey[400],
                        ),
                        suffixText: 'min',
                        suffixStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE31E52), width: 2),
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_descriptionController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please describe your activity'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }
                    
                    final duration = int.tryParse(_durationController.text) ?? 30;
                    final calories = (duration * 2);
                    
                    // ✅ Mark as custom activity
                    final activity = ActivityItem(
                      name: _descriptionController.text.trim(),
                      duration: duration,
                      calories: calories,
                      icon: Icons.local_fire_department, // Fire icon for custom
                      date: _selectedDate,
                      isCustom: true, // ✅ This is a custom activity
                    );
                    
                    widget.onActivityAdded(activity);
                    
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Custom activity added! AI will process it soon.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE31E52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Add',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== ACTIVITY DETAIL SHEET ====================
class ActivityDetailSheet extends StatefulWidget {
  final Map<String, dynamic> activity;
  final Function(ActivityItem) onActivityAdded;

  const ActivityDetailSheet({
    Key? key,
    required this.activity,
    required this.onActivityAdded,
  }) : super(key: key);

  @override
  State<ActivityDetailSheet> createState() => _ActivityDetailSheetState();
}

class _ActivityDetailSheetState extends State<ActivityDetailSheet> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _durationController = TextEditingController(text: '30');
  final FocusNode _durationFocusNode = FocusNode();

  @override
  void dispose() {
    _durationController.dispose();
    _durationFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        height: MediaQuery.of(context).size.height - 40,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.black,
                  ),
                  Expanded(
                    child: Text(
                      widget.activity['name'],
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedDate = DateTime.now();
                            });
                          },
                          child: Text(
                            'Today',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFE31E52),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFFE31E52),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedDate = picked;
                          });
                        // Date changed - parent will reload on return
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('MMMM d, yyyy').format(_selectedDate),
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    Text(
                      'Duration',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _durationController,
                      focusNode: _durationFocusNode,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        hintText: '30',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey[400],
                        ),
                        suffixText: 'min',
                        suffixStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE31E52), width: 2),
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    final duration = int.tryParse(_durationController.text) ?? 30;
                    final calories = (duration * 2);
                    
                    // ✅ Regular activity (not custom)
                    final activity = ActivityItem(
                      name: widget.activity['name'],
                      duration: duration,
                      calories: calories,
                      icon: widget.activity['icon'],
                      date: _selectedDate,
                      isCustom: false, // ✅ Not a custom activity
                    );
                    
                    widget.onActivityAdded(activity);
                    
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${widget.activity['name']} added!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE31E52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Add',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}