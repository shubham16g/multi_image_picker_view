library multi_image_picker_view;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:image_picker/image_picker.dart';

class MultiImagePickerView extends StatefulWidget {
  const MultiImagePickerView(
      {Key? key,
        this.onChange,
        required this.controller,
        this.allowedImageTypes, this.maxImages = 10, this.padding})
      : super(key: key);

  final MultiImagePickerController controller;
  final Function(List<XFile>)? onChange;
  final List<ImageType>? allowedImageTypes;
  final int maxImages;
  final EdgeInsetsGeometry? padding;

  // final images = <String>[];

  @override
  State<MultiImagePickerView> createState() => _MultiImagePickerViewState();
}

class _MultiImagePickerViewState extends State<MultiImagePickerView> {
  final ImagePicker _picker = ImagePicker();
  String? error;
  bool dragging = false;
  @override
  Widget build(BuildContext context) {
    if (widget.controller.images.isEmpty) {
      return Container(
        margin: widget.padding,
        color: Colors.grey[200],
        height: 160,
        child: Center(
          child: TextButton(
            child: Text('Add Image'),
            onPressed: () {
              _pickImages();
            },
          ),
        ),
      );
    }
    final selector = GestureDetector(
      key: UniqueKey(),
      onVerticalDragDown: (_){},
      child: Container(
        child: const Center(
          child: Icon(
            Icons.add,
            size: 50,
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 1),
        ),
      ),
      onTap: () {
        _pickImages();
      },
    );

    final _scrollController = ScrollController();
    final _gridViewKey = GlobalKey();

    /*kIsWeb
      ? Image.network(
          e,
          fit: BoxFit.cover,
          key: Key(e),
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Text('No Preview'));
          },
        )
      : Image.file(
          File(e),
          key: Key(e),
          fit: BoxFit.cover,
        )
    */

    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: ReorderableBuilder(
        key: Key(_gridViewKey.toString()),
        children: widget.controller.images
            .map<Widget>((e) => _ItemView(key: UniqueKey(), file: e, onDelete: _deleteImage)).toList()
            + (widget.maxImages > widget.controller.images.length ? [selector] : []),
        // onDragStarted: () {
        //   setState(() {
        //     dragging = true;
        //   });
        // },
        // onDragEnd: () {
        //   setState(() {
        //     dragging = false;
        //   });
        // },
        scrollController: _scrollController,
        dragChildBoxDecoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        lockedIndices: [widget.controller.images.length],
        onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
          for (final orderUpdateEntity in orderUpdateEntities) {
            widget.controller._reOrderImage(
                orderUpdateEntity.oldIndex, orderUpdateEntity.newIndex);
            if (widget.onChange != null) {
              widget.onChange!(widget.controller.images);
            }
          }
        },
        longPressDelay: const Duration(milliseconds: 100),
        builder: (children) {
          return GridView(
            key: _gridViewKey,
            controller: _scrollController,
            shrinkWrap: true,
            children: children,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 160,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
          );
        },
      ),
    );
  }

  _pickImages() async {
    try {
      final List<XFile>? pickedFileList = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 100,
      );
      pickedFileList?.forEach((element) {
        print(element.mimeType);
      });
      setState(() {
        widget.controller._addImages(pickedFileList?.where((e) => _isAllowedImageType(e.mimeType)).map((e) => e) ?? [], widget.maxImages);
        error = null;
        if (widget.onChange != null) {
          widget.onChange!(widget.controller.images);
        }
      });
    } catch (e) {
      setState(() {
        error = "Some Error occur";
      });
    }
  }

  bool _isAllowedImageType(String? mimeType) {
    if (widget.allowedImageTypes == null) {
      return true;
    }
    if (mimeType == null) {
      return false;
    }
    return widget.allowedImageTypes!.contains(_getImageType(mimeType));
  }

  void _deleteImage(XFile path) {
    widget.controller._deleteImage(path);
    setState(() {
      if (widget.onChange != null) {
        widget.onChange!(widget.controller.images);
      }
    });
  }
}

class _ItemView extends StatelessWidget {
  const _ItemView({required Key key, required this.file, required this.onDelete}) : super(key: key);

  final XFile file;
  final Function(XFile path) onDelete;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      children: [
        Positioned.fill(
          child: kIsWeb
              ? Image.network(
            file.path,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Text('No Preview'));
            },
          )
              : Image.file(
            File(file.path),
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            child: Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const SizedBox(height: 20, width: 20,)),
            onTap: (){
              onDelete(file);
            },
          ),
        ),
      ],
    );
  }
}
/// MultiImagePickerController is a controller for MultiImagePicker.

class MultiImagePickerController {
  final List<XFile> _images = <XFile>[];

  List<XFile> get images => _images;

  bool get hasNoImages => _images.isEmpty;

  void _addImages(Iterable<XFile> images, int maxImage) {
    print(_images.length);
    // _images.addAll(images);
    int i = 0;
    while (_images.length < maxImage && images.length > i) {
      _images.add(images.elementAt(i));
      i++;
    }
  }

  void _reOrderImage(int oldIndex, int newIndex) {
    final oldItem = _images.removeAt(oldIndex);
    print("reorder: $oldIndex -> $newIndex");
    _images.insert(newIndex, oldItem);
  }

  void _deleteImage(XFile path) {
    _images.remove(path);
  }
}

enum ImageType {
  png,
  jpeg,
  gif,
  svg,
}

final _imageTypes = <String, ImageType>{
  'image/png': ImageType.png,
  'image/jpeg': ImageType.jpeg,
  'image/gif': ImageType.gif,
  'image/svg+xml': ImageType.svg,
};

ImageType? _getImageType(String mimeType) {
  return _imageTypes[mimeType];
}
