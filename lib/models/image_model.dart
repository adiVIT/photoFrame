import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageModel {
  Uint8List? pickedImage;
  bool isContainerVisible;
  Uint8List? originalImage;
  String pickedImageFramePath;
  bool showMaskedImage;
  bool showOriginalImage;

  ImageModel({
    this.pickedImage,
    this.isContainerVisible = false,
    this.originalImage,
    this.pickedImageFramePath = 'images/user_image_frame_1.png',
    this.showMaskedImage = true,
    this.showOriginalImage = false,
  });
}
