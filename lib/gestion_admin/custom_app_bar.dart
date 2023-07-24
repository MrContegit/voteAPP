import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CustomAppBar extends StatelessWidget {
  final IconData leftIcon;
  final IconData rightIcon;
  final Function? leftCallback;

  const CustomAppBar({this.leftCallback, required this.leftIcon, required this.rightIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 25,
        right: 25,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: leftCallback !=null ? ()=>leftCallback!(): null,
            child: _buildIcon(leftIcon),
          ),
          _buildIcon(rightIcon),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon) {
    return Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(icon),
          );
  }
}