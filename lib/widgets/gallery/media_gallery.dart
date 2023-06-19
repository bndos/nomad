import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaGalleryWidget extends StatefulWidget {
  final Function(Media) onMediaSelected;

  const MediaGalleryWidget({Key? key, required this.onMediaSelected})
      : super(key: key);

  @override
  State<MediaGalleryWidget> createState() => _MediaGalleryWidgetState();
}

class _MediaGalleryWidgetState extends State<MediaGalleryWidget> {
  List<Media> _mediaList = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadMedia();
  }

  Future<void> _loadMedia() async {
    final permitted = await _requestPermission();
    if (!permitted) {
      setState(() {
        _error = 'Permission denied';
        _isLoading = false;
      });
      return;
    }

    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.common,
      hasAll: true,
    );
    final recentAlbum = albums.first;
    final mediaList = await recentAlbum.getAssetListRange(
      start: 0,
      end: 100,
    );

    final formattedMediaList = mediaList.map((asset) {
      return Media(
        id: asset.id,
        type: asset.type,
        width: asset.width,
        height: asset.height,
      );
    }).toList();

    setState(() {
      _mediaList = formattedMediaList;
      _isLoading = false;
    });
  }

  Future<bool> _requestPermission() async {
    final permissionStatus = await PhotoManager.requestPermissionExtend();
    return permissionStatus == PermissionState.authorized;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(child: Text(_error));
    }

    return GridView.builder(
      itemCount: _mediaList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        final media = _mediaList[index];

        return GestureDetector(
          onTap: () => widget.onMediaSelected(media),
          child: FutureBuilder<Widget>(
            future: media.getThumbnailWidget(200, 200),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                return snapshot.data!;
              } else {
                return Container(
                  color: Colors.grey[200],
                );
              }
            },
          ),
        );
      },
    );
  }
}

class Media {
  final String id;
  final AssetType type;
  final int width;
  final int height;

  Media({
    required this.id,
    required this.type,
    required this.width,
    required this.height,
  });

  Future<Widget> getThumbnailWidget(int width, int height) async {
    final asset = await AssetEntity.fromId(id);
    final thumbData = await asset?.thumbnailDataWithSize(
      ThumbnailSize(width, height),
    );
    if (thumbData != null) {
      try {
        return Image.memory(
          thumbData,
          fit: BoxFit.cover,
        );
      } catch (e) {
        return Container();
      }
    } else {
      return Container();
    }
  }
}
