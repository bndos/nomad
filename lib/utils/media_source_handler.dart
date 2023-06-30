import 'package:flutter/material.dart';
import 'package:nomad/widgets/gallery/image_loader.dart';
import 'package:photo_manager/photo_manager.dart';

List<Widget> getMediaListWidgets({
  List<AssetEntity>? assets,
  List<Image>? images,
  List<String>? imageUrls,
  required double itemSize,
  void Function()? onTap,
}) {
  final assetsExist = assets != null && assets.isNotEmpty;
  final imagesExist = images != null && images.isNotEmpty;
  final imageUrlsExist = imageUrls != null && imageUrls.isNotEmpty;

  if (assetsExist) {
    return assets.map((asset) {
      return GestureDetector(
        onTap: onTap,
        child: ImageLoader(
          assentEntity: asset,
          width: itemSize,
          height: itemSize,
        ),
      );
    }).toList();
  }

  if (imagesExist) {
    return images.map((image) {
      return GestureDetector(
        onTap: onTap,
        child: Image(
          image: image.image,
          width: itemSize,
          height: itemSize,
          fit: BoxFit.cover,
        ),
      );
    }).toList();
  }

  if (imageUrlsExist) {
    return imageUrls.map((imageUrl) {
      return GestureDetector(
        onTap: onTap,
        child: ImageLoader(
          imageUrl: imageUrl,
          width: itemSize,
          height: itemSize,
        ),
      );
    }).toList();
  }

  return [];
}
