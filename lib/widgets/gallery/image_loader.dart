import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

class ImageLoader extends StatefulWidget {
  final String? imageUrl;
  final AssetEntity? assentEntity;
  final double width;
  final double height;

  const ImageLoader({
    Key? key,
    required this.width,
    required this.height,
    this.assentEntity,
    this.imageUrl,
  }) : super(key: key);

  @override
  State<ImageLoader> createState() => _ImageLoaderState();
}

class _ImageLoaderState extends State<ImageLoader> {
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    File? videoFile;

    if (widget.assentEntity != null) {
      if (widget.assentEntity!.type == AssetType.video) {
        videoFile = await widget.assentEntity!.file;

        setState(() {
          _videoPlayerController = VideoPlayerController.file(videoFile!);
        });
        _videoPlayerController!.initialize().then((_) {
          setState(() {});
        });
        _videoPlayerController!.setLooping(true);
        // _videoPlayerController!.play();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrl == null && widget.assentEntity == null) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey[300],
      );
    }

    if (widget.assentEntity != null) {
      if (widget.assentEntity!.type == AssetType.video) {
        if (_videoPlayerController != null &&
            _videoPlayerController!.value.isInitialized) {
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: ClipRRect(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: widget.width,
                  height:
                      widget.width / _videoPlayerController!.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController!),
                ),
              ),
            ),
          );
        }
        return Container(
          width: widget.width,
          height: widget.height,
          color: Colors.grey[300],
        );
      }
      return ClipRRect(
        child: AssetEntityImage(
          widget.assentEntity!,
          width: widget.width,
          height: widget.height,
          fit: BoxFit.cover,
        ),
      );
    }

    if (widget.imageUrl!.startsWith('http')) {
      return ClipRRect(
        child: CachedNetworkImage(
          imageUrl: widget.imageUrl!,
          fit: BoxFit.cover,
          width: widget.width,
          height: widget.height,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      );
    } else {
      return ClipRRect(
        child: Image.file(
          File(widget.imageUrl!),
          fit: BoxFit.cover,
          width: widget.width,
          height: widget.height,
        ),
      );
    }
  }
}
