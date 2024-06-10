import 'package:example/custom_examples.dart';
import 'package:example/picker.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class FilesCustomExample extends StatefulWidget {
  const FilesCustomExample({Key? key}) : super(key: key);

  @override
  State<FilesCustomExample> createState() => _FilesCustomExampleState();
}

class _FilesCustomExampleState extends State<FilesCustomExample> {
  final controller = MultiImagePickerController(
    maxImages: 12,
    picker: (bool allowMultiple) async {
      return await pickFilesUsingFilePicker(allowMultiple);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CustomExamples.filesCustom.name),
      ),
      body: MultiImagePickerView(
        controller: controller,
        padding: const EdgeInsets.all(10),
        builder: (context, imageFile) {
          return Stack(
            children: [
              Positioned.fill(
                  child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color.lerp(fileColor(imageFile.extension),
                      Theme.of(context).colorScheme.surface, 0.85),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 16),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        fileIcon(imageFile.extension),
                        color: fileColor(imageFile.extension),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${imageFile.name}\n",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                      )
                    ],
                  ),
                ),
              )),
              Positioned(
                  top: 4,
                  right: 4,
                  child: DraggableItemInkWell(
                    borderRadius: BorderRadius.circular(2),
                    onPressed: () => controller.removeImage(imageFile),
                    child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Theme.of(context).colorScheme.surface,
                        )),
                  )),
            ],
          );
        },
      ),
    );
  }

  IconData fileIcon(String extension) {
    switch (extension) {
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
        return Icons.file_present_rounded;
    }
  }

  Color fileColor(String extension) {
    switch (extension) {
      case "png":
      case "jpg":
      case "jpeg":
      case "svg":
      case "webp":
        return Colors.purple;
      case "pdf":
        return Colors.redAccent;
      case "mp4":
      case "mkv":
      case "wmv":
      case "avi":
      case "mov":
      case "webm":
        return Colors.orange;
      case "mp3":
      case "wav":
      case "m4a":
      case "ogg":
        return Colors.cyan;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
