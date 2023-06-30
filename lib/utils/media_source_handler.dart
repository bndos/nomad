import 'package:flutter/material.dart';
import 'package:nomad/widgets/gallery/media_loader.dart';
import 'package:photo_manager/photo_manager.dart';

List<Widget> getMediaListWidgets({
  List<AssetEntity>? assets,
  List<Image>? images,
  List<String>? imageUrls,
  required double width,
  required double height,
  void Function(int index)? onTap,
}) {
  final assetsExist = assets != null && assets.isNotEmpty;
  final imagesExist = images != null && images.isNotEmpty;
  final imageUrlsExist = imageUrls != null && imageUrls.isNotEmpty;

  if (assetsExist) {
    return assets.asMap().entries.map((entry) {
      final index = entry.key;
      final asset = entry.value;

      return GestureDetector(
        onTap: onTap != null ? () => onTap(index) : null,
        child: MediaLoader(
          assentEntity: asset,
          width: width,
          height: height,
        ),
      );
    }).toList();
  }

  if (imagesExist) {
    return images.asMap().entries.map((entry) {
      final index = entry.key;
      final image = entry.value;

      return GestureDetector(
        onTap: onTap != null ? () => onTap(index) : null,
        child: Image(
          image: image.image,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      );
    }).toList();
  }

  if (imageUrlsExist) {
    return imageUrls.asMap().entries.map((entry) {
      final index = entry.key;
      final imageUrl = entry.value;

      return GestureDetector(
        onTap: onTap != null ? () => onTap(index) : null,
        child: MediaLoader(
          imageUrl: imageUrl,
          width: width,
          height: height,
        ),
      );
    }).toList();
  }

  return [];
}
