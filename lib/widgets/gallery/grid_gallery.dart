import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
          return Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.assets!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
              ),
              itemBuilder: (context, index) {
                final asset = widget.assets![index];

                return ImageLoader(
                  assentEntity: asset,
                  width: itemSize,
                  height: itemSize,
                );
              },
            ),
          );
        }

        if (imagesExist) {
          return Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.images!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
              ),
              itemBuilder: (context, index) {
                final image = widget.images![index];

                return Image(
                  image: image.image,
                  width: itemSize,
                  height: itemSize,
                  fit: BoxFit.cover,
                );
              },
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.imageUrls!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
              ),
              itemBuilder: (context, index) {
                final imageUrl = widget.imageUrls![index];

                return ImageLoader(
                  imageUrl: imageUrl,
                  width: itemSize,
                  height: itemSize,
                );
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
    if (widget.imageUrls != null &&
        widget.imageUrls!.isNotEmpty &&
        widget.imageUrls![0].startsWith('http')) {
      await cacheManager.getFileFromCache(widget.imageUrls![0]);
    }
  }

  Widget assetWidget(AssetEntity assetEntity) {
    final isVideo = assetEntity.type == AssetType.video;
    final int? videoDuration = isVideo ? assetEntity.duration : null;

    return Stack(
      children: [
        Positioned.fill(
          child: AssetEntityImage(
            assetEntity,
            isOriginal: false,
            thumbnailSize: const ThumbnailSize.square(250),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              );
            },
          ),
        ),
        if (isVideo) // Show video icon for video assets
          Positioned(
            bottom: 5,
            right: 5,
            child: Row(
              children: [
                Text(
                  '${(videoDuration! ~/ 60).toString().padLeft(2, '0')}:${(videoDuration % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
