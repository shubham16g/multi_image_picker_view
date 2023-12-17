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
For image/file picker
```console
flutter pub add image_picker
```
OR
```console
flutter pub add file_picker
```
OR you can use any plugin to pick images/files.

### pubspec.yaml
```yaml
  multi_image_picker_view: # latest version

  image_picker: ^1.0.4
#  or
  file_picker: ^6.1.1
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
    centerWidget: Icon(Icons.image_search_outlined),
    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
    margin: EdgeInsets.zero,
  ), // Use any Widget or DefaultInitialWidget. Use null to hide initial widget
  addMoreButton: DefaultAddMoreWidget(
    icon: Icon(Icons.image_search_outlined),
    backgroundColor: Theme.of(context).colorScheme.primaryColor.withOpacity(0.2),
  ), // Use any Widget or DefaultAddMoreWidget. Use null to hide add more button.
  gridDelegate: /* Your SliverGridDelegate */,
  draggable: /* true or false, images can be reordered by dragging by user or not, default true */,
  shrinkWrap: /* true or false, to control GridView's shrinkWrap */
  longPressDelayMilliseconds: /* time to press and hold to start dragging item */
  onDragBoxDecoration: /* BoxDecoration when item is dragging */,
  padding: /* GridView padding */
  
);
```
### ImageFile
This package use `ImageFile` entity to represent one image or file. Inside `picker` method in `MultiImagePickerController`, pick your images/files and convert it to list of `ImageFile` object and then return it. The `ImageFile` consists of: 
```dart
final imageFile = ImageFile(
  UniqueKey().toString(), // A unique key required to track it in grid view.
  name: fileName,
  extension: fileExtension,
  path: fileFullPath,
);
```
> **Note:** The package have two Extension functions to convert `XFile` (`image_picker` plugin) and `PlatformFile` (`image_picker` plugin) to `ImageFile` object.
> `final imageFile = convertXFileToImageFile(xFileObject);` and `final imageFile = convertPlatformFileToImageFile(platformFileObject);`. This functions will help you to write your picker logic easily.

### ImageFileView
The `ImageFileView` is a widget which is used to display Image using `ImageFile` object. This will work on web as well as mobile platforms.
```dart
child: ImageFileView(imageFile: imageFile),
```

```dart
child: ImageFileView(
  imageFile: imageFile,
  borderRadius: BorderRadius.circular(8),
  fit: BoxFit.cover,
  backgroundColor: Theme.of(context).colorScheme.background,
  errorBuilder: (BuildContext context, Object error, StackTrace? trace) {
    return MyCustomErrorWidget(imageFile: imageFile)
  } // if errorBuilder is null, default error widget is used.
),
```

### Custom UI
**GridView Draggable item**
- In builder, you can use either `DefaultDraggableItemWidget` or your full custom Widget. i.e.
```dart
builder: (context, imageFile) {
  return Stack(
    children: [
      Positioned.fill(child: ImageFileView(imageFile: imageFile)),
      Positioned(
        top: 4,
        right: 4,
        child: DraggableItemInkWell(
          borderRadius: BorderRadius.circular(2),
          onPressed: () => controller.removeImage(imageFile),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.delete_forever_rounded,
              size: 18,
              color: Theme.of(context).colorScheme.background,
            ),
          ),
        ),
      ),
    ],
  );
},
```
- The `DraggableItemInkWell` can be used instead of `InkWell` inside `builder` to handle proper clicks when using laptop touchpads.
- `ImageFileView` is a custom widget to show the image using `ImageFile`.

**Initial Widget**
- You can use either `DefaultInitialWidget` or Custom widget or null if you don't want to show initial widget.
```dart
initialWidget: DefaultInitialWidget(
  centerWidget: Icon(Icons.image_search_outlined),
  backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
  margin: EdgeInsets.zero,
),
```
OR
```dart
initialWidget: SizedBox(
  height: 170,
  width: double.infinity,
  child: Center(
    child: ElevatedButton(
      child: const Text('Add Images'),
      onPressed: () {
        controller.pickImages();
      },
    ),
  ),
),
```
OR
```dart
initialWidget: null,
```

**Initial Widget**
- You can use either `DefaultInitialWidget` or Custom widget or null if you don't want to show initial widget.
```dart
addMoreButton: DefaultAddMoreWidget(
  icon: Icon(Icons.image_search_outlined),
  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
),
```
OR
```dart
addMoreButton: SizedBox(
  height: 170,
  width: double.infinity,
  child: Center(
    child: TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.blue.withOpacity(0.2),
        shape: const CircleBorder(),
      ),
      onPressed: controller.pickImages,
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Icon(
          Icons.add,
          color: Colors.blue,
          size: 30,
        ),
      ),
    ),
  ),
),
```
OR
```dart
addMoreButton: null,
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

## Custom Examples
> Check the example to access all the custom examples.

![custom](https://user-images.githubusercontent.com/55009858/178099563-72e26aea-0a06-43c2-8315-25c7a0d039fb.gif)

## Migrating `<1.0.0` to `>=1.0.0`

### Changes in `MultiImagePickerController`
- Inbuilt image picker is removed. You have to provide your own image/file picker logic. This will provide you more controls over image/file picking. You have to pass your `picker` in `MultiImagePickerController`.
- `allowedImageTypes` removed.
- `withData` removed.
- `withReadStream` removed.

### Changes in `MultiImagePickerView`
- `addMoreBuilder` is removed. Now use `addMoreButton` to define your custom Add More Button.
- `showAddMoreButton` is removed. To hide the default Add More Button, pass `null` in `addMoreButton` field.
- `initialContainerBuilder` is removed. Now use `initialWidget` to define your custom Initial Widget.
- `showInitialContainer` is removed. To hide the default Initial Widget, pass `null` in `initialWidget` field.
- `itemBuilder` is removed. Now use `builder` to define your custom Draggable item widget. You can now define different widget for different image (`ImaegFile`).
- `addMoreButtonTitle` is removed. Use `addMoreButton` and pass `DefaultAddMoreWidget` with custom parameters.
- `addButtonTitle` is removed. Use `initialWidget` and pass `DefaultInitialWidget` with custom parameters.
- `longPressDelayMilliseconds` is added. This is used to define the press and hold duration to start dragging.
- `onChange` is removed.
- `MultiImagePickerView.of(context)` can be used inside anywhere in MultiImagePickerView get the instance of it's components. i.e. `MultiImagePickerView.of(context).controller.pickImages()`.

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


