import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nomad/services/media_service.dart';
import 'package:nomad/widgets/appbar/custom_app_bar.dart';
import 'package:nomad/widgets/gallery/album_picker_sheet.dart';
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

  void _showAlbumBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return AlbumPickerSheet(
          selectedAlbum: album!,
          albums: albums,
          onAlbumSelected: (selectedAlbum) {
            setState(() {
              album = selectedAlbum;
              assets.clear();
            });
            MediaService().loadAssets(album!).then((value) {
              setState(() {
                assets = value;
              });
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leftWidget: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.black,
          ),
        ),
        centerWidget: SizedBox(
          height: 30,
          child: TextButton.icon(
            onPressed: () {
              // Handle album selection
              _showAlbumBottomSheet();
            },
            icon: const Icon(
              FontAwesomeIcons.chevronDown,
              color: Colors.white,
              size: 10,
            ),
            label: Text(
              album?.name ?? 'No album',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            ),
          ),
        ),
        rightWidget: selectedAssets.isNotEmpty
            ? IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.check_circle,
                  color: Colors.black,
                ),
              )
            : Container(),
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
