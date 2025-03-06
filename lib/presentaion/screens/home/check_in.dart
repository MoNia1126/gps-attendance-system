import 'package:flutter/material.dart';
import 'package:gps_attendance_system/presentaion/screens/home/widgets/buttons.dart';
import 'package:gps_attendance_system/presentaion/screens/home/widgets/company_location.dart';
import 'package:gps_attendance_system/presentaion/screens/home/widgets/details_card.dart';

class CheckIn extends StatefulWidget {
  const CheckIn({super.key});

  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  void checkIn() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CheckInOutButton(
                      label: 'Check In',
                      color: const Color(0XFF2563EB),
                      onPressed: checkIn,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CheckInOutButton(
                      label: 'Check Out',
                      color: const Color(0XFF203546),
                      onPressed: checkIn,
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                const Text(
                  "Today's Attendance",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20,),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Detailscard(
                      title: 'Check In',
                      subtitle: '10:00',
                      icon: Icons.login,
                      iconColor: Color(0xff203546),
                    ),
                    Detailscard(
                      title: 'Check In',
                      subtitle: '10:00',
                      icon: Icons.login,
                      iconColor: Color(0xff203546),
                    ),
                  ],
                ),
                const Expanded(child: CompanyLocation()),
              ],
            ),
        ),
      ),
    );
  }
}
