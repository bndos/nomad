import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget leftWidget;
  final Widget centerWidget;
  final Widget rightWidget;

  const CustomAppBar({
    Key? key,
    required this.leftWidget,
    required this.centerWidget,
    required this.rightWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 34,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                alignment: Alignment.center,
                color: Colors.transparent,
                // we can set width here with conditions
                width: 40,
                height: kToolbarHeight,
                child: leftWidget,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: centerWidget,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                alignment: Alignment.center,
                color: Colors.transparent,
                // we can set width here with conditions
                width: 40,
                height: kToolbarHeight,
                child: rightWidget,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(200, kToolbarHeight);
}
