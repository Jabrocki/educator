//Files
import 'dart:io';

class ImageModel {
  final int imgId;
  final String imgFileName;

  const ImageModel(
    {
    required this.imgId,
    required this.imgFileName
  });

  Map<String, Object?> toMap() {
    return {
      "imgId": imgId,
      "imgFileName": imgFileName
    };
  }

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      imgId: map['imgId'],
      imgFileName: map['imgFileName']
      );
  }

  File get imgFile => File(imgFileName);

  @override
  String toString() {
    return 'Image(imgId: $imgId, imgFileName: $imgFileName)';
  }
}