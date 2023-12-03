import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:multi_image_picker_view/src/widgets/preview_item.dart';
import 'package:multi_image_picker_view/src/multi_image_picker_controller_wrapper.dart';
import 'package:multi_image_picker_view/src/widgets/default_close_button_widget.dart';

import 'image_file.dart';
import 'widgets/multi_image_picker_add_more_button.dart';
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
      this.initialWidget = const MultiImagePickerInitialWidget.defaultWidget(),
      this.addMoreButton = const MultiImagePickerAddMoreButton.defaultButton(),
      this.onChange,
      this.longPressDelayMilliseconds = 300,
      this.builder,
      this.onDragBoxDecoration});

  final bool draggable;
  final bool shrinkWrap;
  final int longPressDelayMilliseconds;
  final EdgeInsetsGeometry? padding;
  final SliverGridDelegate gridDelegate;
  final MultiImagePickerInitialWidget initialWidget;
  final MultiImagePickerAddMoreButton addMoreButton;
  final BoxDecoration? onDragBoxDecoration;
  final Widget Function(BuildContext context, ImageFile imageFile)? builder;

  final void Function(Iterable<ImageFile>)? onChange;

  static MultiImagePickerControllerWrapper of(BuildContext context) =>
      MultiImagePickerControllerWrapper.of(context);

  @override
  State<MultiImagePickerView> createState() => _MultiImagePickerViewState();
}

class _MultiImagePickerViewState extends State<MultiImagePickerView> {
  late final ScrollController _scrollController;
  final _gridViewKey = GlobalKey();

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

  Widget _buildImageWidget(BuildContext context, ImageFile imageFile) {
    return Stack(
      clipBehavior: Clip.antiAlias,
      children: [
        Positioned.fill(
          child: PreviewItem(
            file: imageFile,
            fit: BoxFit.cover,
            defaultImageBorderRadius: BorderRadius.circular(10),
          ),
        ),
        Positioned.fill(
          child: DefaultCloseButtonWidget(
              alignment: Alignment.topRight,
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.all(3),
              onPressed: () => _deleteImage(imageFile)),
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
      onEnter:
          widget.controller.isMouse || widget.longPressDelayMilliseconds >= 300
              ? null
              : (e) {
                  setState(() {
                    widget.controller.isMouse = true;
                  });
                },
      child: ReorderableBuilder(
        scrollController: _scrollController,
        enableDraggable: widget.draggable,
        dragChildBoxDecoration: widget.onDragBoxDecoration ??
            BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 4,
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
            .map<Widget>((imageFile) => SizedBox(
                  key: Key(imageFile.key),
                  child: MultiImagePickerControllerWrapper(
                    controller: widget.controller,
                    child: widget.builder?.call(context, imageFile) ??
                        _buildImageWidget(context, imageFile),
                  ),
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
