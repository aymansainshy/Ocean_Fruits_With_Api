import 'package:flutter/material.dart';

class BuildDrawerList extends StatelessWidget {
  final Widget leading;
  final String title;
  final Function onTap;

  const BuildDrawerList({
    Key key,
    @required this.leading,
    @required this.title,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: ListTile(
        leading: leading,
        trailing: Icon(
          Icons.navigate_next,
          color: Colors.white,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
