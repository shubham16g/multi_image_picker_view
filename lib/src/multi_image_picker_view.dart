library multi_image_picker_view;

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';

import '../multi_image_picker_view.dart';


class MultiImagePickerView extends StatefulWidget {
  const MultiImagePickerView(
      {Key? key,
      this.onChange,
      required this.controller,
      this.padding})
      : super(key: key);

  final MultiImagePickerController controller;
  final Function(Iterable<PlatformFile>)? onChange;
  final EdgeInsetsGeometry? padding;

  // final images = <String>[];

  @override
  State<MultiImagePickerView> createState() => _MultiImagePickerViewState();
}

class _MultiImagePickerViewState extends State<MultiImagePickerView> {
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            size: 50,
          ),
        ),
      ),
      onTap: () {
        _pickImages();
      },
    );

    final scrollController = ScrollController();
    final gridViewKey = GlobalKey();

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
        key: Key(gridViewKey.toString()),
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
        scrollController: scrollController,
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
            widget.controller.reOrderImage(
                orderUpdateEntity.oldIndex, orderUpdateEntity.newIndex);
            if (widget.onChange != null) {
              widget.onChange!(widget.controller.images);
            }
          }
        },
        longPressDelay: const Duration(milliseconds: 100),
        builder: (children) {
          return GridView(
            key: gridViewKey,
            controller: scrollController,
            shrinkWrap: true,
            children: children,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 160,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
          );
        },
        children: widget.controller.images
                .map<Widget>((e) => _ItemView(
                    key: UniqueKey(), file: e, onDelete: _deleteImage))
                .toList() +
            (widget.controller.maxImages > widget.controller.images.length
                ? [selector]
                : []),
      ),
    );
  }

  _pickImages() async {
    final result = await widget.controller.pickImages();
    if (!result) return;
    if (widget.onChange != null) {
      widget.onChange!(widget.controller.images);
    }
  }

  void _deleteImage(PlatformFile path) {
    print('delete init');
    widget.controller.deleteImage(path);
    if (widget.onChange != null) {
      widget.onChange!(widget.controller.images);
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(updateUi);
  }

  void updateUi() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(updateUi);
    super.dispose();
  }
}

class _ItemView extends StatelessWidget {
  const _ItemView(
      {required Key key, required this.file, required this.onDelete})
      : super(key: key);

  final PlatformFile file;
  final Function(PlatformFile path) onDelete;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      children: [
        Positioned.fill(
          child: kIsWeb
              ? Image.memory(
                  file.bytes!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Text('No Preview'));
                  },
                )
              : Image.file(
                  File(file.path!),
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