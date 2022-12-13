import 'package:flutter/material.dart';

class TextModel {
  String name;
  TextStyle textStyle;
  double top;
  double left;
  bool isSelected;
  double angle;
  TextAlign textAlign;
  double scale;

  TextModel(
      {required this.name,
      required this.textStyle,
      required this.top,
      required this.isSelected,
      this.angle = 0,
      required this.textAlign,
      required this.scale,
      required this.left});

  TextModel.fromJson(Map<String, dynamic> data)
    : name = data['text'] ?? '',
      textStyle = TextStyle(
        fontFamily: data['textStyle']!['font'],
        fontStyle: FontStyle.values[data['textStyle']!['fontStyle'] ?? 0],
        fontWeight: FontWeight.values[data['textStyle']!['fontWeight'] ?? 0],
        fontSize: data['textStyle']!['fontSize'],
        height: data['textStyle']!['height'],
        letterSpacing: data['textStyle']!['letterSpacing'],
        color: data['textStyle']!['color'] != null ? Color(data['textStyle']!['color']) : null,
        backgroundColor: data['textStyle']!['backgroundColor'] != null ? Color(data['textStyle']!['backgroundColor']) : null,
      ),
      top = data['top'] ?? 0,
      left = data['left'] ?? 0,
      scale = data['scale'] ?? 1,
      angle = data['angle'] ?? 0,
      isSelected = false,
      textAlign = TextAlign.values[data['textAlign'] ?? 0];

  Map<String, dynamic> toJson() {
    return {
      'text': name,
      'top': top,
      'left': left,
      'scale': scale,
      'angle': angle,
      'textStyle': {
        'font': textStyle.fontFamily,
        'fontStyle': textStyle.fontStyle?.index ?? 0,
        'fontWeight': textStyle.fontWeight?.index ?? 0,
        'fontSize': textStyle.fontSize,
        'height': textStyle.height,
        'letterSpacing': textStyle.letterSpacing,
        'color': textStyle.color?.value,
        'backgroundColor': textStyle.backgroundColor?.value,
      },
      'textAlign': textAlign.index
    };
  }
}
