## 1.0.2
- Fixed deprecated methods and classes.

## 1.0.1
- Added support for network image at `ImageFile` class for initial selected images.
- Fixed error icon for `DefaultDraggableItemWidget`, Added file type based icon.
- Material 3: Color changes and UI improvements.
- Added Initial Images Example
- PR #31, #33, #34 merged (author:mauriziopinotti) which includes some of the changes mentioned above.

## 1.0.0
- Major Update 🚀
- Inbuilt image picker is removed. You have to provide your own image/file picker logic. This will provide you more controls over image/file picking. You have to pass your `picker` in `MultiImagePickerController`.
- `allowedImageTypes` removed form `MultiImagePickerController`.
- `withData` removed form `MultiImagePickerController`.
- `withReadStream` removed form `MultiImagePickerController`.
- `addMoreBuilder` is removed form `MultiImagePickerView`. Now use `addMoreButton` to define your custom Add More Button.
- `showAddMoreButton` is removed form `MultiImagePickerView`. To hide the default Add More Button, pass `null` in `addMoreButton` field.
- `initialContainerBuilder` is removed form `MultiImagePickerView`. Now use `initialWidget` to define your custom Initial Widget.
- `showInitialContainer` is removed form `MultiImagePickerView`. To hide the default Initial Widget, pass `null` in `initialWidget` field.
- `itemBuilder` is removed form `MultiImagePickerView`. Now use `builder` to define your custom Draggable item widget. You can now define different widget for different image (`ImaegFile`).
- `addMoreButtonTitle` is removed form `MultiImagePickerView`. Use `addMoreButton` and pass `DefaultAddMoreWidget` with custom parameters.
- `addButtonTitle` is removed form `MultiImagePickerView`. Use `initialWidget` and pass `DefaultInitialWidget` with custom parameters.
- `longPressDelayMilliseconds` is added in `MultiImagePickerView`. This is used to define the press and hold duration to start dragging.
- `onChange` is removed form `MultiImagePickerView`.
- `MultiImagePickerView.of(context)` can be used inside anywhere in MultiImagePickerView get the instance of it's components. i.e. `MultiImagePickerView.of(context).controller.pickImages()`.

## 0.0.17
- PR #27 (burhankhanzada) Replace hard coded blue color to theme primary color.

## 0.0.16
- PR #26 (nadialvy) fix addButtonTitle and addMoreButtonTitle not working

## 0.0.15
- PR #21 (MrNancy) addImage method added in `MultiImagePickerController`

## 0.0.14
- Fixed Issue #16 'Scrollable.of() ... not contains a Scrollable widget'
- Fixed Issue #17 'Add property so images can be saved with data'
- Fixed Issue #3 'imageFile returns zero byte even though it is not equal null'
- `withData` property added in `MultiImagePickerController`
- `withReadStream` property added in `MultiImagePickerController`
- `ImageFileView` widget added
- `showAddMoreButton` property added in `MultiImagePickerView`
- `showInitialContainer` property added in `MultiImagePickerView`
- Material 3 ready

## 0.0.13
- Fixed remove item animation bug

## 0.0.12
- Github pages demo project added
- maxImages 1 support

## 0.0.11
- Fixed remove image from laptop touchpad
- Improved web support

## 0.0.10
- Remove all images (clear selection)

## 0.0.9
- addButtonTitle optional field added
- addMoreButtonTitle optional field added

## 0.0.8
- Fixed issue: "Multiple widgets used the same GlobalKey"

## 0.0.7
- Added support for default images 🖼️ (pre selected images)
- Solved white flash 🔦 problem occurs on add/remove image

## 0.0.6
- 🪲 Fixed some bugs
- Fixed example publishing
- Fixed 🌐 Web Support

## 0.0.5
- Fixed 🌐 Web Support

## 0.0.4
- 🪲 Fixed some bugs
- Dependencies upgraded ⬆️
- draggable 👆 (bool) can be set
- Documentation 📃 updated

## 0.0.3
- cupertino_icons dependency removed
- Improved docs 📃
- Improved Example

## 0.0.2
- 🌐 Fixed Web Support
- Improved Example

## 0.0.1
- MultiImagePickerView created
- MultiImagePickerViewController created
- ImageFile created
