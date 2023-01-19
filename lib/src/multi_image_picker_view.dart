import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';

import 'preview_item.dart';

import '../multi_image_picker_view.dart';

/// Widget that holds entire functionality of the [MultiImagePickerView].
class MultiImagePickerView extends StatefulWidget {
  final MultiImagePickerController controller;

  const MultiImagePickerView(
      {super.key,
      required this.controller,
      this.draggable = true,
      this.shrinkWrap = false,
      this.crossAxisSpacing = 10,
      this.mainAxisSpacing = 10,
      this.imageMaxWidthExtent = 160,
      this.imageAspectRatio = 1,
      this.imageBoxFit = BoxFit.cover,
      this.imageBoxDecoration,
      this.imageBoxDecorationOnDrag,
      this.closeButtonIcon,
      this.closeButtonBoxDecoration,
      this.closeButtonAlignment = Alignment.topRight,
      this.closeButtonMargin = const EdgeInsets.all(4),
      this.closeButtonPadding = const EdgeInsets.all(3),
      this.showCloseButton = true,
      this.showAddMoreButton = true,
      this.showInitialContainer = true,
      this.padding,
      this.defaultImageBorderRadius = 4,
      this.defaultInitialContainerCenterWidget,
      this.initialContainerBuilder,
      this.addMoreButtonBuilder,
      this.onChange});

  final bool draggable;
  final bool shrinkWrap;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double imageMaxWidthExtent;
  final double imageAspectRatio;
  final BoxFit imageBoxFit;
  final BoxDecoration? imageBoxDecoration;
  final BoxDecoration? imageBoxDecorationOnDrag;
  final Widget? closeButtonIcon;
  final BoxDecoration? closeButtonBoxDecoration;
  final Alignment closeButtonAlignment;
  final EdgeInsetsGeometry closeButtonMargin;
  final EdgeInsetsGeometry closeButtonPadding;
  final bool showCloseButton;
  final bool showAddMoreButton;
  final bool showInitialContainer;
  final EdgeInsetsGeometry? padding;
  final int defaultImageBorderRadius;
  final Widget? defaultInitialContainerCenterWidget;
  final Widget Function(BuildContext context, VoidCallback pickerCallback)?
      initialContainerBuilder;
  final Widget Function(BuildContext context, VoidCallback pickerCallback)?
      addMoreButtonBuilder;
  final void Function(Iterable<ImageFile>)? onChange;

  @override
  State<MultiImagePickerView> createState() => _MultiImagePickerViewState();
}

class _MultiImagePickerViewState extends State<MultiImagePickerView> {
  late final ScrollController _scrollController;
  late final Widget? _selector;
  late final Widget? _initialContainer;

  final _gridViewKey = GlobalKey();
  bool _isMouse = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    widget.controller.addListener(_updateUi);

    _selector = widget.showAddMoreButton
        ? SizedBox(
            key: const Key("selector"),
            child: widget.addMoreButtonBuilder != null
                ? widget.addMoreButtonBuilder!(context, _pickImages)
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
                      child: const Center(
                        child: Text(
                          'Add More',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
          )
        : null;

    _initialContainer = widget.showInitialContainer
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
                    child: widget.defaultInitialContainerCenterWidget ??
                        const Text('ADD IMAGES',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                                fontSize: 16)),
                  ),
                  onTap: () {
                    _pickImages();
                  },
                ),
              )
        : null;
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
      if (_initialContainer == null) return const SizedBox();
      if (!widget.shrinkWrap){
        return Column(children: [_initialContainer!]);
      }
      return _initialContainer!;
    }

    return MouseRegion(
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
          enableDraggable: widget.draggable,
          dragChildBoxDecoration: widget.imageBoxDecorationOnDrag ??
              BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    spreadRadius: 1,
                  ),
                ],
              ),
          lockedIndices: (widget.showAddMoreButton &&
                  widget.controller.images.length < widget.controller.maxImages)
              ? [widget.controller.images.length]
              : [],
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
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: widget.imageMaxWidthExtent,
                  childAspectRatio: widget.imageAspectRatio,
                  crossAxisSpacing: widget.crossAxisSpacing,
                  mainAxisSpacing: widget.mainAxisSpacing),
              children: children,
            );
          },
          children: widget.controller.images
                  .map<Widget>((e) => SizedBox(
                        key: Key(e.key),
                        child: PreviewItem(
                          file: e,
                          fit: widget.imageBoxFit,
                          closeButtonMargin: widget.closeButtonMargin,
                          closeButtonPadding: widget.closeButtonPadding,
                          closeButtonIcon: widget.closeButtonIcon,
                          boxDecoration: widget.imageBoxDecoration,
                          closeButtonBoxDecoration:
                              widget.closeButtonBoxDecoration,
                          closeButtonAlignment: widget.closeButtonAlignment,
                          showCloseButton: widget.showCloseButton,
                          onDelete: _deleteImage,
                          isMouse: _isMouse,
                        ),
                      ))
                  .toList() +
              (widget.controller.maxImages > widget.controller.images.length &&
                      _selector != null
                  ? [_selector!]
                  : []),
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
