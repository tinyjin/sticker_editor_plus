## 1.1.2

- Fix correct sticker dragging behavior [[issue](https://github.com/tinyjin/sticker_editor_plus/issues/7)]
- Up-to-date dependencies

## 1.1.1

- Remove `isNetwork` from `PictureModel`
- Display pictures from network or local assets correctly by detecting the URL

## 1.1.0

Support custom controller Icons. [[issue](https://github.com/tinyjin/sticker_editor_plus/issues/1)]

- [Widget] Introduced props: `resizeIcon`, `rotateIcon`, `closeIcon` and `editIcon` [[patch](https://github.com/tinyjin/sticker_editor_plus/pull/2)]

```dart
// Skip the parameters to set default Icon

StickerEditingView(
  rotateIcon: const Icon(Icons.heart_broken),
  closeIcon: const Icon(Icons.star),
  rotateIcon: const Icon(Icons.rectangle),
  editIcon: const Icon(Icons.edit),
)

StickerEditingBox(
  rotateIcon: const Icon(Icons.heart_broken),
  closeIcon: const Icon(Icons.star),
  rotateIcon: const Icon(Icons.rectangle),
)

TextEditingBox(
  rotateIcon: const Icon(Icons.heart_broken),
  closeIcon: const Icon(Icons.star),
  rotateIcon: const Icon(Icons.rectangle),
)
```

## 1.0.0
This library was originally created by Harsh Radadiya.

Initial release based on original repository, including a few enhancements.


- [Widget] Introduced props: `viewOnly`, `onSave`, `texts`, `pictures` and `backgroundColor`.
- [Widget] Introduced custom controller designing interfaces.
- [Model] Introduced JSON DTO for `PictureModel` and `TextModel`.
- [Model] TextModel: `angle` to set custom rotation.
- [Flutter] Upgraded versions of kotlin, flutter/dart and internal dependencies.
- [Bug] Fixed `'delta' isn't defined`. [[Issue](https://github.com/Harsh-Radadiya/sticker_editor/issues/4)]
