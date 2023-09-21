import 'package:flutter/material.dart';

import '../connect/login.dart';
import '../const/app_theme.dart';
import '../const/const.dart';
import '../service/ServiceUser.dart';
import '../user_management/pte_app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({
    required this.screenIndex,
    required this.iconAnimationController,
    required this.callBackIndex,
    super.key,
  });

  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}




class _HomeDrawerState extends State<HomeDrawer> {
  late final List<DrawerList> drawerList;
  late SharedPreferences prefs;
  String? Userimage;
  String _userName = '';


  @override
  void initState() {
    super.initState();
    setDrawerListArray();
    loadImage();
    loadNomUser();
  }

  Future<void> loadImage() async {
    prefs = await SharedPreferences.getInstance();
    Userimage = prefs.getString('image');
    setState(() {});
  }



  Future<void> loadNomUser() async {
    prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final id = prefs.getString('userId');

    try {
      final userData = await getUserById(id!, token!);
      final fullName = userData['fullName'];
      setState(() {
        _userName = fullName;
      });
    } catch (e) {
      print('Error: $e');
    }
  }



  void setDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.home,
        labelName: 'Home',
        icon: const Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.usermanagement,
        labelName: 'User Management',
       // isAssetsImage: true,
        //imageName: 'assets/images/supportIcon.png',
        icon: const Icon(Icons.person_2_outlined),
      ),
      DrawerList(
        index: DrawerIndex.room,
        labelName: 'Conference rooms',
        icon: const Icon(Icons.meeting_room),
      ),
      DrawerList(
        index: DrawerIndex.technicalteam,
        labelName: 'Technical Team',
        icon: const Icon(Icons.group),
      ),
      DrawerList(
        index: DrawerIndex.vehicule,
        labelName: 'Vehicles',
        icon: const Icon(Icons.car_rental),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.notWhite.withOpacity(0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, _) {
                      return ScaleTransition(
                        scale: AlwaysStoppedAnimation<double>(
                            1.0 - (widget.iconAnimationController.value) * 0.2),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation<double>(Tween<double>(
                                      begin: 0.0, end: 24.0)
                                  .animate(CurvedAnimation(
                                      parent: widget.iconAnimationController,
                                      curve: Curves.fastOutSlowIn))
                                  .value /
                              360),
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: AppTheme.grey.withOpacity(0.6),
                                  offset: const Offset(2.0, 4.0),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(60.0)),
                              child: (Userimage != null)
                                  ? Image(
                                image: NetworkImage('$serverPathimage/$Userimage'),
                                fit: BoxFit.cover, // Set the fit property to BoxFit.cover
                              )
                                  : Image.asset(
                                'assets/images/userImage.png',
                                fit: BoxFit.cover, // Set the fit property to BoxFit.cover
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                   Padding(
                    padding: EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      _userName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.grey,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList[index]);
              },
            ),
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Column(
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: InkWell(
                  child: ListTile(
                    title: const Text(
                      'Sign Out',
                      style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppTheme.darkText,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    trailing: const Icon(
                      Icons.power_settings_new,
                      color: Colors.red,
                    ),
                    onTap: () { // Logout
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index);
        },
        child: Container(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Row(
            children: <Widget>[
              const SizedBox(
                width: 6.0,
                height: 46.0,
              ),
              const Padding(
                padding: EdgeInsets.all(4.0),
              ),
              if (listData.isAssetsImage)
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(listData.imageName,
                      color: widget.screenIndex == listData.index
                          ? PteAppTheme.buildLightTheme().primaryColor
                          : AppTheme.nearlyBlack),
                )
              else
                Icon(listData.icon?.icon,
                    color: widget.screenIndex == listData.index
                        ? PteAppTheme.buildLightTheme().primaryColor
                        : AppTheme.nearlyBlack),
              const Padding(
                padding: EdgeInsets.all(4.0),
              ),
              Text(
                listData.labelName,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: widget.screenIndex == listData.index
                      ? PteAppTheme.buildLightTheme().primaryColor
                      : AppTheme.nearlyBlack,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          decoration: widget.screenIndex == listData.index
              ? BoxDecoration(
            color: Colors.blue.withOpacity(0.2),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
          )
              : null,
        ),
      ),
    );
  }


  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }
}

enum DrawerIndex { home, usermanagement, vehicule , room , technicalteam}

class DrawerList {
  DrawerList({
    required this.index,
    this.icon,
    this.isAssetsImage = false,
    this.labelName = '',
    this.imageName = '',
  });

  String labelName;
  Icon? icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;
}
