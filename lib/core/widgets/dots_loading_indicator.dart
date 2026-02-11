import 'dart:async';

import 'package:flutter/material.dart';

class DotsLoadingIndicator extends StatefulWidget {
  final int count; // Number of dots
  final Color activeColor; // Color of the active dot
  final Color inactiveColor; // Color of the inactive dots

  const DotsLoadingIndicator({
    super.key,
    required this.count,
    this.activeColor = Colors.white,
    this.inactiveColor = Colors.grey,
  });

  @override
  State<DotsLoadingIndicator> createState() => _DotsLoadingIndicatorState();
}

class _DotsLoadingIndicatorState extends State<DotsLoadingIndicator> {
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _activeIndex = (_activeIndex + 1) % widget.count;
        });
      }
    }).then((_) => _startTimer());
  }

  void _startTimer() {
    Timer.periodic(const Duration(milliseconds: 300), (_) {
      if (mounted) {
        setState(() {
          _activeIndex = (_activeIndex + 1) % (widget.count + 1);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(widget.count, (index) => _buildDot(index)),
    );
  }

  Widget _buildDot(int index) {
    return SizedBox(
      height: 10,
      width: 15,
      child: Center(
        child: AnimatedContainer(
          // curve: Curves.ease,
          duration: const Duration(milliseconds: 300),

          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == _activeIndex
                ? widget.activeColor
                : widget.inactiveColor,
          ),
          width: index == _activeIndex ? 10 : 5,
          height: index == _activeIndex ? 10 : 5,
          margin: const EdgeInsets.symmetric(horizontal: 3),
        ),
      ),
    );
  }
}
