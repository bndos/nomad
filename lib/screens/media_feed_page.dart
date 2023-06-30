import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nomad/utils/media_source_handler.dart';
import 'package:nomad/widgets/appbar/title_app_bar.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaFeedPage extends StatefulWidget {
  final int index;
  final List<AssetEntity>? assets;
  final List<Image>? images;
  final List<String>? imageUrls;

  const MediaFeedPage({
    Key? key,
    this.imageUrls,
    this.images,
    this.assets,
    this.index = 0,
  }) : super(key: key);

  @override
  State<MediaFeedPage> createState() => _MediaFeedPageState();
}

class _MediaFeedPageState extends State<MediaFeedPage> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> medias = getMediaListWidgets(
      imageUrls: widget.imageUrls,
      images: widget.images,
      assets: widget.assets,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
    );
    return Scaffold(
      extendBodyBehindAppBar: true, // Set to true to extend body behind AppBar
      appBar: TitleAppBar(
        backgroundColor: Colors.transparent,
        title: '',
        leftIcon: FontAwesomeIcons.chevronLeft,
        rightIcon: Iconsax.repeat,
        onLeftIconPressed: () => Navigator.pop(context),
      ),
      body: PageView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: medias.length,
        itemBuilder: (context, index) {
          return medias[index];
        },
      ),
    );
  }
}
