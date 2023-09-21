import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../user_management/pte_app_theme.dart';
import '../service/ServiceVehicule.dart';
import 'dialog/AddEventDialog.dart';
import 'dialog/EventDetailsDialog.dart';

class CalendarVehicule extends StatefulWidget {
  final String vehicleId;

  CalendarVehicule({required this.vehicleId});

  @override
  State<CalendarVehicule> createState() => _CalendarVehiculeState();
}

class _CalendarVehiculeState extends State<CalendarVehicule> {
  List<dynamic> events = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      final List<dynamic> vehicleEvents = await getVehicleEvents(token!, widget.vehicleId);

      setState(() {
        events = vehicleEvents;
      });
    } catch (e) {
      print('Error fetching events: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          getAppBarUI(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const Divider(
                    height: 1,
                  ),
                  CalendarWidget(events: events, refreshCallback: _fetchEvents),
                ],
              ),
            ),
          ),
          const Divider(
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
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
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  highlightColor: Colors.transparent,
                  onTap: () {
                    _showAddEventDialog(context, widget.vehicleId);
                  },
                  child: const Center(
                    child: Text(
                      'Add',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showAddEventDialog(BuildContext context, String vehicleId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddEventDialog(
          onAddEvent: (String title, String start, String end, String driver, String destination) async {
            print('Title: $title, Start: $start, End: $end, Driver: $driver, vehicleId: $vehicleId, Destination: $destination');
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            final String? token = prefs.getString('token');
            final String? userId = prefs.getString('userId');

            try {
              await createEventt(token!,title,start,end,vehicleId,userId!,driver,destination,context);
              _fetchEvents();
            } catch (e) {
              print('Error while adding: $e');
            }

          },
        );
      },
    );
  }


  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
                  'Calendrier',
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
}

class CalendarWidget extends StatelessWidget {
  final List<dynamic> events;
  final VoidCallback refreshCallback;

  CalendarWidget({required this.events, required this.refreshCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 680, // Set the height to calendar
      child: SfCalendar(
        view: CalendarView.week, // Change the view to week
        firstDayOfWeek: 1, // Set Monday as the first day of the week
        dataSource: MeetingDataSource(events), // Pass events to MeetingDataSource
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.appointment) {
            final Appointment tappedAppointment = details.appointments?[0];
            final String notes = tappedAppointment.notes ?? '';

            // Split the notes to extract the event ID and other details
            final List<String> noteLines = notes.split('\n');
            String eventId = '';
            String driverImage = '';
            String applicantImage = '';
            bool isAccepted = false;

            for (String line in noteLines) {
              if (line.startsWith('Event ID: ')) {
                eventId = line.substring('Event ID: '.length);
              } else if (line.startsWith('DriverImage: ')) {
                driverImage = line.substring('DriverImage: '.length);
              } else if (line.startsWith('ApplicantImage: ')) {
                applicantImage = line.substring('ApplicantImage: '.length);
              } else if (line.startsWith('IsAccepted: ')) {
                isAccepted = line.substring('IsAccepted: '.length) == 'true';
              }
            }

            final DateTime eventStartTime = tappedAppointment.startTime;
            final DateTime eventEndTime = tappedAppointment.endTime;

            // Print event information
            print('Event ID: $eventId');
            print('Event Start Time: $eventStartTime');
            print('Event End Time: $eventEndTime');

            _showEventDetailsDialog(
              context,
              eventId,
              tappedAppointment.subject,
              eventStartTime,
              eventEndTime,
              driverImage,
              applicantImage,
              isAccepted,
            );
          }
        },
      ),
    );
  }

  void _showEventDetailsDialog(
      BuildContext context,
      String eventId,
      String title,
      DateTime start,
      DateTime end,
      String driverImage,
      String applicantImage,
      bool isAccepted,
      ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EventDetailsDialog(
          eventId: eventId,
          title: title,
          start: start,
          end: end,
          driverImage: driverImage,
          applicantImage: applicantImage,
          isAccepted: isAccepted,
          onDeleteEvent: () async {
            await _handleDeleteEvent(eventId, token!);
          },
        );
      },
    );
  }

  Future<void> _handleDeleteEvent(String eventId, String token) async {
    await deleteEvent(eventId, token);
    // Refresh the events list by calling the callback
    refreshCallback();
  }
}

Color getRandomColor() {
  final Random random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<dynamic> source) {
    appointments = _getAppointments(source);
  }

  List<Appointment> _getAppointments(List<dynamic> source) {
    List<Appointment> meetings = [];

    for (var event in source) {
      final String eventId = event['_id'];
      final String title = event['title'];
      final DateTime start = DateTime.parse(event['start']);
      final DateTime end = DateTime.parse(event['end']);
      final String vehicleId = event['vehicle'];
      final String driverImage = event['driver']['image'];
      final String destination = event['destination'];
      final String applicantImage = event['applicant']['image'];
      final bool isAccepted = event['isAccepted'];

      final Color eventColor = getRandomColor();

      meetings.add(Appointment(
        subject: title,
        startTime: start,
        endTime: end,
        color: eventColor,
        notes: 'Event ID: $eventId\nDriverImage: $driverImage\nApplicantImage: $applicantImage\nIsAccepted: $isAccepted',
        startTimeZone: '',
        endTimeZone: '',
      ));
    }

    return meetings;
  }
}
