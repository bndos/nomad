import 'package:flutter/material.dart';

class TitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData leftIcon;
  final VoidCallback? onLeftIconPressed;
  final IconData rightIcon;
  final VoidCallback? onRightIconPressed;

  const TitleAppBar({
    Key? key,
    required this.title,
    required this.leftIcon,
    this.onLeftIconPressed,
    required this.rightIcon,
    this.onRightIconPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(top: 30, left: 10),
              alignment: Alignment.center,
              color: Colors.transparent,
              // we can set width here with conditions
              width: 40,
              height: kToolbarHeight,
              child: IconButton(
                icon: Icon(
                  leftIcon,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: onLeftIconPressed ?? () {},
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.only(top: 30, right: 10),
              alignment: Alignment.center,
              color: Colors.transparent,
              // we can set width here with conditions
              width: 40,
              height: kToolbarHeight,
              child: IconButton(
                icon: Icon(
                  rightIcon,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: onRightIconPressed ?? () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size(200, kToolbarHeight);
}
