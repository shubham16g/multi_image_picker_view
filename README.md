# Multi Image Picker View Flutter

A complete widget which can easily pick multiple images from device and display them in UI. Also picked image can be re-ordered and removed easily.

![preview](https://user-images.githubusercontent.com/55009858/178099543-d3b576d9-625c-426e-b627-9e48c2f65c17.gif)
![custom](https://user-images.githubusercontent.com/55009858/178099563-72e26aea-0a06-43c2-8315-25c7a0d039fb.gif)


## Features

- Pick Multiple Images
- Displayed in GridView
- Reorder Picked Images just by Dragging
- Remove Picked Image
- Limit max images
- Limit image extenstion
- Fully Customizable UI

## Getting started
```
flutter pub add multi_image_picker_view
```

## Usage

### Define the controller
```
final controller = MultiImagePickerController();
```
OR
```
final controller = MultiImagePickerController(
  maxImages: 15,
  allowedImageTypes: ['png', 'jpg', 'jpeg'],
);
```

### UI Implementation
```
MultiImagePickerView(
  controller: controller,
  padding: const EdgeInsets.all(10),
)
```
OR
```
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
  gridDelegate: /* Your SliverGridDelegate */,
  dragChildBoxDecoration: /* BoxDecoration when item is dragging */,
  onChange: (images) {
    // callback to update images
  },
);
```

### Get Picked Images
Picked Images can be get from controller.
```
final images = controller.images; // return Iterable<ImageFile>
for (final image in images) {
  if (image.hasPath)
    request.addFile(File(image.path!));
  else 
    request.addFile(File.fromRawPath(image.bytes!));
}
request.send();
```
Also contoller can perform more actions.
```
controller.pickImages();
controller.hasNoImages; // return bool
controller.maxImages; // return maxImages
controller.allowedImageTypes; // return allowedImageTypes
controller.removeImage(imageFile); // remove image from the images
controller.reOrderImage(oldIndex, newIndex); // reorder the image
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.


