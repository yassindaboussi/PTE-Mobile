import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../const/const.dart';
import '../user_profile/cv_screen.dart';
import 'pte_app_theme.dart';

class UserListView extends StatefulWidget {
  const UserListView({
    required this.userData,
    required this.callback,
    Key? key,
  }) : super(key: key);

  final VoidCallback callback;
  final Map<String, dynamic> userData;

  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  bool _isExpanded = false;

  Future<String> _getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String role = prefs.getString('role') ?? 'user';
    return role;
  }

  void _showEmployeeDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          '$serverPathimage/${widget.userData['image'] ?? ''}',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Employee\'s Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text('Full Name: ${widget.userData['fullName']}'),
                      Text('Title: ${widget.userData['title']}'),
                      Text('Email: ${widget.userData['email']}'),
                      Text('Phone: ${widget.userData['phone']}'),
                      Text('Address: ${widget.userData['address']}'),
                      Text(
                        'Date Of Birth: ${widget.userData['DateOfBirth'].split('T')[0]}',
                      ),
                      Text(
                        'Hiring Date: ${widget.userData['hiringDate'].split('T')[0]}',
                      ),
                      Text('Department: ${widget.userData['department']}'),
                      Text('Role: ${widget.userData['roles'][0]}'),
                      Text('Nationality: ${widget.userData['nationality']}'),
                      Text('Experience: ${widget.userData['experience']} year(s)'),
                      SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Close',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 8,
        bottom: 16,
      ),
      child: Material(
        elevation: 4,
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: ExpansionTile(
              initiallyExpanded: _isExpanded,
              onExpansionChanged: (expanded) {
                setState(() {
                  _isExpanded = expanded;
                });
              },
              title: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        '$serverPathimage/${widget.userData['image']}',
                      ),
                      radius: 32,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Container(
                          color:
                          PteAppTheme.buildLightTheme().colorScheme.background,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              top: 8,
                              bottom: 8,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.userData['fullName'],
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.8,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      widget.userData['roles'][0],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        widget.userData['department'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        widget.userData['title'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.info_outline, color: Colors.blue),
                      onPressed: () {
                        _showEmployeeDetailsDialog(context);
                      },
                    ),
                    Row(
                      children: <Widget>[
                        // Show the delete icon only if the user has the role of admin
                        FutureBuilder<String>(
                          future: _getUserRole(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data == 'admin') {
                              return IconButton(
                                icon: Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () {
                                  print("Delete");
                                },
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.open_in_new, color: PteAppTheme.buildLightTheme().primaryColor),
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            Navigator.push<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) =>
                                    CVScreen(userId: widget.userData['_id']),
                                fullscreenDialog: true,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
