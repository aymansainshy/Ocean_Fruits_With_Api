import 'package:flutter/material.dart';

import '../../../core/utils/app_constant.dart';
import '../provider/cart_provider.dart';

class BuildCartStack extends StatelessWidget {
  final Carts carts;

  const BuildCartStack({Key key, this.carts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (carts.items.isEmpty) {
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
                    "${carts.itemCount}",
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
    }
  }
}
