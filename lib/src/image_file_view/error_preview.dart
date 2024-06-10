import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/src/image_file.dart';

class ErrorPreview extends StatelessWidget {
  final ImageFile imageFile;
  final Color? backgroundColor;

  const ErrorPreview(
      {super.key, required this.imageFile, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIcon(),
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 4),
            Text(
              "${imageFile.name}\n",
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (imageFile.extension) {
      case "png":
      case "jpg":
      case "jpeg":
      case "svg":
      case "webp":
        return Icons.image;
      case "pdf":
        return Icons.picture_as_pdf;
      case "mp4":
      case "mkv":
      case "wmv":
      case "avi":
      case "mov":
      case "webm":
        return Icons.play_circle;
      case "mp3":
      case "wav":
      case "m4a":
      case "ogg":
        return Icons.music_note;
      default:
        return Icons.find_in_page_rounded;
    }
  }
}
