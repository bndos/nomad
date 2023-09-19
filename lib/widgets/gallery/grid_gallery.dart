import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:nomad/screens/media_feed_page.dart';
import 'package:nomad/utils/media_source_handler.dart';
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

        final children = getMediaListWidgets(
          assets: widget.assets,
          imageUrls: widget.imageUrls,
          images: widget.images,
          width: itemSize,
          height: itemSize,
          onTap: (index) => {
            _navigateToMediaFeedPage(context, index),
          },
        );

        if (assetsExist || imagesExist) {
          return buildGridView(children);
        }

        if (snapshot.connectionState == ConnectionState.done) {
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

  void _navigateToMediaFeedPage(
    BuildContext context,
    int index,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MediaFeedPage(
          index: index,
          images: widget.images,
          assets: widget.assets,
          imageUrls: widget.imageUrls,
        ),
      ),
    );
  }
}
