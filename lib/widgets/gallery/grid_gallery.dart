import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:nomad/screens/media_feed_page.dart';
import 'package:nomad/widgets/gallery/image_loader.dart';
import 'package:photo_manager/photo_manager.dart';

class GridGallery extends StatefulWidget {
  final Color backgroundColor;
  final List<AssetEntity>? assets;
  final List<Image>? images;
  final List<String>? imageUrls;

  const GridGallery({
    Key? key,
    this.imageUrls,
    this.images,
    this.assets,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  @override
  State<GridGallery> createState() => _GridGalleryState();
}

class _GridGalleryState extends State<GridGallery> {
  @override
  Widget build(BuildContext context) {
    final cacheManager = DefaultCacheManager();
    final assetsExist = widget.assets != null && widget.assets!.isNotEmpty;
    final imageUrlsExist =
        widget.imageUrls != null && widget.imageUrls!.isNotEmpty;
    final imagesExist = widget.images != null && widget.images!.isNotEmpty;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double itemSize = (screenWidth - 16.0 * 2 - 8.0 * 2) / 3;

    Widget buildGridView(List<Widget> children) {
      return Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
        ),
        child: GridView.count(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 1.0,
          mainAxisSpacing: 1.0,
          children: children,
        ),
      );
    }

    return FutureBuilder<void>(
      future: _initializeCacheManager(cacheManager),
      builder: (context, snapshot) {
        if (!assetsExist && !imageUrlsExist && !imagesExist) {
          return Container(
            padding: const EdgeInsets.all(50),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
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

        if (assetsExist) {
          final children = widget.assets!.map((asset) {
            return GestureDetector(
              onTap: () => _navigateToMediaFeedPage(context),
              child: ImageLoader(
                assentEntity: asset,
                width: itemSize,
                height: itemSize,
              ),
            );
          }).toList();

          return buildGridView(children);
        }

        if (imagesExist) {
          final children = widget.images!.map((image) {
            return GestureDetector(
              onTap: () => _navigateToMediaFeedPage(context),
              child: Image(
                image: image.image,
                width: itemSize,
                height: itemSize,
                fit: BoxFit.cover,
              ),
            );
          }).toList();

          return buildGridView(children);
        }

        if (snapshot.connectionState == ConnectionState.done) {
          final children = widget.imageUrls!.map((imageUrl) {
            return GestureDetector(
              onTap: () => _navigateToMediaFeedPage(context),
              child: ImageLoader(
                imageUrl: imageUrl,
                width: itemSize,
                height: itemSize,
              ),
            );
          }).toList();

          return buildGridView(children);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future<void> _initializeCacheManager(DefaultCacheManager cacheManager) async {
    if (widget.imageUrls != null &&
        widget.imageUrls!.isNotEmpty &&
        widget.imageUrls![0].startsWith('http')) {
      await cacheManager.getFileFromCache(widget.imageUrls![0]);
    }
  }

  void _navigateToMediaFeedPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MediaFeedPage(),
      ),
    );
  }
}
