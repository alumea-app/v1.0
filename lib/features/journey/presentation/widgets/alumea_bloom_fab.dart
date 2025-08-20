import 'package:flutter/material.dart';
import 'package:alumea/core/app_theme.dart';
import 'package:routemaster/routemaster.dart';
import 'dart:math';

class AlumeaBloomFab extends StatefulWidget {
  const AlumeaBloomFab({super.key});
  @override
  _AlumeaBloomFabState createState() => _AlumeaBloomFabState();
}

class _AlumeaBloomFabState extends State<AlumeaBloomFab> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _degreeAnimation;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _degreeAnimation = Tween<double>(begin: 0, end: 45).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut)
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleBloom() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) _animationController.forward();
      else _animationController.reverse();
    });
  }
  
  Widget _buildPetal(double angle, IconData icon, VoidCallback onTap, {Color color = AppTheme.primaryBlue}) {
    final double rad = angle * (pi / 180.0);
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _isExpanded ? 1.0 : 0.0,
      child: Transform.translate(
        offset: Offset.fromDirection(rad, _isExpanded ? 70.0 : 0.0),
        child: FloatingActionButton(
          heroTag: null, // Important for multiple FABs
          onPressed: (){
            _toggleBloom();
            onTap();
          },
          child: Icon(icon),
          backgroundColor: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // These are the "petal" buttons that bloom outwards.
        // Angles are counter-clockwise from the right (0 degrees is east).
        _buildPetal(270, Icons.chat_bubble_outline, () => Routemaster.of(context).push('/chat')),
        _buildPetal(225, Icons.calendar_today_outlined, () => Routemaster.of(context).push('/check-in')),
        _buildPetal(180, Icons.favorite_border_outlined, () => Routemaster.of(context).push('/sos'), color: AppTheme.accentCoral),

        // This is the main, central button.
        FloatingActionButton(
          child: AnimatedIcon(
              icon: AnimatedIcons.add_event,
              progress: _degreeAnimation
          ),
          onPressed: _toggleBloom,
        ),
      ],
    );
  }
}