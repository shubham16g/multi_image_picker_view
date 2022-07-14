import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../multi_image_picker_view.dart';

class MultiImagePickerController with ChangeNotifier {
  final List<String> allowedImageTypes;
  final int maxImages;

  MultiImagePickerController({
    this.allowedImageTypes = const ['png', 'jpeg', 'jpg'],
    this.maxImages = 10,
  });

  final List<ImageFile> _images = <ImageFile>[];
  Iterable<ImageFile> get images => _images;
  bool get hasNoImages => _images.isEmpty;

  Future<bool> pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: allowedImageTypes);
    if (result != null) {
      _addImages(result.files
          .where((e) =>
              e.extension != null &&
              allowedImageTypes.contains(e.extension?.toLowerCase()))
          .map((e) => ImageFile(
              name: e.name,
              extension: e.extension!,
              bytes: e.bytes,
              path: !kIsWeb ? e.path : null)));
      notifyListeners();
      return true;
    }
    return false;
  }

  void _addImages(Iterable<ImageFile> images) {
    int i = 0;
    while (_images.length < maxImages && images.length > i) {
      _images.add(images.elementAt(i));
      i++;
    }
  }

  void reOrderImage(int oldIndex, int newIndex, {bool notify = true}) {
    final oldItem = _images.removeAt(oldIndex);
    oldItem.size;
    _images.insert(newIndex, oldItem);
    if (notify) {
      notifyListeners();
    }
  }

  void removeImage(ImageFile imageFile) {
    _images.remove(imageFile);
    notifyListeners();
  }
}
