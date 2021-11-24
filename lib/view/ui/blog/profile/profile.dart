// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'profile_list_item.dart';
import 'contains.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(176, 190, 197, 1),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppBarButton(
                        icon: Icons.arrow_back,
                      ),
                      Icon(FontAwesomeIcons.tasks)
                    ],
                  ),
                ),
                AvatarImage(),
                SizedBox(
                  height: 30,
                ),
                SocialIcons(),
                SizedBox(height: 30),
                Text(
                  'MSMAR Group',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '@msmargroup',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'MSMAR company for software solutions Innovative projects in the world of web design and mobile applications.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                ProfileListItems(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AppBarButton extends StatelessWidget {
  final IconData icon;

  const AppBarButton({this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => back(context),
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromRGBO(251, 235, 245, 1),
            boxShadow: [
              BoxShadow(
                color: kLightBlack,
                offset: Offset(3, 5),
                blurRadius: 10,
                spreadRadius: 3,
              ),
            ]),
        child: Icon(
          icon,
          color: Colors.black,
        ),
      ),
    );
  }

  back(BuildContext context) => Navigator.pop(context);
}

class AvatarImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      height: 190,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blueAccent,
        boxShadow: [
          BoxShadow(
            color: kLightBlack,
            offset: Offset(3, 8),
            blurRadius: 10,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Container(
        // decoration: avatarDecoration,
        // padding: EdgeInsets.all(3),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.contain,
              image: NetworkImage(
                  "https://cdn.discordapp.com/attachments/692449043833552946/909875006887043112/wde_2.jpg"),
            ),
          ),
        ),
      ),
    );
  }
}

class SocialIcons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SocialIcon(
          color: Color(0xFF102397),
          iconData: FontAwesomeIcons.facebookF,
          onPressed: () {},
        ),
        SocialIcon(
          color: Color(0xFFff4f38),
          iconData: FontAwesomeIcons.googlePlusG,
          onPressed: () {},
        ),
        SocialIcon(
          color: Color(0xFF38A1F3),
          iconData: FontAwesomeIcons.twitter,
          onPressed: () {},
        ),
        SocialIcon(
          color: Color(0xFF2867B2),
          iconData: FontAwesomeIcons.linkedinIn,
          onPressed: () {},
        )
      ],
    );
  }
}

class SocialIcon extends StatelessWidget {
  final Color color;
  final IconData iconData;
  final Function onPressed;

  SocialIcon({this.color, this.iconData, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Container(
        width: 45.0,
        height: 45.0,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: RawMaterialButton(
          shape: CircleBorder(),
          onPressed: onPressed,
          child: Icon(iconData, color: Colors.white),
        ),
      ),
    );
  }
}

class ProfileListItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: <Widget>[
          ProfileListItem(
            icon: FontAwesomeIcons.userShield,
            text: 'Privacy',
          ),
          ProfileListItem(
            icon: FontAwesomeIcons.history,
            text: 'Purchase History',
          ),
          ProfileListItem(
            icon: FontAwesomeIcons.questionCircle,
            text: 'Help & Support',
          ),
          ProfileListItem(
            icon: FontAwesomeIcons.cog,
            text: 'Settings',
          ),
          ProfileListItem(
            icon: FontAwesomeIcons.userPlus,
            text: 'Invite a Friend',
          ),
          ProfileListItem(
            icon: FontAwesomeIcons.signOutAlt,
            text: 'Logout',
            hasNavigation: false,
          ),
        ],
      ),
    );
  }
}
