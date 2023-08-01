import 'package:flutter/material.dart';

class DefaultInitialWidget extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final Widget? centerWidget;
  final VoidCallback onPressed;

  const DefaultInitialWidget(
      {super.key,
      required this.margin,
      this.centerWidget,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.blueGrey.withOpacity(0.05),
      ),
      height: 160,
      clipBehavior: Clip.hardEdge,
      width: double.infinity,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onPressed,
        child: Center(
          child: centerWidget ??
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_photo_alternate_outlined,
                      size: 30, color: Theme.of(context).primaryColor),
                  const SizedBox(height: 4),
                  Text('ADD IMAGES',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14))
                ],
              ),
        ),
      ),
    );
  }
}
