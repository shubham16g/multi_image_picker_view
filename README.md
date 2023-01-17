# Multi Image Picker View Flutter

[![](https://img.shields.io/pub/v/multi_image_picker_view.svg?color=success&label=pub.dev&logo=dart&logoColor=0099ff)](https://pub.dev/packages/multi_image_picker_view)

A complete widget which can easily pick multiple images from device and display them in UI. Also picked image can be re-ordered and removed easily.

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
  images: <ImageFile>[] // array of pre/default selected images
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
  draggable: /* true or false, images can be reorderd by dragging by user or not, default true */,
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
controller.pickImages();
controller.hasNoImages; // return bool
controller.maxImages; // return maxImages
controller.allowedImageTypes; // return allowedImageTypes
controller.removeImage(imageFile); // remove image from the images
controller.reOrderImage(oldIndex, newIndex); // reorder the image
```

## Custom Look

![custom](https://user-images.githubusercontent.com/55009858/178099563-72e26aea-0a06-43c2-8315-25c7a0d039fb.gif)

## Contributors

<a href="https://github.com/shubham-gupta-16/multi_image_picker_view/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=shubham-gupta-16/multi_image_picker_view" />
</a>

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.


