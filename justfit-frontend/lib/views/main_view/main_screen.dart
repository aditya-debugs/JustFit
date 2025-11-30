import 'package:flutter/material.dart';
import 'screens/my_plan_screen.dart';
import 'screens/discovery_screen.dart';
import 'screens/activity_screen.dart';
import 'screens/progress_screen.dart';  // Add this import
import '../../common_widgets/floating_chat_button.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex; // ✅ NEW
  
  const MainScreen({
    Key? key,
    this.initialIndex = 0, // ✅ NEW default
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex; // ✅ Changed from final

  final List<Widget> _screens = [
    const MyPlanScreen(),
    const DiscoveryScreen(),
    const ActivityScreen(),
    const ProgressScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; // ✅ NEW
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        FloatingChatButton(),
      ],
    ),
    bottomNavigationBar: _buildBottomNavigationBar(),
  );
}

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.calendar_today,
                label: 'My Plan',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.fitness_center,
                label: 'Discovery',
                index: 1,
              ),
              _buildNavItem(
                icon: Icons.local_fire_department,
                label: 'Activities',
                index: 2,
              ),
              _buildNavItem(
                icon: Icons.bar_chart,
                label: 'Progress',
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFE31E52) : Colors.grey[600],
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFFE31E52) : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
