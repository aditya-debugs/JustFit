import 'package:flutter/material.dart';

/// Centralized page transitions for consistent animations throughout the app
/// Use these for smooth, production-grade navigation experience
class PageTransitions {
  /// Standard slide from right transition (default for forward navigation)
  static Route<T> slideFromRight<T>(Widget page, {int durationMs = 300}) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
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
      transitionDuration: Duration(milliseconds: durationMs),
    );
  }

  /// Slide from left transition (for back navigation feel)
  static Route<T> slideFromLeft<T>(Widget page, {int durationMs = 300}) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
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
      transitionDuration: Duration(milliseconds: durationMs),
    );
  }

  /// Slide from bottom transition (for modal-like screens)
  static Route<T> slideFromBottom<T>(Widget page, {int durationMs = 350}) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: durationMs),
    );
  }

  /// Fade transition (for subtle screen changes)
  static Route<T> fade<T>(Widget page, {int durationMs = 250}) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: durationMs),
    );
  }

  /// Scale transition (for popup-like effect)
  static Route<T> scale<T>(Widget page, {int durationMs = 300}) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeOutCubic;

        var scaleTween = Tween(begin: 0.92, end: 1.0).chain(
          CurveTween(curve: curve),
        );

        var fadeTween = Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: curve),
        );

        return ScaleTransition(
          scale: animation.drive(scaleTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
      transitionDuration: Duration(milliseconds: durationMs),
    );
  }

  /// Combined fade + slide transition (smooth and elegant)
  static Route<T> fadeSlideFromRight<T>(Widget page, {int durationMs = 300}) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.15, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var slideTween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        var fadeTween = Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(slideTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
      transitionDuration: Duration(milliseconds: durationMs),
    );
  }

  /// Shared axis transition (Material Design 3 style)
  static Route<T> sharedAxis<T>(Widget page, {int durationMs = 300}) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Forward animation
        const enterBegin = Offset(0.3, 0.0);
        const enterEnd = Offset.zero;
        
        var enterSlide = Tween(begin: enterBegin, end: enterEnd).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          ),
        );

        var enterFade = Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
          ),
        );

        // Exit animation
        const exitEnd = Offset(-0.3, 0.0);
        
        var exitSlide = Tween(begin: Offset.zero, end: exitEnd).animate(
          CurvedAnimation(
            parent: secondaryAnimation,
            curve: Curves.easeInOutCubic,
          ),
        );

        var exitFade = Tween(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(
            parent: secondaryAnimation,
            curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
          ),
        );

        return Stack(
          children: [
            // Exiting page
            SlideTransition(
              position: exitSlide,
              child: FadeTransition(
                opacity: exitFade,
                child: secondaryAnimation.isCompleted ? Container() : Container(),
              ),
            ),
            // Entering page
            SlideTransition(
              position: enterSlide,
              child: FadeTransition(
                opacity: enterFade,
                child: child,
              ),
            ),
          ],
        );
      },
      transitionDuration: Duration(milliseconds: durationMs),
    );
  }

  /// No transition (instant)
  static Route<T> none<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: Duration.zero,
    );
  }
}

/// Extension for easy navigation with transitions
extension NavigationExtensions on BuildContext {
  /// Push with slide from right transition
  Future<T?> pushWithSlide<T>(Widget page) {
    return Navigator.of(this).push<T>(PageTransitions.slideFromRight(page));
  }

  /// Push with fade slide transition
  Future<T?> pushWithFadeSlide<T>(Widget page) {
    return Navigator.of(this).push<T>(PageTransitions.fadeSlideFromRight(page));
  }

  /// Push with fade transition
  Future<T?> pushWithFade<T>(Widget page) {
    return Navigator.of(this).push<T>(PageTransitions.fade(page));
  }

  /// Push with scale transition
  Future<T?> pushWithScale<T>(Widget page) {
    return Navigator.of(this).push<T>(PageTransitions.scale(page));
  }

  /// Push with slide from bottom
  Future<T?> pushWithSlideFromBottom<T>(Widget page) {
    return Navigator.of(this).push<T>(PageTransitions.slideFromBottom(page));
  }

  /// Replace with slide from right transition
  Future<T?> pushReplacementWithSlide<T>(Widget page) {
    return Navigator.of(this).pushReplacement<T, dynamic>(
      PageTransitions.slideFromRight(page),
    );
  }

  /// Replace with fade transition
  Future<T?> pushReplacementWithFade<T>(Widget page) {
    return Navigator.of(this).pushReplacement<T, dynamic>(
      PageTransitions.fade(page),
    );
  }
}
