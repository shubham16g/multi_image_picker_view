import 'package:flutter/foundation.dart';

import '../multi_image_picker_view.dart';

/// Controller for the [MultiImagePickerView].
/// This controller contains all them images that the user has selected.
class MultiImagePickerController with ChangeNotifier {
  final int maxImages;
  final Future<List<ImageFile>> Function(int imageCount, Object? params) picker;

  MultiImagePickerController(
      {this.maxImages = 10,
      required this.picker,
      Iterable<ImageFile>? images}) {
    if (images != null) {
      _images = List.from(images);
    } else {
      _images = [];
    }
  }

  late final List<ImageFile> _images;

  /// Returns [Iterable] of [ImageFile] that user has selected.
  Iterable<ImageFile> get images => _images;

  /// Set images manually.
  set images(Iterable<ImageFile> images) {
    _images.clear();
    _images.addAll(images);
    notifyListeners();
  }

  /// Returns true if user has selected no images.
  bool get hasNoImages => _images.isEmpty;

  /// manually pick images. i.e. on click on external button.
  /// this method open Image picking window.
  /// It returns [Future] of [bool], true if user has selected images.
  Future<bool> pickImages({Object? params}) async {
    if (maxImages >= _images.length) {
      return false;
    }
    final pickedImages = await picker(maxImages - _images.length, params);
    if (pickedImages.isNotEmpty) {
      _addImages(pickedImages);
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
  void reOrderImage(int oldIndex, int newIndex) {
    final oldItem = _images.removeAt(oldIndex);
    _images.insert(newIndex, oldItem);
    notifyListeners();
  }

  void updateImages(List<ImageFile> images) {
    _images.clear();
    _images.addAll(images);
    notifyListeners();
  }

  /// Add image manually.
  void addImage(ImageFile image) {
    _images.add(image);
    notifyListeners();
  }

  /// Insert image manually at index.
  void insertImage(int index, ImageFile image) {
    _images.insert(index, image);
    notifyListeners();
  }

  /// Remove image manually using index.
  void removeImageAt(int index) {
    _images.removeAt(index);
    notifyListeners();
  }

  /// Manually remove image from list.
  void removeImage(ImageFile imageFile) {
    _images.remove(imageFile);
    notifyListeners();
  }

  /// Remove all selected images and show default UI
  void clearImages() {
    _images.clear();
    notifyListeners();
  }

  bool isMouse = false;
}
