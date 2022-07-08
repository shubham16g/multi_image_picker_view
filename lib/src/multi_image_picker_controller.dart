library multi_image_picker_view;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import 'image_type.dart';

class MultiImagePickerController with ChangeNotifier {
  final List<ImageType> allowedImageTypes;
  final int maxImages;

  MultiImagePickerController({
    this.allowedImageTypes = const [
      ImageType.png,
      ImageType.jpeg,
      ImageType.jpg
    ],
    this.maxImages = 10,
  });

  final List<PlatformFile> _images = <PlatformFile>[];
  Iterable<PlatformFile> get images => _images;
  bool get hasNoImages => _images.isEmpty;

  Future<bool> pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions:
            allowedImageTypes.map((e) => _getExtension(e)).toList());
    if (result != null) {
      _addImages(result.files.map((e) => e));
      return true;
    }
    return false;
  }

  void _addImages(Iterable<PlatformFile> images) {
    print(_images.length);
    // _images.addAll(images);
    int i = 0;
    while (_images.length < maxImages && images.length > i) {
      _images.add(images.elementAt(i));
      i++;
    }
    notifyListeners();
  }

  void reOrderImage(int oldIndex, int newIndex) {
    final oldItem = _images.removeAt(oldIndex);
    print("reorder: $oldIndex -> $newIndex");
    _images.insert(newIndex, oldItem);
    // notifyListeners();
  }

  void deleteImage(PlatformFile path) {
    print("delete: ${_images.indexOf(path)}");
    _images.remove(path);
    notifyListeners();
  }

  final _imageTypes = <ImageType, String>{
    ImageType.png: 'png',
    ImageType.jpeg: 'jpeg',
    ImageType.jpg: 'jpg',
    ImageType.gif: 'gif',
    ImageType.svg: 'svg',
  };

  String _getExtension(ImageType mimeType) {
    return _imageTypes[mimeType]!;
  }
}


