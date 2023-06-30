import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nomad/widgets/appbar/title_app_bar.dart';

class MediaFeedPage extends StatelessWidget {
  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
  ];

  MediaFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
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
        itemCount: colors.length,
        itemBuilder: (context, index) {
          return Container(
            color: colors[index],
          );
        },
      ),
    );
  }
}
