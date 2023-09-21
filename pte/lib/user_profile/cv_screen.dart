import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pte/service/ServiceUser.dart';
import '../const/const.dart';
import '../user_management/pte_app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dialog/AddCertificationDialog.dart';
import 'dialog/AddProjectDialog.dart';
import 'dialog/AddEducationDialog.dart';
import 'dialog/AddExperienceDialog.dart';
import 'dialog/EditProfileDialog.dart';
import 'dialog/EditProfileImageDialog.dart';
import 'package:pte/service/ServiceCV.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;


class CVScreen extends StatefulWidget {
  final String userId;
  const CVScreen({required this.userId, Key? key}) : super(key: key);

  @override
  State<CVScreen> createState() => _CVScreenState();
}

class _CVScreenState extends State<CVScreen> {
  Future<Map<String, dynamic>>? _userFuture;

  @override
  void initState() {
    super.initState();
    _loadCV();
  }

  Future<void> _loadCV() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token != null) {
      setState(() {
        _userFuture = getUserById(widget.userId, token);
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context); // Pops the current page
          return false; // Prevents the default back button behavior
        },
    child : Material(
      color: PteAppTheme.buildLightTheme().colorScheme.background,
      child: Column(
        children: <Widget>[
          getAppBarUI(),
          FutureBuilder<Map<String, dynamic>>(
            future: _userFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final user = snapshot.data!;
                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        // Profile Image
                        GestureDetector(
                          onTap: () {
                            _showEditProfileImageDialog(context);
                          },
                          child: Container(
                            width: 150,
                            height: 150,
                            margin: EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage('$serverPathimage/${user['image'] ?? ''}'),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 5.0,
                                  spreadRadius: 2.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        // Basic Information
                        Card(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Informations',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: PteAppTheme.buildLightTheme().primaryColor,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      color: Colors.grey,
                                      onPressed: () {
                                        // TODO: Implement logic to add more information
                                        _showEditProfileDialog(widget.userId);
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text('Experience: ${user['experience'] ?? ''}+ years'),
                                Text('Department: ${user['department'] ?? ''}'),
                                Divider(color: Colors.grey),
                                SizedBox(height: 16),
                                Text('Location: ${user['address'] ?? ''}'),
                                Text('Nationality: ${user['nationality'] ?? ''}'),
                                Text('Gender: ${user['gender'] ?? ''}'),
                                Text('Family Situation: ${user['familySituation'] ?? ''}'),
                                Divider(color: Colors.grey),
                                SizedBox(height: 16),
                                Text(
                                  'Driving License: ${user['drivingLicense'] ?? false ? 'Yes' : 'No'}',
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Education Card
                        Card(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Education',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        color: PteAppTheme.buildLightTheme().primaryColor,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add_circle),
                                      color: Colors.grey,
                                      onPressed: () {
                                        _showAddEducationDialog(user['cv']?['_id']);
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount:
                                  user['cv']?['studies']?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    final education =
                                    user['cv']?['studies']?[index];
                                    if (education == null) {
                                      return SizedBox.shrink();
                                    }
                                    return ListTile(
                                      title: Text(education['diploma'] ?? ''),
                                      subtitle: Row(
                                        children: [
                                          Icon(Icons.work, color: Colors.grey, size: 16),
                                          SizedBox(width: 8),
                                          Text(education['establishment'] ?? ''),
                                          SizedBox(width: 16),
                                          Icon(Icons.calendar_today, color: Colors.grey, size: 16),
                                          SizedBox(width: 8),
                                          Text(education['year'] ?? ''),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          _showDeleteConfirmationDialog(user['cv']?['_id'],'studies',education?['_id']);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Experience Card
                        Card(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Experience',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        color: PteAppTheme.buildLightTheme().primaryColor),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add_circle),
                                      color: Colors.grey,
                                      onPressed: () {
                                        _showAddExperienceDialog(user['cv']?['_id']);
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount:
                                  user['cv']?['professionnal_career']
                                      ?.length ??
                                      0,
                                  itemBuilder: (context, index) {
                                    final experience =
                                    user['cv']?['professionnal_career']
                                    ?[index];
                                    if (experience == null) {
                                      return SizedBox.shrink();
                                    }
                                    return ListTile(
                                      title: Text(experience['job'] ?? ''),
                                      subtitle: Row(
                                        children: [
                                          Icon(Icons.work, color: Colors.grey, size: 16),
                                          SizedBox(width: 8),
                                          Text(experience['organization'] ?? ''),
                                          SizedBox(width: 16),
                                          Icon(Icons.calendar_today, color: Colors.grey, size: 16),
                                          SizedBox(width: 8),
                                          Text(experience['period'] ?? ''),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          _showDeleteConfirmationDialog(user['cv']?['_id'],'professionnal_career',experience?['_id']);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Projects Card
                        Card(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Projects',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: PteAppTheme.buildLightTheme().primaryColor),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add_circle),
                                      color: Colors.grey,
                                      onPressed: () {
                                        _showAddProjectDialog(user['cv']?['_id']);
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount:
                                  user['cv']?['projets']
                                      ?.length ??
                                      0,
                                  itemBuilder: (context, index) {
                                    final projet =
                                    user['cv']?['projets']
                                    ?[index];
                                    if (projet == null) {
                                      return SizedBox.shrink();
                                    }
                                    return ListTile(
                                      title: Text(projet['title'] ?? ''),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.work, color: Colors.grey, size: 16),
                                              SizedBox(width: 8),
                                              Text(projet['organization'] ?? ''),
                                            ],
                                          ),
                                          Text(projet['description'] ?? ''),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          _showDeleteConfirmationDialog(user['cv']?['_id'],'projets',projet?['_id']);
                                        },
                                      ),
                                    );

                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Certifications Card
                        Card(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Certifications',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: PteAppTheme.buildLightTheme().primaryColor),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add_circle),
                                      color: Colors.grey,
                                      onPressed: () {
                                        _showAddCertificationDialog(user['cv']?['_id']);
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: user['cv']?['certifications']?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    final certification = user['cv']?['certifications']?[index];
                                    if (certification == null) {
                                      return SizedBox.shrink();
                                    }
                                    return ListTile(
                                      title: Text(certification['domaine'] ?? ''),
                                      subtitle: Row(
                                        children: [
                                          Icon(Icons.calendar_today,color: Colors.grey,size: 16),
                                          SizedBox(width: 8), // spacing
                                          Text(certification['year'] ?? ''),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          _showDeleteConfirmationDialog(user['cv']?['_id'],'certifications',certification?['_id']);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          const Divider(
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 16, right: 16, bottom: 16, top: 8),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: PteAppTheme.buildLightTheme().primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    blurRadius: 8,
                    offset: const Offset(4, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius:
                  const BorderRadius.all(Radius.circular(24.0)),
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    final String? token = prefs.getString('token');
                    if (token != null) {
                      final userData = await getUserById(widget.userId, token);
                      final pdfData = await _generatePdf(userData);
                      // Request storage permission
                      if (await Permission.storage.request().isGranted) {
                        _savePdfToDownloads(pdfData);
                      } else {
                        print('Storage permission not granted. Unable to save PDF file.');
                      }
                    }
                  },
                  child: const Center(
                    child: Text(
                      'Download CV',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
    );
  }


  Future<void> _savePdfToDownloads(Uint8List pdfData) async {
    if (Platform.isAndroid) {
      Directory? appExternalDir = await getExternalStorageDirectory();
      if (appExternalDir == null) {
        print('External storage not available');
        return;
      }

      String appExternalPath = appExternalDir.path;
      print('App External Files Directory: $appExternalPath');

      String downloadsPath = p.join(appExternalPath, 'Download');
      Directory downloadsDir = Directory(downloadsPath);

      if (!(await downloadsDir.exists())) {
        await downloadsDir.create(recursive: true);
      }

      final file = File(p.join(downloadsPath, 'CV.pdf'));

      await file.writeAsBytes(pdfData);

      print('PDF File saved at: ${file.path}');
    }
  }



  Future<Uint8List> _generatePdf(Map<String, dynamic> userData) async {
    final pdf = pw.Document();
    final fontDataRegular = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final fontDataBold = await rootBundle.load("assets/fonts/Roboto-Bold.ttf");
    final fontRegular = pw.Font.ttf(fontDataRegular);
    final fontBold = pw.Font.ttf(fontDataBold);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Profile Image
              pw.Stack(
                children: [
                  // Shadow-like effect
                  pw.Container(
                    width: 150,
                    height: 150,
                    decoration: pw.BoxDecoration(
                      shape: pw.BoxShape.circle,
                      boxShadow: [
                        pw.BoxShadow(
                          color: PdfColors.black,
                          blurRadius: 5.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                  ),
                  // Profile Image
                  if (userData['image'] != null && File(userData['image']).existsSync())
                    pw.Container(
                      width: 150,
                      height: 150,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        image: pw.DecorationImage(
                          image: pw.MemoryImage(
                            File('$serverPathimage/${userData['image'] ?? ''}').readAsBytesSync(),
                          ),
                          fit: pw.BoxFit.cover,
                        ),
                      ),
                    ),
                ],
              ),
              pw.SizedBox(height: 16),
              // Basic Information
              pw.Text('Experience: ${userData['experience'] ?? ''}+ years'),
              pw.Text('Department: ${userData['department'] ?? ''}'),
              pw.Divider(color: PdfColors.grey),
              pw.SizedBox(height: 16),
              pw.Text('Location: ${userData['address'] ?? ''}'),
              pw.Text('Nationality: ${userData['nationality'] ?? ''}'),
              pw.Text('Gender: ${userData['gender'] ?? ''}'),
              pw.Text('Family Situation: ${userData['familySituation'] ?? ''}'),
              pw.Divider(color: PdfColors.grey),
              pw.SizedBox(height: 16),
              pw.Text(
                'Driving License: ${userData['drivingLicense'] ?? false ? 'Yes' : 'No'}',
              ),
              pw.SizedBox(height: 16),
              // Education Card
              pw.Text(
                'Education:',
                style: pw.TextStyle(font: fontBold, fontSize: 14), // Custom font applied
              ),
              pw.ListView.builder(
                itemCount: userData['cv']['studies'].length,
                itemBuilder: (context, index) {
                  final education = userData['cv']['studies'][index];
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Diploma: ${education['diploma'] ?? ''}', style: pw.TextStyle(font: fontRegular, fontSize: 12)),
                      pw.Text('Establishment: ${education['establishment'] ?? ''}', style: pw.TextStyle(font: fontRegular, fontSize: 12)),
                      pw.Text('Year: ${education['year'] ?? ''}', style: pw.TextStyle(font: fontRegular, fontSize: 12)),
                      pw.Divider(color: PdfColors.grey),
                    ],
                  );
                },
              ),
              pw.SizedBox(height: 16),
              // Experience Card
              pw.Text(
                'Experience:',
                style: pw.TextStyle(font: fontBold, fontSize: 14), // Custom font applied
              ),
              pw.ListView.builder(
                itemCount: userData['cv']['professionnal_career'].length,
                itemBuilder: (context, index) {
                  final experience = userData['cv']['professionnal_career'][index];
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Job: ${experience['job'] ?? ''}', style: pw.TextStyle(font: fontRegular, fontSize: 12)),
                      pw.Text('Organization: ${experience['organization'] ?? ''}', style: pw.TextStyle(font: fontRegular, fontSize: 12)),
                      pw.Text('Period: ${experience['period'] ?? ''}', style: pw.TextStyle(font: fontRegular, fontSize: 12)),
                      pw.Divider(color: PdfColors.grey),
                    ],
                  );
                },
              ),
              pw.SizedBox(height: 16),
              // Projects Card
              pw.Text(
                'Projects:',
                style: pw.TextStyle(font: fontBold, fontSize: 14), // Custom font applied
              ),
              pw.ListView.builder(
                itemCount: userData['cv']['projets'].length,
                itemBuilder: (context, index) {
                  final project = userData['cv']['projets'][index];
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Title: ${project['title'] ?? ''}', style: pw.TextStyle(font: fontRegular, fontSize: 12)),
                      pw.Text('Organization: ${project['organization'] ?? ''}', style: pw.TextStyle(font: fontRegular, fontSize: 12)),
                      pw.Text('Description: ${project['description'] ?? ''}', style: pw.TextStyle(font: fontRegular, fontSize: 12)),
                      pw.Divider(color: PdfColors.grey),
                    ],
                  );
                },
              ),
              pw.SizedBox(height: 16),
              // Certifications Card
              pw.Text(
                'Certifications:',
                style: pw.TextStyle(font: fontBold, fontSize: 14), // Custom font applied
              ),
              pw.ListView.builder(
                itemCount: userData['cv']['certifications'].length,
                itemBuilder: (context, index) {
                  final certification = userData['cv']['certifications'][index];
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Domaine: ${certification['domaine'] ?? ''}', style: pw.TextStyle(font: fontRegular, fontSize: 12)),
                      pw.Text('Year: ${certification['year'] ?? ''}', style: pw.TextStyle(font: fontRegular, fontSize: 12)),
                      pw.Divider(color: PdfColors.grey),
                    ],
                  );
                },
              ),
            ],
          );
        },
        theme: pw.ThemeData(
          defaultTextStyle: pw.TextStyle(font: fontRegular, fontSize: 12),
        ),
      ),
    );
    final pdfData = await pdf.save();
    print('PDF Data Length: ${pdfData.length} bytes');

    return pdfData;
  }



  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: PteAppTheme.buildLightTheme().colorScheme.background,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            offset: const Offset(0, 2),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: 8,
          right: 8,
        ),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  Navigator.pop(context);
             /*     Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => UserHomeScreen(),
                    ),
                  );*/
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.close),
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'User Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            )
          ],
        ),
      ),
    );
  }
  ///
  void _showAddCertificationDialog(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddCertificationDialog(
            onAddCertification: (String domaine, String year) async {
              Map<String, dynamic> newCertification = {
                "certifications": {
                  "domaine": domaine,
                  "year": year
                }
              };
              try {
                await updateCV(token!, id, newCertification);
                _loadCV();
              } catch (e, stackTrace) {
                print('Error while updating CV: $e');
                print(stackTrace);
              }
            }
        );
      },
    );
  }



  void _showAddProjectDialog(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddProjectDialog(
          onAddProject: (String organization, String title, String description) async {
            Map<String, dynamic> newProjects = {
              "projets": {
                "organization": organization,
                "title": title,
                "description": description
              }
            };
            try {
              await updateCV(token!,id, newProjects);
              _loadCV();
            } catch (e) {
              print('Error while updating CV: $e');
            }
          }
        );
      },
    );
  }

  void _showAddEducationDialog(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddEducationDialog(
          onAddEducation: (String diploma, String establishment, String section, String year) async {
            Map<String, dynamic> newStudies = {
              "studies": {
                "diploma": diploma,
                "establishment": establishment,
                "section": section,
                "year": year
              }
            };
            try {
              await updateCV(token!,id, newStudies);
              _loadCV();
            } catch (e) {
              print('Error while updating CV: $e');
            }
          },
        );
      },
    );
  }

  void _showAddExperienceDialog(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddExperienceDialog(
          onAddExperience: (
              String organization,
              String job,
              String startPeriod,
              String endPeriod,
              String taskDescription,
              ) async {

            Map<String, dynamic> newExperiences = {
              "professionnal_career": {
                "organization": organization,
                "job": job,
                "task_description": taskDescription,
                "period": "$startPeriod-$endPeriod"
              }
            };
            try {
            await updateCV(token!,id, newExperiences);
            _loadCV();
            } catch (e) {
            print('Error while updating CV: $e');
            }
          },
        );
      },
    );
  }


  void _showEditProfileDialog(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final Map<String, dynamic> userData = await getUserById(id, token!);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditProfileDialog(
          onSaveProfile: (
              String fulltName,
              String phone,
              String email,
              String department,
              String address,
              String familySituation,
              bool drivingLicense,
              String dateOfBirth,
              String gender,
              String hiringDate,
              String experience,
              bool isEnabled,
              ) async  {

        Map<String, dynamic> newUserInformations = {
            'phone': int.parse(phone),
            'email': email,
            'address': address,
            'drivingLicense': drivingLicense,
            'DateOfBirth': dateOfBirth,
            'hiringDate': hiringDate,
            'experience': int.parse(experience),
            'isEnabled': isEnabled,
            'department': department,
            'familySituation': familySituation,
            'gender': gender,
        };
        try {
        await updateUser(id,token!, newUserInformations);
        } catch (e) {
        print('Error while updating The user informations: $e');
        }
        },
          initialUserData: userData,
        );
      },
    );
  }


  void _showEditProfileImageDialog(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? tokenn = prefs.getString('token');
    String Id = widget.userId;
    showDialog(
      context: context,
      builder: (context) {
        return EditProfileImageDialog(token: tokenn!,idUser:Id,onPhotoUpdated:_loadCV);
      },
    );
  }

  void _showDeleteConfirmationDialog(String idCV, String arrayName, String idItem) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Confirm Delete',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Are you sure you want to delete this item?',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red, // Customize the color
                        ),
                      ),
                      onPressed: () async {
                        try {
                          await deleteItem(token!, idCV, arrayName, idItem);
                          _loadCV();
                        } catch (e) {
                          print('Error deleting item: $e');
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
