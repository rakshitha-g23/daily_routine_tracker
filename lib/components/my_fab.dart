import 'package:flutter/material.dart';

class MyFloatingActionButton extends StatelessWidget {
  final Function()? onPressed;

  const MyFloatingActionButton({
    super.key,
    required this.onPressed,
  });

  final bool _showFab = true;
  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 300);

    return AnimatedSlide(
      duration: duration,
      offset: _showFab ? Offset.zero : const Offset(0, 2),
      child: AnimatedOpacity(
        duration: duration,
        opacity: _showFab ? 1 : 0,
        child: FloatingActionButton(
          onPressed: onPressed,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
