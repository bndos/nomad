// statefullwidget MediaPicker
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nomad/services/media_service.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaPicker extends StatefulWidget {
  final RequestType requestType;
  const MediaPicker({super.key, required this.requestType});

  @override
  State<MediaPicker> createState() => _MediaPickerState();
}

class _MediaPickerState extends State<MediaPicker> {
  AssetPathEntity? album;
  List<AssetPathEntity> albums = [];
  List<AssetEntity> assets = [];
  List<AssetEntity> selectedAssets = [];

  @override
  void initState() {
    MediaService().loadAlbums(widget.requestType).then((value) {
      setState(() {
        albums = value;
        album = albums[0];
      });
      MediaService().loadAssets(album!).then((value) {
        setState(() {
          assets = value;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: DropdownButton<AssetPathEntity>(
            value: album,
            onChanged: (AssetPathEntity? value) {
              setState(() {
                album = value;
              });
              MediaService().loadAssets(album!).then((value) {
                setState(() {
                  assets = value;
                });
              });
            },
            items: albums.map<DropdownMenuItem<AssetPathEntity>>((value) {
              return DropdownMenuItem<AssetPathEntity>(
                value: value,
                child: Text(value.name),
              );
            }).toList(),
          ),
        ),
        body: assets.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: assets.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  AssetEntity asset = assets[index];
                  return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: assetWidget(asset),
                  );
                },
              ),
      ),
    );
  }

  Widget assetWidget(AssetEntity assetEntity) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedAssets.add(assetEntity);
                });
              },
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
          ),
          if (selectedAssets.contains(assetEntity))
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAssets.remove(assetEntity);
                  });
                },
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          Positioned(
            top: 5,
            right: 5,
            child: Icon(
              selectedAssets.contains(assetEntity)
                  ? Iconsax.tick_circle1
                  : CupertinoIcons.circle,
              color: Colors.white,
            ),
          ),
        ],
      );
}
