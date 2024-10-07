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
              TextEditingBox(
                fonts: fonts,
                boundHeight: 200,
                boundWidth: 100,
                isSelected: true,
                palletColor: colorPallet,
                newText: TextModel(
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

class StickerEditingBoxScreen extends StatefulWidget {
  const StickerEditingBoxScreen({Key? key}) : super(key: key);

  @override
  _StickerEditingBoxScreenState createState() =>
      _StickerEditingBoxScreenState();
}

class _StickerEditingBoxScreenState extends State<StickerEditingBoxScreen> {
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
            StickerEditingBox(
                boundHeight: 200,
                boundWidth: 200,
                pictureModel: PictureModel(
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
