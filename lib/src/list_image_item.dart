import 'package:flutter/material.dart';
import './image_file_view/image_file_view.dart';
import 'image_file.dart';

class ListImageItem extends StatelessWidget {
  const ListImageItem(
      {Key? key,
      required this.file,
      required this.onDelete,
      required this.isMouse})
      : super(key: key);

  final ImageFile file;
  final bool isMouse;
  final Function(ImageFile path) onDelete;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      children: [
        Positioned.fill(
          child: ImageFileView(
            file: file,
          ),
        ),
        const Positioned.fill(child: AbsorbPointer()),
        Positioned(
          right: 0,
          top: 0,
          child: InkWell(
            onTap: isMouse
                ? null
                : () {
                    onDelete(file);
                  },
            onTapDown: isMouse
                ? (d) {
                    onDelete(file);
                  }
                : null,
            child: Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/close-48.png',
                  package: 'multi_image_picker_view',
                  height: 18,
                  width: 18,
                )),
          ),
        ),
      ],
    );
  }
}
