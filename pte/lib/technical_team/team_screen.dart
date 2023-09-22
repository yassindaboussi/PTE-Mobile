import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../user_management/pte_app_theme.dart';


class TeamScreen extends StatefulWidget {
  @override
  _TeamScreenState createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  List<dynamic> _team = [];

  String _userRole = '';
  @override
  void initState() {
    super.initState();

    _loadTeam();
    _getUserRoleOnStartup();
  }

  Future<void> _loadTeam() async {
    String data = await rootBundle.loadString('assets/data.json');
    List<dynamic> teamData = jsonDecode(data);
    setState(() {
      _team = teamData;
    });
  }



  Future<String> _getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String role = prefs.getString('role') ?? 'user';
    return role;
  }

  void _getUserRoleOnStartup() async {
    _userRole = await _getUserRole();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: getAppBarUI(),
      ),
      body: Column(
        children: [
          getSearchBarUI(),
          Expanded(
            child: _team.isEmpty
                ? Center(
              child: CircularProgressIndicator(),
            )
                : ListView.builder(
              itemCount: _team.length,
              itemBuilder: (context, index) {
                final TechnicalTeam = _team[index];
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 8, bottom: 16),
                  child: Material(
                    elevation: 4,
                    borderRadius:
                    const BorderRadius.all(Radius.circular(16.0)),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(16.0)),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(16.0)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Add the image on the left
                            Container(
                              margin: EdgeInsets.all(8.0),
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(14)),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      TechnicalTeam['image']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ExpansionTile(
                                initiallyExpanded: false,
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${TechnicalTeam['fullname']}',
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.8,
                                      ),
                                    ),
                                    Text('${TechnicalTeam['email']}',
                                      style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.withOpacity(0.8),
                                    )
                                    ),
                                    Text('${TechnicalTeam['phone']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.withOpacity(0.8),
                                      ),
                                    ),
                                    Text('${TechnicalTeam['experienceLevel']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.withOpacity(0.8),
                                      ),
                                    ),
                                    Text('${TechnicalTeam['specialization']}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.withOpacity(0.8),
                                        )),
                                  ],
                                ),
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      // Only show the icons for admin users
                                      if (_userRole == 'admin')
                                        IconButton(
                                          icon: Icon(
                                              Icons.edit, color: Colors.blue),
                                          onPressed: () {
                                            //_showEditVehiculeDialog(vehicle);
                                          },
                                        ),
                                      if (_userRole == 'admin')
                                        IconButton(
                                          icon: Icon(
                                              Icons.delete, color: Colors.red),
                                          onPressed: () {
                                            //_showDeleteVehiculeDialog(vehicle['_id']);
                                          },
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
                },
            ),
          ),
        ],
      ),
    );
  }

  Widget getSearchBarUI() {
    bool isAdmin = _userRole == 'admin';

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          // Show the Container only if the user is an admin
          if (isAdmin)
            Container(
              decoration: BoxDecoration(
                color: PteAppTheme.buildLightTheme().primaryColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(38.0),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    //_showAddVehiculeDialog();
                    //FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(
                      FontAwesomeIcons.add,
                      size: 10,
                      color: PteAppTheme.buildLightTheme().colorScheme.background,
                    ),
                  ),
                ),
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16,right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: PteAppTheme.buildLightTheme().colorScheme.background,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: const Offset(0, 2),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    onChanged: (String txt) {
                     // _performSearch(txt);
                      print(txt);
                    },
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: PteAppTheme.buildLightTheme().primaryColor,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Name...',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: PteAppTheme.buildLightTheme().colorScheme.background,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            offset: const Offset(0, 2),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 10,
          left: 8,
          right: 8,
          bottom: 8,
        ),
        child: Material(
          child: Row(
            children: <Widget>[
              const Expanded(
                child: Center(
                  child: Text(
                    'Technical Team',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



}
