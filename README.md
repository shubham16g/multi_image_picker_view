# Multi Image Picker View Flutter

[![](https://img.shields.io/pub/v/multi_image_picker_view.svg?color=blue&label=pub.dev&logo=dart&logoColor=0099ff)](https://pub.dev/packages/multi_image_picker_view)
[![](https://img.shields.io/github/issues/shubham-gupta-16/multi_image_picker_view?color=red&label=Issues)](https://github.com/shubham-gupta-16/multi_image_picker_view/issues)
[![](https://img.shields.io/github/license/shubham-gupta-16/multi_image_picker_view?label=License)]()

A complete widget which can easily pick multiple images from device and display them in UI. Also picked image can be re-ordered and removed easily.

**🚀 LIVE DEMO OF EXAMPLE PROJECT:** https://shubham-gupta-16.github.io/multi_image_picker_view/

![preview](https://user-images.githubusercontent.com/55009858/178099543-d3b576d9-625c-426e-b627-9e48c2f65c17.gif)

## Features

- Pick multiple images
- Displayed in GridView
- Reorder picked images just by dragging
- Remove picked image
- Limit max images
- Fully customizable UI

## Getting started
```console
flutter pub add multi_image_picker_view
```

## Usage

### Define the controller
```dart
final controller = MultiImagePickerController(
    picker: (bool allowMultiple) async {
      // use image_picker or file_picker to pick images `pickImages`
      final pickedImages = await pickImages(allowMultiple);
      // convert the picked image list to `ImageFile` list and return it.
      return pickedImages.map((e) => convertToImageFile(e)).toList();
    }
);
```
OR
```dart
final controller = MultiImagePickerController(
    maxImages: 15,
    images: <ImageFile>[], // array of pre/default selected images
    picker: (bool allowMultiple) async {
      return await pickConvertedImages(allowMultiple);
    },
);
```

### UI Implementation
```dart
MultiImagePickerView(
  controller: controller,
  padding: const EdgeInsets.all(10),
);
```
OR
```dart
MultiImagePickerView(
  controller: controller,
  bulder: (BuldContext context, ImageFile imageFile) {
    // here returning DefaultDraggableItemWidget. You can also return your custom widget as well.
    return DefaultDraggableItemWidget(
      imageFile: imageFile,
      boxDecoration:
        BoxDecoration(borderRadius: BorderRadius.circular(20)),
      closeButtonAlignment: Alignment.topLeft,
      fit: BoxFit.cover,
      closeButtonIcon:
        const Icon(Icons.delete_rounded, color: Colors.red),
      closeButtonBoxDecoration: null,
      showCloseButton: true,
      closeButtonMargin: const EdgeInsets.all(3),
      closeButtonPadding: const EdgeInsets.all(3),
    );
  },
  initialWidget: DefaultInitialWidget(
    centerWidget: Icon(Icons.image_search_outlined,
    color: Theme.of(context).colorScheme.secondary),
  ), // Use any Widget or DefaultInitialWidget. Use null to hide initial widget
  addMoreButton: DefaultAddMoreWidget(
    icon: Icon(Icons.image_search_outlined,
    color: Theme.of(context).colorScheme.secondary),
  ), // Use any Widget or DefaultAddMoreWidget. Use null to hide add more button.
  gridDelegate: /* Your SliverGridDelegate */,
  draggable: /* true or false, images can be reordered by dragging by user or not, default true */,
  shrinkWrap: /* true or false, to control GridView's shrinkWrap */
  longPressDelayMilliseconds: /* time to press and hold to start dragging item */
  onDragBoxDecoration: /* BoxDecoration when item is dragging */,
  padding: /* GridView padding */
  
);
```

### Get Picked Images
Picked Images can be get from controller.
```dart
final images = controller.images; // return Iterable<ImageFile>
for (final image in images) {
  if (image.hasPath)
    request.addFile(File(image.path!));
  else 
    request.addFile(File.fromRawPath(image.bytes!));
}
request.send();
```
Also controller can perform more actions.
```dart
controller.pickImages();
controller.hasNoImages; // return bool
controller.maxImages; // return maxImages
controller.removeImage(imageFile); // remove image from the images
controller.clearImages(); // remove all images (clear selection)
controller.reOrderImage(oldIndex, newIndex); // reorder the image
```

## Custom Look

![custom](https://user-images.githubusercontent.com/55009858/178099563-72e26aea-0a06-43c2-8315-25c7a0d039fb.gif)

## My other flutter packages
- <a href="https://pub.dev/packages/view_model_x">view_model_x</a> - An Android similar state management package (StateFlow and SharedFlow with ViewModel) which helps to implement MVVM pattern easily.

## Support
<p><a href="https://www.buymeacoffee.com/shubhamgupta16"> <img align="center" src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="50" width="210" alt="shubhamgupta16" /></a></p>

## Contributors
<a href="https://github.com/shubham-gupta-16/multi_image_picker_view/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=shubham-gupta-16/multi_image_picker_view" />
</a>

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.


