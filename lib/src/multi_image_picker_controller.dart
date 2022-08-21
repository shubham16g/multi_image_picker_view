import 'package:flutter/foundation.dart';

import '../multi_image_picker_view.dart';

/// Controller for the [MultiImagePickerView].
/// This controller contains all them images that the user has selected.
class MultiImagePickerController with ChangeNotifier {
  final int maxImages;
  final Future<List<ImageFile>> Function() pickerBuilder;

  MultiImagePickerController({
    required this.pickerBuilder,
    this.maxImages = 10,
  }) {
    print('init');
  }

  final List<ImageFile> _images = <ImageFile>[];

  /// Returns [Iterable] of [ImageFile] that user has selected.
  Iterable<ImageFile> get images => _images;

  /// Returns true if user has selected no images.
  bool get hasNoImages => _images.isEmpty;

  /// manually pick images. i.e. on click on external button.
  /// this method open Image picking window.
  /// It returns [Future] of [bool], true if user has selected images.
  Future<bool> pickImages() async {
    final images = await pickerBuilder();
    /*FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg']);*/
    if (images.isNotEmpty) {
      _addImages(images);
      /*_addImages(result.files
          .map((e) => ImageFile(
              name: e.name,
              extension: e.extension!,
              bytes: e.bytes,
              path: !kIsWeb ? e.path : null)));*/
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

  /// Manually re-order image, i.e. move image from one position to another position.
  void reOrderImage(int oldIndex, int newIndex, {bool notify = true}) {
    final oldItem = _images.removeAt(oldIndex);
    oldItem.size;
    _images.insert(newIndex, oldItem);
    if (notify) {
      notifyListeners();
    }
  }

  /// Manually remove image from list.
  void removeImage(ImageFile imageFile) {
    _images.remove(imageFile);
    notifyListeners();
  }

  @override
  void dispose() {
    print(_images);
    print('dispose');
    super.dispose();
    print(_images);
  }
}

