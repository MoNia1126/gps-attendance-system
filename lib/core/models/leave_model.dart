import 'package:cloud_firestore/cloud_firestore.dart';

class LeaveModel {
  LeaveModel({
    required this.title,
    required this.leaveType,
    required this.contactNumber,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.userId,
    required this.id,
    this.status = 'Pending',
  });

  factory LeaveModel.fromMap(Map<String, dynamic> map, String documentId) {
    return LeaveModel(
      title: map['title']?.toString() ?? '',
      id: map['id']?.toString() ?? '',
      leaveType: map['leaveType']?.toString() ?? '',
      contactNumber: map['contactNumber']?.toString() ?? '',
      startDate: (map['startDate'] is Timestamp)
          ? map['startDate'] as Timestamp
          : Timestamp.now(),
      endDate: (map['endDate'] is Timestamp)
          ? map['endDate'] as Timestamp
          : Timestamp.now(),
      reason: map['reason']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      status: map['status']?.toString() ?? '',
    );
  }

  String title;
  String leaveType;
  String contactNumber;
  Timestamp startDate;
  Timestamp endDate;
  String reason;
  String userId;
  String id;
  String status; // pending, approved, rejected

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'leaveType': leaveType,
      'contactNumber': contactNumber,
      'startDate': startDate,
      'endDate': endDate,
      'reason': reason,
      'userId': userId,
      'status': status,
      'id': id,
    };
  }
}
