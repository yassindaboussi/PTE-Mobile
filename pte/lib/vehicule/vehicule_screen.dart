import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/ServiceVehicule.dart';
import '../user_management/pte_app_theme.dart';
import 'calendarVehicule.dart';
import 'dialog/AddVehiculeDialog.dart';
import 'dialog/DeleteVehiculeDialog.dart';
import 'dialog/EditVehiculeDialog.dart';

class VehicleScreen extends StatefulWidget {
  @override
  _VehicleScreenState createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  List<dynamic> _vehicles = [];

  String _userRole = '';
  @override
  void initState() {
    super.initState();

    _loadVehicles();
    _getUserRoleOnStartup();
  }

  Future<void> _loadVehicles() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token != null) {
      final List<Map<String, dynamic>> vehicles = await getVehicles(token);
      setState(() {
        _vehicles = vehicles;
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
            child: _vehicles.isEmpty
                ? Center(
              child: CircularProgressIndicator(),
            )
                : ListView.builder(
              itemCount: _vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = _vehicles[index];
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 8, bottom: 16),
                  child: Material(
                    elevation: 4,
                    borderRadius:
                    const BorderRadius.all(Radius.circular(16.0)),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(16.0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                right: 8, left: 8, top: 8, bottom: 8),
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(14)),
                              color: Colors.orange.shade200,
                              image: DecorationImage(
                                image: AssetImage('assets/images/mycar.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(16.0)),
                              child: ExpansionTile(
                                initiallyExpanded: false,
                                title: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Model: ${vehicle['model']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                        'Number: ${vehicle['registration_number']}'),
                                    Text('Type: ${vehicle['type']}'),
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
                                          icon: Icon(Icons.edit,
                                              color: Colors.blue),
                                          onPressed: () {
                                            _showEditVehiculeDialog(
                                                vehicle);
                                          },
                                        ),
                                      if (_userRole == 'admin')
                                        IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            _showDeleteVehiculeDialog(
                                                vehicle['_id']);
                                          },
                                        ),
                                      IconButton(
                                        icon: Icon(Icons.calendar_today,
                                            color: Colors.orange),
                                        onPressed: () {
                                          Navigator.push<dynamic>(
                                            context,
                                            MaterialPageRoute<dynamic>(
                                              builder:
                                                  (BuildContext context) =>
                                                  CalendarVehicule(
                                                    vehicleId: vehicle['_id'],
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
                        ],
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
                    _showAddVehiculeDialog();
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
                      hintText: 'Enter Model...',
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
                    'Véhicules',
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
    List<Map<String, dynamic>> results = [];

    try {
      if (query.isEmpty) {
        await _loadVehicles();
      } else {
        final dynamic rawResults = await searchVehicles(query, token!);

        results = (rawResults as List<dynamic>).cast<Map<String, dynamic>>();
      }

      if (results.isEmpty) {
        await _loadVehicles();
      } else {
        setState(() {
          _vehicles = results;
        });
      }
    } catch (e) {
      print('Error while searching cars: $e');
    }
  }






  void _showAddVehiculeDialog() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddVehiculeDialog(
          onAddVehicule: (
              String model,
              String registration_number,
              String type,
              ) async {

            Map<String, dynamic> newVehicule = {
                "model": model,
                "registration_number": registration_number,
                "type": type,
            };
            try {
             await addVehicule(token!, newVehicule);
              _loadVehicles();
            } catch (e) {
              print('Error while adding CV: $e');
            }
          },
        );
      },
    );
  }


  void _showEditVehiculeDialog(Map<String, dynamic> vehicle) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditVehiculeDialog(
          existingModel: vehicle['model'],
          existingRegistrationNumber: vehicle['registration_number'],
          existingType: vehicle['type'],
          onEditVehicule: (
              String model,
              String registrationNumber,
              String type,
              ) async {
            Map<String, dynamic> updatedVehicle = {
              "model": model,
              "registration_number": registrationNumber,
              "type": type,
            };
            try {
              await updateVehicule(token!, vehicle['_id'], updatedVehicle);
              _loadVehicles();
            } catch (e) {
              print('Error while updating vehicle: $e');
            }
          },
        );
      },
    );
  }

  void _showDeleteVehiculeDialog(String vehicleId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteVehiculeDialog(
          onDeleteVehicule: () async {
            await deleteVehicule(token!,vehicleId);
            _loadVehicles();
          },
        );
      },
    );
  }



}