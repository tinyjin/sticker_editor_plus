import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sticker_editor_plus/sticker_editor_plus.dart';
import 'package:stickereditor_example/constants.dart';

class StickerEditingViewScreen extends StatefulWidget {
  const StickerEditingViewScreen({Key? key}) : super(key: key);

  @override
  _StickerEditingViewScreenState createState() =>
      _StickerEditingViewScreenState();
}

class _StickerEditingViewScreenState extends State<StickerEditingViewScreen> {
  final List<String> stickerList = <String>[];
  String backgroundImageUrl = 'assets/t-shirt.jpeg';

  List<TextModel> texts = <TextModel>[];
  List<PictureModel> pictures = <PictureModel>[];

  @override
  void initState() {
    initialiseStickerList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('StickerEditingView'),
      ),
      body: StickerEditingView(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset(backgroundImageUrl),
        fonts: fonts,
        texts: texts,
        pictures: pictures,
        palletColor: colorPallet,
        assetList: stickerList,
        defaultPlacement: StickerPlacement(
          position: Offset(size.width / 2 - 60, size.height / 2 - 20),
          scale: 1.1,
          rotation: 0.1,
        ),
        onSave: ((texts, pictures) {
          // You can save current state via these texts and pictures (JSON)
          setState(() {
            texts = texts;
            pictures = pictures;
          });
        }),
      ),
    );
  }

  void initialiseStickerList() {
    for (var i = 0; i < 27; i++) {
      stickerList.add('assets/Stickers/$i.png');
    }
  }
}

class TextEditingBoxScreen extends StatefulWidget {
  const TextEditingBoxScreen({Key? key}) : super(key: key);

  @override
  _TextEditingBoxScreenState createState() => _TextEditingBoxScreenState();
}

class _TextEditingBoxScreenState extends State<TextEditingBoxScreen> {
  double top = 50;
  double left = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text Editing Box Demo')),
      body: Center(
        child: Container(
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
      ),
    );
  }
}

class StickerWidgetScreen extends StatefulWidget {
  const StickerWidgetScreen({Key? key}) : super(key: key);

  @override
  _StickerWidgetScreenState createState() =>
      _StickerWidgetScreenState();
}

class _StickerWidgetScreenState extends State<StickerWidgetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sticker EditingBox Demo '),
      ),
      body: Center(
          child: Container(
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
                  stringUrl:
                      'https://raw.githubusercontent.com/Harsh-Radadiya/sticker_editor/master/example/assets/t-shirt.jpeg',
                )),
          ],
        ),
      )),
    );
  }
}

class CustomAddUiScreen extends StatefulWidget {
  const CustomAddUiScreen({Key? key}) : super(key: key);

  @override
  State<CustomAddUiScreen> createState() => _CustomAddUiScreenState();
}

class _CustomAddUiScreenState extends State<CustomAddUiScreen> {
  final List<String> stickerList = <String>[];
  String backgroundImageUrl = 'assets/t-shirt.jpeg';

  List<TextModel> texts = <TextModel>[];
  List<PictureModel> pictures = <PictureModel>[];

  @override
  void initState() {
    initialiseStickerList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Add UI Demo'),
      ),
      body: StickerEditingView(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset(backgroundImageUrl),
        fonts: fonts,
        texts: texts,
        pictures: pictures,
        palletColor: colorPallet,
        assetList: stickerList,
        onTextAddRequest: (context, payload) async {
          final controller = TextEditingController(text: payload.defaultText);
          final result = await showModalBottomSheet<String?>(
            context: context,
            isScrollControlled: true,
            builder: (sheetContext) {
              final viewInsets = MediaQuery.of(sheetContext).viewInsets;
              return Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: 16 + viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Add Text',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controller,
                      autofocus: true,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Type your text',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(sheetContext),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(
                                sheetContext,
                                controller.text.trim(),
                              );
                            },
                            child: const Text('Add'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
          if (result == null || result.isEmpty) {
            return null;
          }
          return TextAddResult(result);
        },
        onStickerPickRequest: (context, payload) async {
          final picked = await showDialog<String?>(
            context: context,
            builder: (dialogContext) {
              return Dialog(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  itemCount: payload.assets.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
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
        onSave: ((texts, pictures) {
          setState(() {
            this.texts = texts;
            this.pictures = pictures;
          });
        }),
      ),
    );
  }

  void initialiseStickerList() {
    for (var i = 0; i < 27; i++) {
      stickerList.add('assets/Stickers/$i.png');
    }
  }
}
