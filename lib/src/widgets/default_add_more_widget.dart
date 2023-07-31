import 'package:flutter/material.dart';

class DefaultAddMoreWidget extends StatelessWidget {
  final VoidCallback onPressed;
  const DefaultAddMoreWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      width: double.infinity,
      child: Center(
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
            shape: const CircleBorder(),
          ),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
