// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:flutter/material.dart';

import 'contains.dart';

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool hasNavigation;

  const ProfileListItem({
    Key key,
    this.icon,
    this.text,
    this.hasNavigation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ).copyWith(
        bottom: 20,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
              Color.fromRGBO(255, 232, 208, 1),
              Color.fromRGBO(253, 219, 195, 1),
              Color.fromRGBO(253, 208, 182, 1),
              Color.fromRGBO(248, 185, 165, 1),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: kLightBlack,
              offset: Offset(3, 8),
              blurRadius: 10,
              spreadRadius: 4,
            ),
          ]),
      child: Row(
        children: <Widget>[
          Icon(
            this.icon,
            size: 20,
          ),
          SizedBox(width: 15),
          Text(
            this.text,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          if (this.hasNavigation)
            Icon(
              Icons.arrow_forward_ios_outlined,
              size: 25,
            ),
        ],
      ),
    );
  }
}
