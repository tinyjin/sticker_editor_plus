# Sticker Editor
[![pub package](https://img.shields.io/pub/v/sticker_editor_plus.svg)](https://pub.dev/packages/sticker_editor_plus)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)


A flutter plugin for Android, Apple System and Web for Rotate, Scaling, Moving and Editing Text, Photo, Stickers.

- 🎯 Drag to move
- 📏 Bound movement area
- 👆 Custom onTap / onCancel
- 🔍 Pinch to scale & rotate
- 🛠️ Customizable UI & icons
- 🧩 Use as full screen or widget
- 💾 JSON serialization

<p align="center">
  <img src="https://github.com/tinyjin/sticker_editor/raw/master/assets/readme/demo.gif" alt="demo" />
</p>

<br>

| Text Editor                                                                                     |                                                                                                      Image Editor |
| -------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| ![](https://github.com/tinyjin/sticker_editor/raw/master/assets/readme/text_editor_box.png) | ![](https://github.com/tinyjin/sticker_editor/raw/master/assets/readme/sticker_editor_box.png) |

<br>

<br>

| Text Box                                                                                  | Image Box                                                                                  |
| -------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| ![](https://github.com/tinyjin/sticker_editor/raw/master/assets/readme/only_text.png) | ![](https://github.com/tinyjin/sticker_editor/raw/master/assets/readme/only_picture.png) |

<br>
 

A flutter package Sticker Editor which will help you to create editable and scalable text or sticker widget that can be dragged around the area you given in screen.


## Installation

First, add `sticker_editor_plus` as a [dependency in your pubspec.yaml file](https://flutter.dev/using-packages/).

```sh
flutter pub add sticker_editor_plus
```

### MacOS
Fore NetworkImage, macOS needs you to request a specific entitlement in order to access the network. To do that open macos/Runner/DebugProfile.entitlements and add the following key-value pair.
```xml
<key>com.apple.security.network.client</key>
<true/>
```

## Basic Usage

### 1. Sticker View (Text + Picture)

```Dart
StickerEditingView(
  height: 300,
  width: 300,
  child: targetWidget,
  fonts: fonts,
  palletColor: colorPallet,
  useColorPicker: true,
  assetList: stickerList,
  texts: texts, // Texts to be shown in the Sticker Editor
  pictures: pictures, // Pictures to be shown in the Sticker Editor
),
```

#### Customize Default Placement (Optional)

```Dart
final size = MediaQuery.of(context).size;

StickerEditingView(
  height: 300,
  width: 300,
  child: targetWidget,
  fonts: fonts,
  palletColor: colorPallet,
  useColorPicker: true,
  assetList: stickerList,
  defaultPlacement: StickerPlacement(
    position: Offset(size.width / 2 - 60, size.height / 2 - 20),
    scale: 1.1,
    rotation: 0.1,
  ),
),
```

### 2. Text Editing Box
```Dart
Container(
  height: 300,
  width: 300,
  color: Colors.blue,
  child: Stack(
    children: [
      StickerWidget(
        boundHeight: 200,
        boundWidth: 100,
        isSelected: true,
        data: TextModel(
            name: 'Text EditingBox',
            textStyle:
                GoogleFonts.pacifico(fontSize: 25, color: Colors.white),
            top: top,
            isSelected: true,
            textAlign: TextAlign.center,
            scale: 1,
            left: left),
      ),
    ],
  ),
),
```

### 3. Picture Editing Box
```Dart
Container(
  height: 300,
  width: 300,
  color: Colors.blue,
  child: Stack(
    children: [
      StickerWidget(
          boundHeight: 200,
          boundWidth: 200,
          data: PictureModel(
            isSelected: false,
            left: 50,
            top: 50,
            scale: 1,
            stringUrl: 'https://github.com/tinyjin/sticker_editor_plus/blob/main/example/assets/t-shirt.jpeg?raw=true',
          )),
    ],
  ),
)

```
### 4. Prevent User Interaction (view only mode)

Users will not be able to move, rotate, or resize stickers or text—they will only be able to view them.

This is useful in situations where you want to show a preview or a finalized image, such as when reviewing a design before saving or sharing, or when you want to prevent further editing by the user.

```dart
StickerEditingView(
  height: 300,
  width: 300,
  texts: texts,
  pictures: pictures,
  // ...
  viewOnly: true,
),
```

### 5. Custom Controls (hide default buttons)

Hide the built-in bottom control bar and trigger actions from your own buttons.
Calling `save()` will invoke `onSave` with the latest texts and pictures.

```dart
final editorKey = GlobalKey();

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        StickerEditingView(
          key: editorKey,
          showControl: false,
          height: 300,
          width: 300,
          child: targetWidget,
          fonts: fonts,
          palletColor: colorPallet,
          assetList: stickerList,
          texts: texts,
          pictures: pictures,
          onSave: (editedTexts, editedPictures) {
            // Handle save.
          },
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () =>
                    (editorKey.currentState as dynamic).addText(),
                child: const Text('Add Text'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () =>
                    (editorKey.currentState as dynamic).addSticker(),
                child: const Text('Add Sticker'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () =>
                    (editorKey.currentState as dynamic).save(),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
```

### 6. Custom Add UI (text/sticker)

Provide optional callbacks to render your own UI for adding text or picking a sticker.
The same text callback is used when editing existing text content (not formatting).
Return `null` to cancel.

```dart
StickerEditingView(
  // ...
  onTextAddRequest: (context, payload) async {
    final controller = TextEditingController(text: payload.defaultText);
    final text = await showModalBottomSheet<String?>(
      context: context,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: controller, autofocus: true),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pop(sheetContext, controller.text.trim()),
                child: const Text('Add'),
              ),
            ],
          ),
        );
      },
    );
    if (text == null) return null;
    return TextAddResult(text);
  },
  onStickerPickRequest: (context, payload) async {
    final picked = await showDialog<String?>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: payload.assets.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemBuilder: (_, index) {
              final asset = payload.assets[index];
              final isNetwork = asset.startsWith('http');
              return InkWell(
                onTap: () => Navigator.pop(dialogContext, asset),
                child: isNetwork
                    ? Image.network(asset)
                    : Image.asset(asset),
              );
            },
          ),
        );
      },
    );
    return picked;
  },
)
```

### 7. Sticker Data Serialization

Text (`TextModel`) and image (`PictureModel`) data used in the sticker editor can be serialized and deserialized to/from JSON format.  
This feature allows you to save user-created designs, send them to a server, or reload them to continue editing.

#### 7-1. TextModel/PictureModel Serialization

```dart
StickerEditingView(
  // Called when the user completes editing and presses the Save button
  onSave: (List<TextModel> editedTexts, List<PictureModel> editedPictures) async {
    // Serialize edited data to JSON
    await _saveDesignToStorage(editedTexts, editedPictures);
    
    Map<String, dynamic> designData = {
      'texts': texts.map((text) => text.toJson()).toList(),
      'pictures': pictures.map((picture) => picture.toJson()).toList(),
    };

    // Save to server or LocalStorage as needed
    print(designData);
  },
);
```

#### 7-2. Text & Picture Restoration

```dart
Future<void> _loadSavedDesign() async {
   Map<String, dynamic> designData = jsonDecode(jsonString);

   // Loads TextModel
  List<TextModel> loadedTexts = [];
  if (designData['texts'] != null) {
    loadedTexts = (designData['texts'] as List)
        .map((data) => TextModel.fromJson(data))
        .toList();
  }

  // Loads PictureModel
  List<PictureModel> loadedPictures = [];
  if (designData['pictures'] != null) {
    loadedPictures = (designData['pictures'] as List)
        .map((data) => PictureModel.fromJson(data))
        .toList();
  }

  setState(() {
    texts = loadedTexts;
    pictures = loadedPictures;
  });
}

@override
Widget build(BuildContext context) {
return Scaffold(
  body: StickerEditingView(
    // ...
    texts: texts, // Restored Texts
    pictures: pictures, // Restored pictures
    onSave: (editedTexts, editedPictures) async {
      // ...
    },
  ),
);
}
```

## Example
Run the example app in the exmaple folder to find out more about how to use it.
