import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gps_attendance_system/core/models/user_model.dart';
import 'package:gps_attendance_system/core/utils/attendance_helper.dart';
import 'package:gps_attendance_system/presentation/widgets/custom_calendar_timeline.dart';
import 'package:gps_attendance_system/presentation/widgets/user_avatar.dart';
import 'package:intl/intl.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({required this.userModel, super.key});

  final UserModel userModel;

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  DateTime selectedDate = DateTime.now();

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAttendanceRecords() {
    String selectedDateString = DateFormat('yyyy-M-d').format(selectedDate);

    log('Fetching attendance for ID: ${widget.userModel.id} on $selectedDateString');

    return FirebaseFirestore.instance
        .collection('attendanceRecords')
        .where('userId', isEqualTo: widget.userModel.id)
        .where('date', isEqualTo: selectedDateString)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text('${widget.userModel.name} Attendance')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          children: [
            // User Info Card
            Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    UserAvatar(
                      imagePath: widget.userModel.getAvatarImage(),
                      radius: 30,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userModel.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.userModel.position,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.userModel.email,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // -- Calender time line
            CustomCalendarTimeline(
              onDateSelected: (date) {
                setState(() => selectedDate = date);
              },
            ),
            const SizedBox(height: 15),
            //-- Attendance Records List As stream --//
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: fetchAttendanceRecords(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final attendanceRecords = snapshot.data!.docs;
                  if (attendanceRecords.isEmpty) {
                    return const Center(
                      child: Text('No attendance records found'),
                    );
                  }

                  return ListView.builder(
                    itemCount: attendanceRecords.length,
                    itemBuilder: (context, index) {
                      final record = attendanceRecords[index];
                      DateTime date = DateFormat('yyyy-M-d')
                          .parse(record['date'] as String);
                      String formattedDate =
                          DateFormat('yyyy-M-d').format(date);
                      String status = record['status'] as String;
                      Color statusColor =
                          AttendanceHelper.getStatusColor(status);

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(
                            formattedDate,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Check in time row
                              Row(
                                children: [
                                  const Icon(Icons.login, color: Colors.green),
                                  const SizedBox(width: 5),
                                  Text("Check-In: ${record['checkInTime']}"),
                                ],
                              ),
                              // Check out time row
                              Row(
                                children: [
                                  if (record['checkOutTime'] != null)
                                    const Icon(
                                      Icons.logout,
                                      color: Colors.red,
                                    )
                                  else
                                    const Icon(Icons.verified_user_outlined),
                                  const SizedBox(width: 5),
                                  if (record['checkOutTime'] != null)
                                    Text("Check-Out: ${record['checkOutTime']}")
                                  else
                                    const Text(
                                      'Present',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.orange,
                                      ),
                                    ),
                                ],
                              ),
                              //-- Status Row --//
                              Row(
                                children: [
                                  Icon(Icons.info, color: statusColor),
                                  const SizedBox(width: 5),
                                  Text(
                                    status,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
