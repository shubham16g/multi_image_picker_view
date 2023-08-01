import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:multi_image_picker_view/src/widgets/default_add_more_widget.dart';
import 'package:multi_image_picker_view/src/widgets/default_close_button_widget.dart';
import 'package:multi_image_picker_view/src/widgets/default_initial_widget.dart';

import 'image_file.dart';
import 'list_image_item.dart';
import 'multi_image_picker_components.dart';
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
      this.onChange, this.longPressDelayMilliseconds = 200});

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

  Widget? _selector(BuildContext context) {
    switch (widget.addMoreButton.type) {
      case -1:
        return null;
      case 2:
        return widget.addMoreButton.builder!(context, _pickImages);
      default:
        return DefaultAddMoreWidget(
            key: const ValueKey('mipAddMoreButton'),
            onPressed: _pickImages,
            icon: widget.addMoreButton.widget);
    }
  }

  Widget? _initialContainer(BuildContext context) {
    switch (widget.initialWidget.type) {
      case -1:
        return null;
      case 2:
        return widget.initialWidget.builder!(context, _pickImages);
      default:
        return DefaultInitialWidget(
            margin: widget.padding,
            onPressed: _pickImages,
            centerWidget: widget.initialWidget.widget);
    }
  }

  Widget? _closeButton(BuildContext context, VoidCallback onPressed) {
    switch (widget.closeButton.type) {
      case -1:
        return null;
      case 2:
        return widget.closeButton.builder!(context, _pickImages);
      default:
        return DefaultCloseButtonWidget(
          onPressed: onPressed,
          boxDecoration: widget.closeButton.boxDecoration,
          icon: widget.closeButton.widget,
          isMouse: _isMouse,
          margin: widget.closeButton.margin,
          padding: widget.closeButton.padding!,
          alignment: widget.closeButton.alignment,
        );
    }
  }

  Widget _buildImageWidget(BuildContext context, ImageFile imageFile) {
    switch (widget.imageWidget.type) {
      case 2:
        return widget.imageWidget.builder!(context, imageFile);
      default:
        return PreviewItem(
          file: imageFile,
          fit: widget.imageWidget.fit!,
          boxDecoration: widget.imageWidget.boxDecoration,
          closeButtonWidget:
              _closeButton(context, () => _deleteImage(imageFile)),
          defaultImageBorderRadius: widget.imageWidget.borderRadius,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final initialContainer = _initialContainer(context);
    final selector = _selector(context);
    if (widget.controller.hasNoImages) {
      if (initialContainer == null) return const SizedBox();
      if (!widget.shrinkWrap) {
        return Column(children: [initialContainer]);
      }
      return initialContainer;
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

        longPressDelay: Duration(milliseconds: widget.longPressDelayMilliseconds),
        builder: (children) {
          return GridView(
            key: _gridViewKey,
            shrinkWrap: widget.shrinkWrap,
            controller: _scrollController,
            padding: widget.padding ?? EdgeInsets.zero,
            gridDelegate: widget.gridDelegate,
            children: children + [if (_showAddMoreButton) selector!],
          );
        },
        children: widget.controller.images
                .map<Widget>((e) => SizedBox(
                      key: Key(e.key),
                      child: _buildImageWidget(context, e),
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
