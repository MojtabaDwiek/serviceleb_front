import 'dart:math';
import 'package:flutter/material.dart';

class ExplodingRoute extends PageRouteBuilder {
  final Widget page;
  final Color primaryColor;
  final Color secondaryColor;

  ExplodingRoute({
    required this.page,
    this.primaryColor = const Color(0xFFEE161F),
    this.secondaryColor = const Color(0xFF00A651),
  }) : super(
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 450),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            );

            return Stack(
              children: [
                // Background explosion (only on forward animation)
                if (animation.status != AnimationStatus.reverse)
                  AnimatedBuilder(
                    animation: curvedAnimation,
                    builder: (context, child) {
                      final value = curvedAnimation.value;
                      return Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.center,
                            colors: [
                              primaryColor.withAlpha((value * 0.8 * 255).toInt()),
                              secondaryColor.withAlpha((value * 0.5 * 255).toInt()),
                              Colors.white.withAlpha((value * 0.3 * 255).toInt()),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                            radius: value * 2.5,
                          ),
                        ),
                      );
                    },
                  ),
                
                // Content transition
                ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.85,
                    end: 1.0,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
                  )),
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: animation,
                      curve: const Interval(0.1, 0.8, curve: Curves.easeIn),
                    ),
                    child: child,
                  ),
                ),
                
                // Particles (only on forward animation)
                if (animation.status != AnimationStatus.reverse)
                  ..._generateParticles(animation, primaryColor, secondaryColor),
              ],
            );
          },
        );

  static List<Widget> _generateParticles(
    Animation<double> animation,
    Color primaryColor,
    Color secondaryColor,
  ) {
    const particleCount = 8;
    return List.generate(particleCount, (index) {
      final angle = 2 * pi * index / particleCount;
      final distance = Tween<double>(begin: 0.0, end: 1.2).animate(
        CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.7, curve: Curves.easeOutQuad),
        ),
      );

      return AnimatedBuilder(
        animation: distance,
        builder: (context, _) {
          final distanceValue = distance.value;
          final scale = (1.2 - distanceValue).clamp(0.0, 1.2);
          final opacity = (1 - pow(distanceValue, 2) as double).clamp(0.0, 1.0);
          final offsetX = distanceValue * 150 * cos(angle);
          final offsetY = distanceValue * 150 * sin(angle);
          final color = index.isEven ? primaryColor : secondaryColor;

          if (opacity < 0.05) return const SizedBox.shrink();

          return Positioned.fill(
            child: Transform.translate(
              offset: Offset(offsetX, offsetY),
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      boxShadow: [
                        BoxShadow(
                          color: color.withAlpha((opacity * 0.5 * 255).toInt()),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}