import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:multi_image_picker_view/src/widgets/default_add_more_widget.dart';
import 'package:multi_image_picker_view/src/widgets/default_close_button_widget.dart';
import 'package:multi_image_picker_view/src/widgets/default_initial_widget.dart';

import 'list_image_item.dart';

import '../multi_image_picker_view.dart';

class MultiImagePickerInitialWidget {
  final int type;
  final Widget? widget;
  final Widget Function(BuildContext context, VoidCallback pickerCallback)?
      builder;

  const MultiImagePickerInitialWidget._(this.type, this.widget, this.builder);

  const MultiImagePickerInitialWidget.defaultWidget() : this._(0, null, null);

  const MultiImagePickerInitialWidget.centerWidget({required Widget child})
      : this._(1, child, null);

  const MultiImagePickerInitialWidget.customWidget(
      {required Widget Function(
              BuildContext context, VoidCallback pickerCallback)
          builder})
      : this._(2, null, builder);

  static MultiImagePickerInitialWidget get none =>
      const MultiImagePickerInitialWidget._(-1, null, null);
}

class MultiImagePickerAddMoreButton {
  final int type;
  final Widget? widget;
  final Widget Function(BuildContext context, VoidCallback pickerCallback)?
      builder;

  const MultiImagePickerAddMoreButton._(this.type, this.widget, this.builder);

  const MultiImagePickerAddMoreButton.defaultButton() : this._(0, null, null);

  const MultiImagePickerAddMoreButton.icon({required Widget icon})
      : this._(1, icon, null);

  const MultiImagePickerAddMoreButton.customButton(
      {required Widget Function(
              BuildContext context, VoidCallback pickerCallback)
          builder})
      : this._(2, null, builder);

  static MultiImagePickerAddMoreButton get none =>
      const MultiImagePickerAddMoreButton._(-1, null, null);
}

class MultiImagePickerCloseButton {
  final BoxDecoration? boxDecoration;
  final Alignment alignment;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry? padding;

  final int type;
  final Widget? widget;
  final Widget Function(BuildContext context, VoidCallback closeCallback)?
      builder;

  const MultiImagePickerCloseButton._(this.type, this.widget, this.builder,
      this.alignment, this.margin, this.boxDecoration, this.padding);

  const MultiImagePickerCloseButton.defaultButton(
      {Alignment? alignment, EdgeInsetsGeometry? margin})
      : this._(0, null, null, alignment ?? Alignment.topRight,
            margin ?? const EdgeInsets.all(4), null, const EdgeInsets.all(3));

  const MultiImagePickerCloseButton.customIcon(
      {required Widget icon,
      Alignment? alignment,
      EdgeInsetsGeometry? margin,
      BoxDecoration? boxDecoration,
      EdgeInsetsGeometry? padding})
      : this._(
            1,
            icon,
            null,
            alignment ?? Alignment.topRight,
            margin ?? const EdgeInsets.all(4),
            boxDecoration,
            padding ?? const EdgeInsets.all(3));

  const MultiImagePickerCloseButton.customButton(
      {required Widget Function(
              BuildContext context, VoidCallback closeCallback)
          builder,
      Alignment? alignment,
      EdgeInsetsGeometry? margin})
      : this._(2, null, builder, alignment ?? Alignment.topRight,
            margin ?? const EdgeInsets.all(4), null, null);

  static MultiImagePickerCloseButton get none => const MultiImagePickerCloseButton._(
      -1, null, null, Alignment.topRight, EdgeInsets.zero, null, null);
}

class MultiImagePickerImageWidget {
  final int type;
  final BoxDecoration? boxDecoration;
  final BoxDecoration? boxDecorationOnDrag;
  final BoxFit? fit;
  final BorderRadius? borderRadius;
  final Widget Function(BuildContext context, ImageFile imageFile)? builder;

  const MultiImagePickerImageWidget._(this.type, this.fit, this.boxDecoration,
      this.boxDecorationOnDrag, this.borderRadius, this.builder);

  const MultiImagePickerImageWidget.defaultImage(
      {BorderRadius borderRadius = const BorderRadius.all(Radius.circular(10)),
      BoxFit fit = BoxFit.cover})
      : this._(0, fit, null, null, null, null);

  const MultiImagePickerImageWidget.decoratedImage(
      {BoxDecoration? boxDecoration,
      BoxDecoration? boxDecorationOnDrag,
      BoxFit fit = BoxFit.cover})
      : this._(1, fit, boxDecoration, boxDecorationOnDrag, null, null);

  const MultiImagePickerImageWidget.customImage(
      {required Widget Function(BuildContext context, ImageFile imageFile)
          builder})
      : this._(2, null, null, null, null, builder);
}

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
      this.onChange});

  final bool draggable;
  final bool shrinkWrap;
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
        return DefaultAddMoreWidget(key: ValueKey('addMoreButton'),
            onPressed: _pickImages, icon: widget.addMoreButton.widget);
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

    return Scrollable(
      viewportBuilder: (context, position) => MouseRegion(
        onEnter: _isMouse
            ? null
            : (e) {
                setState(() {
                  _isMouse = true;
                });
              },
        child: Padding(
          padding: widget.padding ?? EdgeInsets.zero,
          child: ReorderableBuilder(
            key: Key(_gridViewKey.toString()),
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
            lockedIndices:
                _showAddMoreButton ? [widget.controller.images.length] : [],
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
                key: _gridViewKey,
                shrinkWrap: widget.shrinkWrap,
                controller: _scrollController,
                gridDelegate: widget.gridDelegate,
                children: children,
              );
            },
            children: widget.controller.images
                    .map<Widget>((e) => SizedBox(
                          key: Key(e.key),
                          child: _buildImageWidget(context, e),
                        ))
                    .toList() +
                (_showAddMoreButton
                    ? [selector!]
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
