library sticker_editor;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sticker_widget/sticker_widget.dart';
import 'package:sticker_editor_plus/src/constants_value.dart';
import 'package:sticker_editor_plus/src/widgets/custom_button.dart';
import 'package:sticker_editor_plus/src/widgets/text_widget/textstyle_editor.dart';

import 'model/custom_add_requests.dart';
import 'model/sticker_placement.dart';

export 'package:sticker_editor_plus/src/constants_value.dart';

export 'model/sticker_placement.dart';
export 'package:sticker_widget/sticker_widget.dart'
    show
        PictureModel,
        PictureEditingBox,
        StickerWidget,
        TextModel,
        TextEditingBox;

typedef SaveCallback = void Function(
  List<TextModel> texts,
  List<PictureModel> pictures,
);

/// Sticker editor view
/// A flutter widget that rotate, zoom and edit text and Sticker
///
/// You can pass your fonts
/// and then get the edited Text Widget
// ignore: must_be_immutable
class StickerEditingView extends StatefulWidget {
  /// Editor's font families
  final List<String> fonts;

  /// Editor's PalletColor List
  List<Color>? palletColor;

  /// Editor's assetsList List
  List<String>? assetList;

  /// Choose whether view only
  bool viewOnly;

  /// Editor's background color
  Color? backgroundColor;

  /// Editor's image
  Widget child;

  /// StickerEditor View Height
  double? height;

  /// StickerEditor View Width
  double? width;

  /// Callback for saving
  SaveCallback? onSave;

  /// Custom request to add text. When provided, the default dialog is skipped.
  final TextAddRequest? onTextAddRequest;

  /// Custom request to pick a sticker. When provided, the default sheet is skipped.
  final StickerPickRequest? onStickerPickRequest;

  /// Initial Text List
  List<TextModel> texts;

  /// Initial Picture List
  List<PictureModel> pictures;

  /// Button specific UIs
  String textButtonText;
  Color textButtonColor;

  String stickerButtonText;
  Color stickerButtonColor;

  String saveButtonText;
  Color saveButtonColor;

  String textModalTitle;
  String textModalDefaultText;
  Color textModalColor;
  Color textModalBackgroundColor;
  String textModalConfirmText;

  /// Custom controller Icons
  final Icon? editIcon;
  final Icon? resizeIcon;
  final Icon? rotateIcon;
  final Icon? closeIcon;

  /// Whether to show the bottom control bar in the sticker editor.
  ///
  /// If `true` (the default), the bottom controls (such as add text, add sticker, and save buttons)
  /// are visible, allowing users to interact with the editor. If `false`, these controls are hidden,
  /// which is useful for view-only modes or when you want to restrict editing capabilities.
  final bool showControl;

  /// Bounding width ratio relative to editor width
  /// Default: 0.9 (90% of editor width)
  /// Set to 1.0 to allow full editor width usage
  final double boundWidthRatio;

  /// Bounding height ratio relative to editor height
  /// Default: 0.7 (70% of editor height)
  /// Set to 1.0 to allow full editor height usage
  final double boundHeightRatio;

  /// Optional placement for newly added text and image stickers.
  /// If null, the legacy defaults are used.
  final StickerPlacement? defaultPlacement;

  /// Whether to allow the color picker in text style editors.
  final bool useColorPicker;

  /// Create a [StickerWidget] widget.
  ///
  /// [showControl] determines whether the bottom control bar (add text, add sticker, save, etc.)
  /// is visible. Set to `false` to hide these controls for view-only or restricted editing modes.
  StickerEditingView(
      {Key? key,
      required this.fonts,
      required this.child,
      this.palletColor,
      this.height,
      this.width,
      this.onSave,
      this.backgroundColor,
      this.editIcon,
      this.resizeIcon,
      this.rotateIcon,
      this.closeIcon,
      this.viewOnly = false,
      this.texts = const [],
      this.pictures = const [],
      this.textButtonText = 'Add Text',
      this.textButtonColor = Colors.blue,
      this.stickerButtonText = 'Add Stickers',
      this.stickerButtonColor = Colors.blue,
      this.saveButtonText = 'Save',
      this.saveButtonColor = Colors.blue,
      this.textModalTitle = 'Edit Text',
      this.textModalDefaultText = 'Happy day',
      this.textModalColor = Colors.blue,
      this.textModalBackgroundColor = const Color.fromARGB(240, 200, 200, 200),
      this.textModalConfirmText = 'Done',
      this.showControl = true,
      required this.assetList,
      this.boundWidthRatio = 0.9,
      this.boundHeightRatio = 0.7,
      this.defaultPlacement,
      this.useColorPicker = true,
      this.onTextAddRequest,
      this.onStickerPickRequest})
      : super(key: key);

  @override
  _StickerEditingViewState createState() => _StickerEditingViewState();
}

class _StickerEditingViewState extends State<StickerEditingView> {
  // selected text perameter
  double selectedFontSize = 18;
  TextStyle selectedTextstyle =
      const TextStyle(color: Colors.black, fontSize: 18, fontFamily: "Lato");
  String selectedFont = "Lato";
  TextAlign selectedtextAlign = TextAlign.left;
  int selectedTextIndex = -1;
  String selectedtextToShare = "Happy ${weekDays[today - 1]}!";

  // new String and Image List
  RxList<TextModel> newStringList = <TextModel>[].obs;
  RxList<PictureModel> newimageList = <PictureModel>[].obs;

  List<Color> _resolvePaletteColors() {
    final colors = widget.palletColor;
    if (colors == null || colors.isEmpty) {
      return [
        Colors.black,
        Colors.white,
        Colors.red,
        Colors.blue,
        Colors.blueAccent,
        Colors.brown,
        Colors.green,
        Colors.indigoAccent,
        Colors.lime,
      ];
    }
    return colors;
  }

  Future<void> _showTextStyleBottomSheet(TextModel text) async {
    final height = MediaQuery.of(context).size.height;
    final palette = _resolvePaletteColors();
    await showModalBottomSheet(
      elevation: 15,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(4),
          height: height * .35,
          child: TextStyleEditor(
            fonts: widget.fonts,
            paletteColors: palette,
            useColorPicker: widget.useColorPicker,
            textStyle: text.textStyle,
            textAlign: text.textAlign,
            onTextAlignEdited: (align) {
              setState(() => text.textAlign = align);
            },
            onTextStyleEdited: (style) {
              setState(() => text.textStyle = text.textStyle.merge(style));
            },
            onCpasLockTaggle: (caps) {},
          ),
        );
      },
    );
  }

  @override
  void initState() {
    loadInitialResources();
    super.initState();
  }

  void loadInitialResources() {
    if (widget.texts.isNotEmpty) {
      newStringList.addAll(widget.texts);
    }

    if (widget.pictures.isNotEmpty) {
      newimageList.addAll(widget.pictures);
    }
  }

  /// Opens a dialog to add a new text sticker to the editor.
  /// The dialog allows the user to input and style the text before adding it.
  void addText() async {
    final placement = widget.defaultPlacement ??
        const StickerPlacement(position: Offset(50, 50));
    if (widget.onTextAddRequest != null) {
      final result = await widget.onTextAddRequest!(
        context,
        TextAddPayload(
          defaultText: widget.textModalDefaultText,
          defaultTextStyle: const TextStyle(),
          defaultTextAlign: TextAlign.center,
          fonts: widget.fonts,
          paletteColors: widget.palletColor,
          useColorPicker: widget.useColorPicker,
        ),
      );
      if (result == null) {
        return;
      }
      final text = result.text.trim();
      setState(() {
        for (var e in newimageList) {
          e.isSelected = false;
        }
        for (var e in newStringList) {
          e.isSelected = false;
        }
        newStringList.add(
          TextModel(
            name: text,
            textStyle: const TextStyle(),
            top: placement.position.dy,
            isSelected: true,
            textAlign: TextAlign.center,
            scale: placement.scale,
            left: placement.position.dx,
            angle: placement.rotation,
          ),
        );
      });
      return;
    }

    await showEditBox(
      context: context,
      textModel: TextModel(
          name: selectedtextToShare,
          textStyle: const TextStyle(),
          top: placement.position.dy,
          isSelected: false,
          textAlign: TextAlign.center,
          scale: placement.scale,
          left: placement.position.dx,
          angle: placement.rotation),
      textModalTitle: widget.textModalTitle,
      textModalDefaultText: widget.textModalDefaultText,
      textModalConfirmText: widget.textModalConfirmText,
      textModalBackgroundColor: widget.textModalBackgroundColor,
      textModalColor: widget.textModalColor,
    );
  }

  void addSticker() async {
    final placement = widget.defaultPlacement ??
        const StickerPlacement(position: Offset(50, 50));
    selectedTextIndex = -1;
    if (widget.onStickerPickRequest != null) {
      final picked = await widget.onStickerPickRequest!(
        context,
        StickerPickPayload(assets: widget.assetList ?? const []),
      );
      if (picked == null) {
        return;
      }
      setState(() {
        for (var e in newimageList) {
          e.isSelected = false;
        }
        for (var e in newStringList) {
          e.isSelected = false;
        }
        newimageList.add(PictureModel(
            stringUrl: picked,
            top: placement.position.dy,
            isSelected: true,
            angle: placement.rotation,
            scale: placement.scale,
            left: placement.position.dx));
      });
      return;
    }
    stickerWidget(context);
  }

  void save() {
    setState(() {
      for (var e in newStringList) {
        e.isSelected = false;
      }
      for (var e in newimageList) {
        e.isSelected = false;
      }
    });

    if (widget.onSave != null) {
      widget.onSave!(
        newStringList.toList(),
        newimageList.toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    double height = deviceSize.height;
    double width = deviceSize.width;

    // Calculate the actual editor size
    final editorWidth = widget.width ?? width * .8;
    final editorHeight = widget.height ?? height * .8;

    // Calculate the bounding area (based on editor size)
    final boundWidth = editorWidth * widget.boundWidthRatio;
    final boundHeight = editorHeight * widget.boundHeightRatio;

    return Scaffold(
      backgroundColor: widget.backgroundColor ?? Colors.white,
      body: Obx(
        () => Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: SizedBox(
                height: widget.height ?? height * .8,
                width: widget.width ?? width * .8,
                child: Stack(
                  children: [
                    Center(
                      child: IgnorePointer(
                        ignoring: widget.viewOnly,
                        child: widget.child,
                      ),
                    ),
                    widget.viewOnly
                        ? const SizedBox.shrink()
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                for (var element in newStringList) {
                                  element.isSelected = false;
                                }
                                for (var e in newimageList) {
                                  e.isSelected = false;
                                }
                              });
                            },
                          ),
                    ...newStringList.map((v) {
                      return StickerWidget(
                          viewOnly: widget.viewOnly,
                          data: v,
                          onTextEditRequest: widget.onTextAddRequest == null
                              ? null
                              : (context, currentText) async {
                                  final result = await widget.onTextAddRequest!(
                                    context,
                                    TextAddPayload(
                                      defaultText: currentText,
                                      defaultTextStyle: v.textStyle,
                                      defaultTextAlign: v.textAlign,
                                      fonts: widget.fonts,
                                      paletteColors: widget.palletColor,
                                      useColorPicker: widget.useColorPicker,
                                    ),
                                  );
                                  return result?.text;
                                },
                          onTap: () {
                            if (widget.viewOnly) {
                              return;
                            }

                            if (!v.isSelected) {
                              setState(() {
                                for (var element in newStringList) {
                                  element.isSelected = false;
                                }
                                for (var e in newimageList) {
                                  e.isSelected = false;
                                }
                                v.isSelected = true;
                              });
                              _showTextStyleBottomSheet(v);
                            } else {
                              setState(() {
                                v.isSelected = false;
                              });
                            }
                          },
                          onCancel: () {
                            int index = newStringList
                                .indexWhere((element) => v == element);

                            newStringList.removeAt(index);
                          },
                          editIcon: widget.editIcon,
                          resizeIcon: widget.resizeIcon,
                          closeIcon: widget.closeIcon,
                          rotateIcon: widget.rotateIcon,
                          boundWidth: boundWidth,
                          boundHeight: boundHeight);
                    }).toList(),
                    ...newimageList.map((v) {
                      return StickerWidget(
                          viewOnly: widget.viewOnly,
                          data: v,
                          onCancel: () {
                            int index = newimageList
                                .indexWhere((element) => v == element);

                            newimageList.removeAt(index);
                          },
                          onTap: () {
                            if (widget.viewOnly) {
                              return;
                            }

                            if (!v.isSelected) {
                              setState(() {
                                for (var element in newStringList) {
                                  element.isSelected = false;
                                }
                                for (var e in newimageList) {
                                  e.isSelected = false;
                                }
                                v.isSelected = true;
                              });
                            } else {
                              setState(() {
                                v.isSelected = false;
                              });
                            }
                          },
                          resizeIcon: widget.resizeIcon,
                          closeIcon: widget.closeIcon,
                          rotateIcon: widget.rotateIcon,
                          boundWidth: boundWidth,
                          boundHeight: boundHeight);
                    }),
                  ],
                ),
              ),
            ),
            widget.viewOnly || !widget.showControl
                ? Container()
                : Positioned(
                    bottom: 24,
                    child: SizedBox(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomeWidgets.customButton(
                            btnName: widget.textButtonText,
                            color: widget.textButtonColor,
                            onPressed: addText,
                          ),
                          CustomeWidgets.customButton(
                            btnName: widget.stickerButtonText,
                            color: widget.stickerButtonColor,
                            onPressed: addSticker,
                          ),
                          CustomeWidgets.customButton(
                            btnName: widget.saveButtonText,
                            color: widget.saveButtonColor,
                            onPressed: save,
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future showEditBox({
    BuildContext? context,
    TextModel? textModel,
    required String textModalTitle,
    required String textModalDefaultText,
    required String textModalConfirmText,
    required Color textModalBackgroundColor,
    required Color textModalColor,
  }) {
    return showDialog(
        context: context!,
        builder: (context) {
          final dailogTextController =
              TextEditingController(text: textModalDefaultText);
          return AlertDialog(
            backgroundColor: textModalBackgroundColor,
            title: Text(textModalTitle),
            content: TextField(
                controller: dailogTextController,
                maxLines: 6,
                minLines: 1,
                autofocus: true,
                decoration: InputDecoration(
                    hintText: textModalDefaultText,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: textModalColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: textModalColor)))),
            actions: [
              ElevatedButton(
                  child: Text(textModalConfirmText),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(textModalColor)),
                  onPressed: () {
                    setState(() {
                      for (var e in newimageList) {
                        e.isSelected = false;
                      }
                      for (var e in newStringList) {
                        e.isSelected = false;
                      }
                      textModel!.isSelected = true;
                      textModel.name = dailogTextController.text.trim();
                      newStringList.add(textModel);
                    });
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  // Sticker widget
  Future stickerWidget(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    selectedTextIndex = -1;
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Material(
            elevation: 15,
            child: SizedBox(
              height: height * .4,
              width: width,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemCount: widget.assetList!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final asset = widget.assetList![index];
                    final isNetwork = asset.startsWith('http');
                    return InkWell(
                      onTap: () {
                        for (var e in newimageList) {
                          e.isSelected = false;
                        }
                        for (var e in newStringList) {
                          e.isSelected = false;
                        }
                        final placement = widget.defaultPlacement ??
                            StickerPlacement.defaultPlacement();
                        newimageList.add(PictureModel(
                            stringUrl: asset,
                            top: placement.position.dy,
                            isSelected: true,
                            angle: placement.rotation,
                            scale: placement.scale,
                            left: placement.position.dx));
                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: isNetwork
                          ? CachedNetworkImage(
                              imageUrl: asset, height: 50, width: 50)
                          : Image.asset(asset, height: 50, width: 50),
                    );
                  }),
            ),
          );
        });
  }
}
