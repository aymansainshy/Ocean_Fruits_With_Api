import 'package:flutter/material.dart';

import '../utils/app_constant.dart';
import '../providers/cart_provider.dart';

class BuildCartStack extends StatefulWidget {
  final Carts carts;

  const BuildCartStack({Key key, this.carts}) : super(key: key);

  @override
  _BuildCartStackState createState() => _BuildCartStackState();
}

class _BuildCartStackState extends State<BuildCartStack> {
  @override
  Widget build(BuildContext context) {
    if (widget.carts.items.isEmpty) {
      return Stack(
        overflow: Overflow.visible,
        alignment: Alignment.topRight,
        children: [
          Container(
            height: 30,
            child: Image.asset(
              "assets/icons/cart stroke.png",
              color: Colors.white,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(),
        ],
      );
    } else {
      return Stack(
        overflow: Overflow.visible,
        alignment: Alignment.topRight,
        children: [
          Container(
            height: 30,
            child: Image.asset(
              "assets/icons/cart stroke.png",
              color: Colors.white,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            right: -5,
            child: CircleAvatar(
              radius: 9,
              backgroundColor: AppColors.redColor,
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    "${widget.carts.itemCount}",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
      ;
    }
  }
}
