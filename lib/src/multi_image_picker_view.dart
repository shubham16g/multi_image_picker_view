import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:multi_image_picker_view/src/widgets/default_add_more_widget.dart';
import 'package:multi_image_picker_view/src/widgets/default_initial_widget.dart';
import 'package:multi_image_picker_view/src/widgets/default_draggable_item_widget.dart';
import 'package:multi_image_picker_view/src/multi_image_picker_controller_wrapper.dart';

import 'image_file.dart';
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
      this.initialWidget = const DefaultInitialWidget(),
      this.addMoreButton = const DefaultAddMoreWidget(),
      this.longPressDelayMilliseconds = 300,
      this.builder,
      this.onDragBoxDecoration});

  final bool draggable;
  final bool shrinkWrap;
  final int longPressDelayMilliseconds;
  final EdgeInsetsGeometry? padding;
  final SliverGridDelegate gridDelegate;
  final Widget? initialWidget;
  final Widget? addMoreButton;
  final BoxDecoration? onDragBoxDecoration;
  final Widget Function(BuildContext context, ImageFile imageFile)? builder;

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

  bool get _showAddMoreButton =>
      widget.addMoreButton != null &&
      widget.controller.images.length < widget.controller.maxImages;

  @override
  Widget build(BuildContext context) {
    return MultiImagePickerControllerWrapper(
        padding: widget.padding,
        controller: widget.controller,
        child: _build(context));
  }

  Widget _build(BuildContext context) {
    final initialWidget = widget.initialWidget;
    final addMoreButton = SizedBox(
        key: Key("${_gridViewKey}_add_btn"), child: widget.addMoreButton);
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
                  color: Theme.of(context).shadowColor.withOpacity(0.15),
                  offset: const Offset(0, 2),
                  blurRadius: 6,
                ),
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.18),
                  offset: const Offset(0, 1),
                  blurRadius: 3,
                ),
              ],
            ),
        onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
          for (final orderUpdateEntity in orderUpdateEntities) {
            widget.controller.reOrderImage(
                orderUpdateEntity.oldIndex, orderUpdateEntity.newIndex);
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
                    padding: widget.padding,
                    child: widget.builder?.call(context, imageFile) ??
                        DefaultDraggableItemWidget(
                          imageFile: imageFile,
                          fit: BoxFit.cover,
                        ),
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
