import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';

import 'list_image_item.dart';

import '../multi_image_picker_view.dart';

/// Widget that holds entire functionality of the [MultiImagePickerView].
class MultiImagePickerView extends StatefulWidget {
  const MultiImagePickerView(
      {Key? key,
      required this.controller,
      this.draggable = true,
      this.showAddMoreButton = true,
      this.showInitialContainer = true,
      this.onChange,
      this.padding,
      this.initialContainerBuilder,
      this.gridDelegate,
      this.itemBuilder,
      this.addMoreBuilder,
      this.addButtonTitle,
      this.addMoreButtonTitle,
      this.onDragBoxDecoration})
      : super(key: key);

  final MultiImagePickerController controller;
  final bool draggable;
  final bool showAddMoreButton;
  final bool showInitialContainer;
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

  Widget? _selector(BuildContext context) => widget.showAddMoreButton
      ? SizedBox(
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
                        widget.addMoreButtonTitle ?? 'Add More',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
        )
      : null;

  Widget _initialContainer(BuildContext context) => widget.showInitialContainer
      ? widget.initialContainerBuilder != null
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
                  child: Text(widget.addButtonTitle ?? 'ADD IMAGES',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16)),
                ),
                onTap: () {
                  _pickImages();
                },
              ),
            )
      : const SizedBox();

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
      return _initialContainer(context);
    }
    final selector = _selector(context);

    return Scrollable(
      viewportBuilder: (context, position) => MouseRegion(
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
                              : ListImageItem(
                                  file: e,
                                  onDelete: _deleteImage,
                                  isMouse: isMouse,
                                ),
                        ))
                    .toList() +
                (widget.controller.maxImages >
                            widget.controller.images.length &&
                        selector != null
                    ? [selector]
                    : []),
          ),
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
