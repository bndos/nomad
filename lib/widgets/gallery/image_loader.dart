import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageLoader extends StatelessWidget {
  final String? imageUrl;
  final AssetEntity? assentEntity;
  final double width;
  final double height;

  const ImageLoader({
    Key? key,
    required this.width,
    required this.height,
    this.assentEntity,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null && assentEntity == null) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[300],
      );
    }

    if (assentEntity != null) {
      return ClipRRect(
        child: AssetEntityImage(
          assentEntity!,
          width: width,
          height: height,
          thumbnailSize: ThumbnailSize(width.toInt(), height.toInt()),
          fit: BoxFit.cover,
        ),
      );
    }

    if (imageUrl!.startsWith('http')) {
      return ClipRRect(
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          fit: BoxFit.cover,
          width: width,
          height: height,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      );
    } else {
      return ClipRRect(
        child: Image.file(
          File(imageUrl!),
          fit: BoxFit.cover,
          width: width,
          height: height,
        ),
      );
    }
  }
}
