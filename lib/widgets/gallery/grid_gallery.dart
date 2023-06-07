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
          final double itemSize = (screenWidth - 16.0 * 2 - 8.0 * 2) /
              3; // Adjust the spacing as needed

          return Container(
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: imageUrls.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Adjust the number of columns as needed
                crossAxisSpacing: 8.0, // Adjust the spacing between columns
                mainAxisSpacing: 8.0, // Adjust the spacing between rows
              ),
              itemBuilder: (context, index) {
                final imageUrl = imageUrls[index];

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
              },
            ),
          );
        } else {
          // Cache manager is still initializing, show a loading indicator or placeholder
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future<void> _initializeCacheManager(DefaultCacheManager cacheManager) async {
    await cacheManager.getFileFromCache(imageUrls[0]);
  }
}
