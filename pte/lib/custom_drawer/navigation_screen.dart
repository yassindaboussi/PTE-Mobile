import 'package:flutter/material.dart';

import '../room/room_screen.dart';
import '../technical_team/team_screen.dart';
import '../vehicule/vehicule_screen.dart';
import 'drawer_user_controller.dart';
import 'home_drawer.dart';
import '../home_screen.dart';
import '../user_management/user_home_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  Widget screenView = const MyHomePage();
  DrawerIndex drawerIndex = DrawerIndex.home;

  @override
  Widget build(BuildContext context) {
    return DrawerUserController(
      screenIndex: drawerIndex,
      drawerWidth: MediaQuery.of(context).size.width * 0.75,
      onDrawerCall: (DrawerIndex drawerIndexdata) {
        changeIndex(drawerIndexdata);
        //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
      },
      screenView: screenView,
      //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.home) {
        if (mounted) {
          setState(() {
            screenView = const MyHomePage();
          });
        }
      } else if (drawerIndex == DrawerIndex.usermanagement) {
        if (mounted) {
          setState(() {
            screenView = const UserHomeScreen();
          });
        }
      } else if (drawerIndex == DrawerIndex.vehicule) {
        if (mounted) {
          setState(() {
            screenView = VehicleScreen();
          });
        }
      }
      else if (drawerIndex == DrawerIndex.room) {
        if (mounted) {
          setState(() {
            screenView = RoomScreen();
          });
        }
      }
      else if (drawerIndex == DrawerIndex.technicalteam) {
        if (mounted) {
          setState(() {
            screenView = TeamScreen();
          });
        }
      }
    }
  }
}
