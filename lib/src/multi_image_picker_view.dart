import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';

import 'image_file.dart';
import 'widgets/multi_image_picker_add_more_button.dart';
import 'widgets/multi_image_picker_close_button.dart';
import 'widgets/multi_image_picker_image_widget.dart';
import 'widgets/multi_image_picker_initial_widget.dart';
import 'multi_image_picker_controller.dart';

/// Widget that holds entire functionality of the [MultiImagePickerView].
class MultiImagePickerView extends StatefulWidget {
  final MultiImagePickerController controller;

  const MultiImagePickerView(
      {super.key,
      required this.controller,
      this.draggable = true,
      this.shrinkWrap = false,
      this.gridDelegate = const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 160,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      this.padding,
      this.imageWidget = const MultiImagePickerImageWidget.defaultImage(),
      this.initialWidget = const MultiImagePickerInitialWidget.defaultWidget(),
      this.addMoreButton = const MultiImagePickerAddMoreButton.defaultButton(),
      this.closeButton = const MultiImagePickerCloseButton.defaultButton(),
      this.onChange,
      this.longPressDelayMilliseconds = 200});

  final bool draggable;
  final bool shrinkWrap;
  final int longPressDelayMilliseconds;
  final EdgeInsetsGeometry? padding;
  final SliverGridDelegate gridDelegate;
  final MultiImagePickerImageWidget imageWidget;
  final MultiImagePickerInitialWidget initialWidget;
  final MultiImagePickerAddMoreButton addMoreButton;
  final MultiImagePickerCloseButton closeButton;

  final void Function(Iterable<ImageFile>)? onChange;

  @override
  State<MultiImagePickerView> createState() => _MultiImagePickerViewState();
}

class _MultiImagePickerViewState extends State<MultiImagePickerView> {
  late final ScrollController _scrollController;
  final _gridViewKey = GlobalKey();
  bool _isMouse = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    widget.controller.addListener(_updateUi);
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

  bool get _showAddMoreButton =>
      widget.addMoreButton.type != -1 &&
      widget.controller.images.length < widget.controller.maxImages;

  Widget _buildImageWidget(
      BuildContext context, Widget? closeButtonWidget, ImageFile imageFile) {
    return Stack(
      key: Key(imageFile.key),
      clipBehavior: Clip.antiAlias,
      children: [
        Positioned.fill(
          child: widget.imageWidget.getWidget(context, imageFile),
        ),
        if (closeButtonWidget != null)
          Positioned.fill(
            child: closeButtonWidget,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final initialWidget =
        widget.initialWidget.getWidget(context, widget.padding, _pickImages);
    final addMoreButton = SizedBox(
        key: Key("${_gridViewKey}_add_btn"),
        child: widget.addMoreButton.getWidget(context, _pickImages));
    if (widget.controller.hasNoImages) {
      if (initialWidget == null) return const SizedBox();
      if (!widget.shrinkWrap) {
        return Column(children: [initialWidget]);
      }
      return initialWidget;
    }

    return MouseRegion(
      onEnter: _isMouse || widget.longPressDelayMilliseconds >= 200
          ? null
          : (e) {
              setState(() {
                _isMouse = true;
              });
            },
      child: ReorderableBuilder(
        scrollController: _scrollController,
        enableDraggable: widget.draggable,
        dragChildBoxDecoration: widget.imageWidget.boxDecorationOnDrag ??
            BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 3,
                  spreadRadius: 1,
                ),
              ],
            ),
        onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
          for (final orderUpdateEntity in orderUpdateEntities) {
            widget.controller.reOrderImage(
                orderUpdateEntity.oldIndex, orderUpdateEntity.newIndex);
            if (widget.onChange != null) {
              widget.onChange!(widget.controller.images);
            }
          }
        },
        longPressDelay:
            Duration(milliseconds: widget.longPressDelayMilliseconds),
        builder: (children) {
          return GridView(
            key: _gridViewKey,
            shrinkWrap: widget.shrinkWrap,
            controller: _scrollController,
            padding: widget.padding ?? EdgeInsets.zero,
            gridDelegate: widget.gridDelegate,
            children: children + [if (_showAddMoreButton) addMoreButton],
          );
        },
        children: widget.controller.images
            .map<Widget>((e) => SizedBox(
                  key: Key(e.key),
                  child: _buildImageWidget(
                      context,
                      widget.closeButton
                          .getWidget(context, _isMouse, () => _deleteImage(e)),
                      e),
                ))
            .toList(),
      ),
    );
  }

  @override
  void didUpdateWidget(MultiImagePickerView? oldWidget) {
    if (oldWidget == null) return;
    if (widget.controller != oldWidget.controller) {
      _migrate(widget.controller, oldWidget.controller, _updateUi);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _migrate(Listenable a, Listenable b, void Function() listener) {
    b.removeListener(listener);
    a.addListener(listener);
  }

  void _updateUi() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateUi);
    _scrollController.dispose();
    super.dispose();
  }
}
