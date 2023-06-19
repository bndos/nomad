import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class GridGallery extends StatelessWidget {
  final List<String> imageUrls;
  final Color backgroundColor;

  const GridGallery({
    Key? key,
    required this.imageUrls,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cacheManager = DefaultCacheManager();

    return FutureBuilder<void>(
      future: _initializeCacheManager(cacheManager),
      builder: (context, snapshot) {
        if (imageUrls.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(50),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                'No images',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          final double screenWidth = MediaQuery.of(context).size.width;
          final double itemSize = (screenWidth - 16.0 * 2 - 8.0 * 2) / 3;

          return Container(
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: imageUrls.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
              ),
              itemBuilder: (context, index) {
                final imageUrl = imageUrls[index];

                if (imageUrl.startsWith('http')) {
                  return ClipRRect(
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      cacheManager: cacheManager,
                      fit: BoxFit.cover,
                      width: itemSize,
                      height: itemSize,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  );
                } else {
                  return ClipRRect(
                    child: Image.file(
                      File(imageUrl),
                      fit: BoxFit.cover,
                      width: itemSize,
                      height: itemSize,
                    ),
                  );
                }
              },
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future<void> _initializeCacheManager(DefaultCacheManager cacheManager) async {
    if (imageUrls.isNotEmpty && imageUrls[0].startsWith('http')) {
      await cacheManager.getFileFromCache(imageUrls[0]);
    }
  }
}
