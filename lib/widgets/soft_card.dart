import 'package:flutter/material.dart';

class SoftCard extends StatelessWidget {
  final Widget child;

  const SoftCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.purple.withOpacity(0.1),
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
