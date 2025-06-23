import 'package:alumea/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:routemaster/routemaster.dart';

class OnboardingWelcomeScreen extends StatelessWidget {
  const OnboardingWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppTheme.lightGrayBackground,
      body: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(
              painter: _CirclesPainter(),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/logo.svg',
                      height: 100,
                      color: Color(0xFF6B728E),
                    ),
                    Text(
                      'alumea',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        color: Color(0xFF6B728E),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Your private space to breathe',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 60),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Routemaster.of(context).push('/onboarding-chat');
                  },
                  child:
                      const Text("Let's Start", style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CirclesPainter extends CustomPainter {
  const _CirclesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Define the Gradient
    // We'll create a LinearGradient that transitions between our two key brand colors.
    // The gradient will start at the top-left and end at the bottom-right.
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        // We'll start with our Secondary Lavender and end with our Primary Blue.
        // I've added a low opacity to both to keep the soft, atmospheric feel.
        AppTheme.secondaryLavender.withOpacity(0.15),
        AppTheme.primaryBlue.withOpacity(0.15),
      ],
      // `stops` lets you control where the colors transition. `null` gives an even blend.
      stops: [0.0, 1.0],
    );

    // 2. Create a Rect that covers the entire canvas
    // A gradient shader needs to know the boundaries of the area it will fill.
    // By making the rectangle the size of the whole screen, we create a single,
    // large gradient field that our circles will be painted on top of.
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // 3. Create the Paint object using the gradient shader
    // Instead of setting `..color`, we set `..shader`. The shader is created
    // from our gradient, bounded by the rectangle we just defined.
    final paint = Paint()..shader = gradient.createShader(rect);

    // 4. Draw the circles (This part is unchanged!)
    // The canvas will now use our gradient 'paint' to fill these circle shapes.

    // Circle 1
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.2),
      size.width * 0.65,
      paint,
    );

    // Circle 2
    canvas.drawCircle(
      Offset(size.width * 0.95, size.height * 0.85),
      size.width * 0.5,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
