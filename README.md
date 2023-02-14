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
- Limit image extensions
- Fully customizable UI

## Getting started
```console
flutter pub add multi_image_picker_view
```

## Usage

### Define the controller
```dart
final controller = MultiImagePickerController();
```
OR
```dart
final controller = MultiImagePickerController(
  maxImages: 15,
  allowedImageTypes: ['png', 'jpg', 'jpeg'],
  withData: true,
  withReadStream: true,
  images: <ImageFile>[] // array of pre/default selected images
);
```

> **Note:** by setting `withData` to `true`, the `ImageFile` will contains `bytes`. It is always `true` for web. However, have in mind that enabling this on IO (iOS & Android) may result in out of memory issues if you allow multiple picks or pick huge files. Use withReadStream instead.

...
> **Note:** by setting `withReadStream` to `true`, the `ImageFile` will contains `readStream` of type `Stream<List<int>>`. It is always `false` for web.

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
  draggable: /* true or false, images can be reorderd by dragging by user or not, default true */,
  showAddMoreButton: /* true or false, default is true */,
  showInitialContainer: /* true or false, default is true */,
  initialContainerBuilder: (context, pickerCallback) {
    // return custom initial widget which should call the pickerCallback when user clicks on it
  },
  itemBuilder: (context, image, removeCallback) {
    // return custom card for image and remove button which also calls removeCallback on click
  },
  addMoreBuilder: (context, pickerCallback) {
    // return custom card or item widget which should call the pickerCallback when user clicks on it
  },
  addButtonTitle: /* Default title for AddButton */,
  addMoreButtonTitle: /* Default title for AddMoreButton */,
  gridDelegate: /* Your SliverGridDelegate */,
  onDragBoxDecoration: /* BoxDecoration when item is dragging */,
  onChange: (images) {
    // callback to update images
  },
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
controller.pickImages()
controller.hasNoImages // return bool
controller.maxImages // return maxImages
controller.allowedImageTypes // return allowedImageTypes
controller.removeImage(imageFile) // remove image from the images
controller.clearImages() // remove all images (clear selection)
controller.reOrderImage(oldIndex, newIndex) // reorder the image
```

### ImageFile class
The ImageFile class holds the selected image. It contains `name`, `extension`, `bytes?`, `readStream?`, and `path?`.
`path` is always null for web. And by default `bytes` is null for IO (Android and IOS). To get the `bytes` on IO devices, set `withData` to true in `MultiImagePickerController`.
However, have in mind that enabling this on IO (iOS & Android) may result in out of memory issues if you allow multiple picks or pick huge files. Use `withReadStream` instead.

The `readStream` is always null for web. And by default `readStream` is null for IO (Android and IOS). To get the `readStream` on IO devices, set `withReadStream` to true in `MultiImagePickerController`

> **Note:** For Web Platform, **ImageFile** contains `bytes` and it can't be null.

### ImageFileView widget
This widget helps to display image which is stored in `ImageFile`. This is a replacement for `Image.network` or `Image.memory` widget. With this widget, it can be easy to show image just by passing the `ImageFile` object.

```dart
ImageFileView(
  file: imageFileObject,
  fit: BoxFit.cover
)

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


