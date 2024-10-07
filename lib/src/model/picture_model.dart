class PictureModel {
  String stringUrl;
  double top;
  bool isSelected;
  double angle;

  /// Scale image
  double scale;
  double left;

  PictureModel(
      {required this.stringUrl,
      required this.top,
      required this.isSelected,
      this.angle = 0,
      required this.scale,
      required this.left});

  PictureModel.fromJson(Map<String, dynamic> data)
      : stringUrl = data['url'] ?? '',
        top = data['top'] ?? 0,
        left = data['left'] ?? 0,
        angle = data['angle'] ?? 0,
        scale = data['scale'] ?? 1,
        isSelected = false;

  Map<String, dynamic> toJson() {
    return {
      'url': stringUrl,
      'top': top,
      'left': left,
      'angle': angle,
      'scale': scale,
    };
  }
}
