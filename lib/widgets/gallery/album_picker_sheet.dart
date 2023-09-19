import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumPickerSheet extends StatelessWidget {
  final AssetPathEntity selectedAlbum;
  final List<AssetPathEntity> albums;
  final Function(AssetPathEntity) onAlbumSelected;

  const AlbumPickerSheet({
    Key? key,
    required this.selectedAlbum,
    required this.albums,
    required this.onAlbumSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Select an album',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: albums.length,
            itemBuilder: (context, index) {
              final album = albums[index];
              return FutureBuilder<int>(
                future: album.assetCountAsync,
                builder: (context, snapshot) {
                  final assetCount = snapshot.data;
                  if (!snapshot.hasData ||
                      assetCount == null ||
                      assetCount == 0) {
                    return const SizedBox.shrink();
                  }

                  return InkWell(
                    onTap: () => onAlbumSelected(album),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              FutureBuilder<List<AssetEntity>>(
                                future:
                                    album.getAssetListRange(start: 0, end: 1),
                                builder: (context, snapshot) {
                                  final assets = snapshot.data;
                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      assets != null &&
                                      assets.isNotEmpty) {
                                    final firstAsset = assets.first;
                                    return Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: AssetEntityImage(
                                          firstAsset,
                                          isOriginal: false,
                                          thumbnailSize:
                                              const ThumbnailSize.square(70),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                              const SizedBox(width: 16),
                              Column(
                                children: [
                                  Text(
                                    album.name,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: album == selectedAlbum
                                          ? Colors.blue
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$assetCount ${assetCount > 1 ? 'items' : 'item'}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // chevron right icon
                          const Spacer(),
                          Icon(
                            Icons.chevron_right,
                            color: album == selectedAlbum
                                ? Colors.blue
                                : Colors.black,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
