import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';

import 'preview/preview_item.dart';

import '../multi_image_picker_view.dart';

/// Widget that holds entire functionality of the [MultiImagePickerView].
class MultiImagePickerView extends StatefulWidget {
  const MultiImagePickerView(
      {Key? key,
      this.onChange,
      required this.controller,
      this.padding,
      this.initialContainerBuilder,
      this.gridDelegate,
      this.itemBuilder,
      this.addMoreBuilder,
      this.addButtonTitle,
      this.addMoreButtonTitle,
      this.draggable = true,
      this.onDragBoxDecoration})
      : super(key: key);

  final MultiImagePickerController controller;
  final bool draggable;
  final BoxDecoration? onDragBoxDecoration;
  final Widget Function(BuildContext context, Function() pickerCallback)?
      initialContainerBuilder;
  final Widget Function(BuildContext context, ImageFile file,
      Function(ImageFile) deleteCallback)? itemBuilder;

  final Widget Function(BuildContext context, Function() pickerCallback)?
      addMoreBuilder;

  final String? addButtonTitle;
  final String? addMoreButtonTitle;

  final Function(Iterable<ImageFile>)? onChange;
  final EdgeInsetsGeometry? padding;

  final SliverGridDelegate? gridDelegate;

  @override
  State<MultiImagePickerView> createState() => _MultiImagePickerViewState();
}

class _MultiImagePickerViewState extends State<MultiImagePickerView> {
  late ScrollController scrollController;
  final gridViewKey = GlobalKey();

  bool isMouse = false;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    widget.controller.addListener(updateUi);
  }

  void _pickImages() async {
    final result = await widget.controller.pickImages();
    if (!result) return;
    if (widget.onChange != null) {
      widget.onChange!(widget.controller.images);
    }
  }

  void _deleteImage(ImageFile imageFile) {
    widget.controller.removeImage(imageFile);
    if (widget.onChange != null) {
      widget.onChange!(widget.controller.images);
    }
  }

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
              clipBehavior: Clip.hardEdge,
              width: double.infinity,
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                child: Center(
                  child: Text(
                      widget.addButtonTitle == null
                          ? 'Add Images'
                          : widget.addButtonTitle!,
                      style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 16)),
                ),
                onTap: () {
                  _pickImages();
                },
              ),
            );
    }
    final selector = SizedBox(
      key: const Key("selector"),
      child: widget.addMoreBuilder != null
          ? widget.addMoreBuilder!(context, _pickImages)
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.blueGrey.withOpacity(0.07),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () {
                  _pickImages();
                },
                child: Center(
                  child: Text(
                    widget.addMoreButtonTitle == null
                        ? 'Add More'
                        : widget.addMoreButtonTitle!,
                    style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
    );

    return MouseRegion(
      onEnter: isMouse
          ? null
          : (e) {
              setState(() {
                isMouse = true;
              });
            },
      child: Padding(
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
          enableDraggable: widget.draggable,
          dragChildBoxDecoration: widget.onDragBoxDecoration ??
              BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    spreadRadius: 1,
                  ),
                ],
              ),
          lockedIndices: [widget.controller.images.length],
          onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
            debugPrint('onReorder');
            for (final orderUpdateEntity in orderUpdateEntities) {
              widget.controller.reOrderImage(
                  orderUpdateEntity.oldIndex, orderUpdateEntity.newIndex,
                  notify: false);
              if (widget.onChange != null) {
                widget.onChange!(widget.controller.images);
              }
            }
          },
          onDragStarted: () {
            debugPrint('drag started');
          },
          longPressDelay: const Duration(milliseconds: 100),
          builder: (children) {
            return GridView(
              key: gridViewKey,
              controller: scrollController,
              gridDelegate: widget.gridDelegate ??
                  const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 160,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
              children: children,
            );
          },
          children: widget.controller.images
                  .map<Widget>((e) => SizedBox(
                        key: Key(e.key),
                        child: widget.itemBuilder != null
                            ? widget.itemBuilder!(context, e, _deleteImage)
                            : PreviewItem(
                                file: e,
                                onDelete: _deleteImage,
                                isMouse: isMouse,
                              ),
                      ))
                  .toList() +
              (widget.controller.maxImages > widget.controller.images.length
                  ? [selector]
                  : []),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(MultiImagePickerView? oldWidget) {
    if (oldWidget == null) return;
    if (widget.controller != oldWidget.controller) {
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
    widget.controller.removeListener(updateUi);
    scrollController.dispose();
    super.dispose();
  }
}
