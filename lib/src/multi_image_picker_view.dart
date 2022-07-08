library multi_image_picker_view;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';

import '../multi_image_picker_view.dart';

class MultiImagePickerView extends StatefulWidget {
  const MultiImagePickerView(
      {Key? key,
      this.onChange,
      required this.controller,
      this.padding,
      this.initialContainerBuilder,
      this.gridDelegate,
      this.itemBuilder})
      : super(key: key);

  final MultiImagePickerController controller;
  final Widget Function(BuildContext context, Function() pickerCallback)?
      initialContainerBuilder;
  final Widget Function(BuildContext context, ImageFile file,
      Function(ImageFile) deleteCallback)? itemBuilder;
  final Function(Iterable<ImageFile>)? onChange;
  final EdgeInsetsGeometry? padding;

  final SliverGridDelegate? gridDelegate;

  // final images = <String>[];

  @override
  State<MultiImagePickerView> createState() => _MultiImagePickerViewState();
}

class _MultiImagePickerViewState extends State<MultiImagePickerView> {
  @override
  Widget build(BuildContext context) {
    if (widget.controller.hasNoImages) {
      return widget.initialContainerBuilder != null
          ? widget.initialContainerBuilder!(context, _pickImages)
          : Container(
              margin: widget.padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.blueGrey.withOpacity(0.05),

              ),
              height: 160,
              width: double.infinity,
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: TextButton(
                  child: const Text('Add Images'),
                  onPressed: () {
                    _pickImages();
                  },
                ),
              ),
      );
    }
    final selector = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.blueGrey.withOpacity(0.07),
      ),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: TextButton(
          onPressed: () {

            _pickImages();
          },
          child: const Text(
            'Add More',
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
      ),
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
            gridDelegate: widget.gridDelegate ?? const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 160,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            children: children,
          );
        },
        children: widget.controller.images
                .map<Widget>((e) => SizedBox(
                      key: UniqueKey(),
                      child: widget.itemBuilder != null
                          ? widget.itemBuilder!(context, e, _deleteImage)
                          : _ItemView(file: e, onDelete: _deleteImage),
                    ))
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

  void _deleteImage(ImageFile path) {
    print('delete init');
    widget.controller.deleteImage(path);
    if (widget.onChange != null) {
      widget.onChange!(widget.controller.images);
    }
  }

  @override
  void initState() {
    super.initState();
    print('initState');
    widget.controller.addListener(updateUi);
  }


  @override
  void didUpdateWidget(MultiImagePickerView? oldWidget) {
    print('didUpdateWidget');
    if (oldWidget == null) return;
    if (widget.controller != oldWidget.controller) {
      print('trying update');
      _migrate(widget.controller, oldWidget.controller, updateUi);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _migrate(Listenable a, Listenable b, void Function() listener) {
    b.removeListener(listener);
    a.addListener(listener);

  }

  void updateUi() {
    setState(() {});
  }

  @override
  void dispose() {
    print('dispose');
    widget.controller.removeListener(updateUi);
    super.dispose();
  }
}

class _ItemView extends StatelessWidget {
  const _ItemView({Key? key, required this.file, required this.onDelete})
      : super(key: key);

  final ImageFile file;
  final Function(ImageFile path) onDelete;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      children: [
        Positioned.fill(
          child: !file.hasPath
              ? Image.memory(
                  file.bytes,
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
          child: InkWell(
            excludeFromSemantics: true,
            onLongPress: () {
            },
            child: Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 20,)),
            onTap: (){
              onDelete(file);
            },
          ),
        ),
      ],
    );
  }
}