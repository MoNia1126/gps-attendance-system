import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

part 'employee_location_state.dart';

class EmployeeLocationCubit extends Cubit<EmployeeLocationState> {
  EmployeeLocationCubit() : super(EmployeeLocationInitial());
  final double companyLat = 30.0447;
  final double companyLng = 31.2389;
  final double geofenceRadius = 100;
  static final DateTime officialCheckInTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 9, 0);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> checkEmployeeLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        emit(EmployeeLocationPermissionDenied());
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        companyLat,
        companyLng,
      );

      if (distance <= geofenceRadius) {
        DateTime now = DateTime.now();
        bool isOnTime = now.isBefore(officialCheckInTime);
        emit(EmployeeLocationInside(checkInTime: now, isOnTime: isOnTime));
      } else {
        emit(EmployeeLocationOutside());
      }
    } catch (e) {}
  }

  Future<void> checkIn() async {
    final user = _auth.currentUser;
    if (user == null) {
      emit(EmployeeLocationError("User not found"));
      return;
    }

    final now = DateTime.now();
    final todayDate = "${now.year}-${now.month}-${now.day}";
    final checkInTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    final attendanceDoc = _firestore
        .collection('attendanceRecords')
        .doc("${user.uid}_$todayDate");

    try {
      await attendanceDoc.set({
        "userId": user.uid,
        "date": todayDate,
        "checkInTime": checkInTime,
        "timestamp": now.toIso8601String(),
      }, SetOptions(merge: true));

      emit(EmployeeCheckedIn(time: checkInTime));
    } catch (e) {
      emit(EmployeeLocationError("Failed to check in: $e"));
    }
  }

  Future<void> checkOut() async {
    final user = _auth.currentUser;
    if (user == null) {
      emit(EmployeeLocationError("User not found"));
      return;
    }

    final now = DateTime.now();
    final todayDate = "${now.year}-${now.month}-${now.day}";
    final checkOutTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    final attendanceDoc = _firestore
        .collection('attendanceRecords')
        .doc("${user.uid}_$todayDate");

    try {
      await attendanceDoc.set({
        "checkOutTime": checkOutTime,
      }, SetOptions(merge: true));

      emit(EmployeeCheckedOut(time: checkOutTime));
    } catch (e) {
      emit(EmployeeLocationError("Failed to check out: $e"));
    }
  }
}
