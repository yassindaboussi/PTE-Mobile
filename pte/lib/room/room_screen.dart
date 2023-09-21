import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/ServiceRoom.dart';
import '../user_management/pte_app_theme.dart';
import 'calendarRoom.dart';
import 'dialog/AddRoomDialog.dart';
import 'dialog/DeleteRoomDialog.dart';
import 'dialog/EditRoomDialog.dart';


class RoomScreen extends StatefulWidget {
  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  List<dynamic> _rooms = [];

  String _userRole = '';
  @override
  void initState() {
    super.initState();

    _loadRooms();
    _getUserRoleOnStartup();
  }

  Future<void> _loadRooms() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token != null) {
      final List<Map<String, dynamic>> rooms = await getRooms(token);
      setState(() {
        _rooms = rooms;
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Token Error'),
            content: Text('Token is not available.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
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
            child: _rooms.isEmpty
                ? Center(
              child: CircularProgressIndicator(),
            )
                :
            ListView.builder(
              itemCount: _rooms.length,
              itemBuilder: (context, index) {
                final room = _rooms[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
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
                        child: ExpansionTile(
                          initiallyExpanded: false,
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 8),
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(14)),
                                  color: Colors.blueGrey.shade200,
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/myroom.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Label: ${room['label']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text('Location: ${room['location']}'),
                                  Text('Capacity: ${room['capacity']}'),
                                ],
                              ),
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
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      _showEditRoomDialog(room);
                                    },
                                  ),
                                if (_userRole == 'admin')
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _showDeleteRoomDialog(room['_id']);
                                    },
                                  ),
                                IconButton(
                                  icon: Icon(Icons.calendar_today, color: Colors.orange),
                                  onPressed: () {
                                    Navigator.push<dynamic>(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) => CalendarRoom(
                                          roomId: room['_id'],
                                        ),
                                        fullscreenDialog: true,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
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
                    _showAddRoomDialog();
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
                      _performSearch(txt);
                      print(txt);
                    },
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: PteAppTheme.buildLightTheme().primaryColor,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Label/Location',
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
                    'Rooms',
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



  void _performSearch(String query) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    print("token ======>>>> " +token!);
    List<Map<String, dynamic>> results = [];

    try {
      if (query.isEmpty) {
        await _loadRooms();
      } else {
        final dynamic rawResults = await searchRooms(query, token!);

        results = (rawResults as List<dynamic>).cast<Map<String, dynamic>>();
      }

      if (results.isEmpty) {
        await _loadRooms();
      } else {
        setState(() {
          _rooms = results;
        });
      }
    } catch (e) {
      print('Error while searching cars: $e');
    }
  }






  void _showAddRoomDialog() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddRoomDialog(
          onAddRoom: (
              String label,
              String location,
              int capacity,
              ) async {
            Map<String, dynamic> newRoom = {
              "capacity": capacity,
              "label": label,
              "location": location
            };
            try {
              await addRoom(token!, newRoom);
              _loadRooms();
            } catch (e) {
              print('Error while adding Room: $e');
            }
          },
        );
      },
    );
  }

  void _showDeleteRoomDialog(String Id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteRoomDialog(
          onDeleteRoom: () async {
            await deleteRoom(token!,Id);
            _loadRooms();
          },
        );
      },
    );
  }


  void _showEditRoomDialog(Map<String, dynamic> room) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditRoomDialog(
          existingLabel: room['label'],
          existingLocation: room['location'],
          existingCapacity: room['capacity'],
          onEditRoom: (
              String label,
              String location,
              int capacity,
              ) async {
            Map<String, dynamic> updatedRoom = {
              "capacity": capacity,
              "label": label,
              "location": location
            };
            try {
              await updateRoom(token!, room['_id'], updatedRoom);
              _loadRooms();
            } catch (e) {
              print('Error while updating room: $e');
            }
          },
        );
      },
    );
  }





}
