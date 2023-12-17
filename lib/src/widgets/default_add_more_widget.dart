import 'package:flutter/material.dart';

import '../multi_image_picker_controller_wrapper.dart';

class DefaultAddMoreWidget extends StatelessWidget {
  final Widget? icon;
  final Color? backgroundColor;

  const DefaultAddMoreWidget({super.key, this.icon, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final pickerView = MultiImagePickerControllerWrapper.of(context);
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: backgroundColor ??
                Theme.of(context).primaryColor.withOpacity(0.2),
            shape: const CircleBorder(),
          ),
          onPressed: pickerView.controller.pickImages,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: IconTheme(
              data: IconThemeData(
                  color: Theme.of(context).primaryColor, size: 30),
              child: icon ?? const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}
