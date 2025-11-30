import 'package:flutter/material.dart';
import '../views/chat_view/chat_screen.dart';

class FloatingChatButton extends StatefulWidget {
  const FloatingChatButton({Key? key}) : super(key: key);

  @override
  State<FloatingChatButton> createState() => _FloatingChatButtonState();
}

class _FloatingChatButtonState extends State<FloatingChatButton> 
    with SingleTickerProviderStateMixin {
  Offset _position = const Offset(20, 100); // Start bottom-right
  bool _isDragging = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final safeArea = MediaQuery.of(context).padding;

    return Positioned(
      right: _position.dx,
      bottom: _position.dy,
      child: GestureDetector(
        onPanStart: (_) {
          setState(() => _isDragging = true);
        },
        onPanUpdate: (details) {
          setState(() {
            // Update position as user drags
            double newX = _position.dx - details.delta.dx;
            double newY = _position.dy - details.delta.dy;

            // Constrain to screen bounds (keep button fully visible)
            newX = newX.clamp(
              8.0, // Min right padding
              screenSize.width - 68, // Max right (screen width - button width - padding)
            );
            newY = newY.clamp(
              8.0 + safeArea.bottom, // Min bottom padding + safe area
              screenSize.height - safeArea.top - 68, // Max bottom
            );

            _position = Offset(newX, newY);
          });
        },
        onPanEnd: (_) {
          setState(() => _isDragging = false);
        },
        child: _buildChatButton(),
      ),
    );
  }

  Widget _buildChatButton() {
    return GestureDetector(
      onTap: _isDragging
          ? null
          : () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const ChatScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOutCubic;
                    var tween = Tween(begin: begin, end: end).chain(
                      CurveTween(curve: curve),
                    );
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 400),
                ),
              );
            },
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Pulse ring
              if (!_isDragging)
                Container(
                  width: 60 + (10 * _pulseController.value),
                  height: 60 + (10 * _pulseController.value),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE91E63).withOpacity(
                        0.4 * (1 - _pulseController.value),
                      ),
                      width: 2,
                    ),
                  ),
                ),
              // Main button
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: _isDragging ? 65 : 60,
                height: _isDragging ? 65 : 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE91E63), Color(0xFFE91E63)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE91E63).withOpacity(_isDragging ? 0.6 : 0.4),
                      blurRadius: _isDragging ? 25 : 18,
                      offset: Offset(0, _isDragging ? 6 : 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.psychology_rounded,
                  color: Colors.white,
                  size: _isDragging ? 32 : 30,
                ),
              ),
              // Notification badge (optional - can show unread count)
              if (!_isDragging)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
