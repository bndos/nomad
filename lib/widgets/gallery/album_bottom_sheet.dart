// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumBottomSheet extends StatelessWidget {
  final AssetPathEntity selectedAlbum;
  final List<AssetPathEntity> albums;
  final Function(AssetPathEntity) onAlbumSelected;

  const AlbumBottomSheet({
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
              return GestureDetector(
                onTap: () => onAlbumSelected(album),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      FutureBuilder<Widget>(
                        future: album.getAssetListRange(start: 0, end: 1).then(
                              (assets) => assets.isNotEmpty
                                  ? Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: AssetEntityImage(
                                          assets.first,
                                          isOriginal: false,
                                          thumbnailSize:
                                              const ThumbnailSize.square(70),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.data != null) {
                            return snapshot.data!;
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
                            album.assetCount > 1
                                ? '${album.assetCount} items'
                                : '${album.assetCount} item',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
