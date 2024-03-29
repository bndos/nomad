import 'package:flutter/material.dart';
import 'package:nomad/widgets/appbar/custom_app_bar.dart';

class TitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData leftIcon;
  final VoidCallback? onLeftIconPressed;
  final IconData rightIcon;
  final VoidCallback? onRightIconPressed;
  final Color backgroundColor;

  const TitleAppBar({
    Key? key,
    required this.title,
    required this.leftIcon,
    this.onLeftIconPressed,
    required this.rightIcon,
    this.onRightIconPressed,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: CustomAppBar(
        backgroundColor: backgroundColor,
        leftWidget: IconButton(
          icon: Icon(
            leftIcon,
            color: Colors.black,
            size: 20,
          ),
          onPressed: onLeftIconPressed ?? () {},
        ),
        centerWidget: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        rightWidget: IconButton(
          icon: Icon(
            rightIcon,
            color: Colors.black,
            size: 20,
          ),
          onPressed: onRightIconPressed ?? () {},
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(200, kToolbarHeight);
}
