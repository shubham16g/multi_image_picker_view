import 'package:flutter/material.dart';

import '../multi_image_picker_controller_wrapper.dart';

class DefaultInitialWidget extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final Widget? centerWidget;
  final Color? backgroundColor;

  const DefaultInitialWidget(
      {super.key, this.centerWidget, this.margin, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final pickerView = MultiImagePickerControllerWrapper.of(context);
    return Container(
      margin: margin ?? pickerView.padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: backgroundColor ??
            Theme.of(context).colorScheme.secondary.withOpacity(0.05),
      ),
      height: 160,
      clipBehavior: Clip.hardEdge,
      width: double.infinity,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: pickerView.controller.pickImages,
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
