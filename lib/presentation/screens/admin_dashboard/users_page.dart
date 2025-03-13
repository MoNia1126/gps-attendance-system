import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_attendance_system/blocs/user_cubit/users_cubit.dart';
import 'package:gps_attendance_system/core/app_routes.dart';
import 'package:gps_attendance_system/core/models/user_model.dart';
import 'package:gps_attendance_system/presentation/screens/admin_dashboard/admin_home.dart';
import 'package:gps_attendance_system/presentation/screens/admin_dashboard/widgets/search_container.dart';
import 'package:gps_attendance_system/presentation/screens/admin_dashboard/widgets/users_list.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({
    required this.users,
    required this.isEmployees,
    super.key,
  });

  // users list
  final List<UserModel> users;
  final bool isEmployees;

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  TextEditingController searchController = TextEditingController();

  List<UserModel> filteredUsers = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    filteredUsers = widget.users;
  }

  void filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredUsers = widget.users;
      } else {
        filteredUsers = widget.users
            .where(
              (user) => user.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenPadding = MediaQuery.of(context).size.width * 0.04;

    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isEmployees ? 'Employees Records' : 'Managers Records'),
      ),
      // Add user button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addUser);
        },
        label: const Row(
          children: [
            Icon(Icons.add),
            Text('Add User'),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // employees or managers title
            Row(
              children: [
                const Icon(Icons.people),
                const SizedBox(width: 10),
                Text(
                  widget.isEmployees ? 'Total Employees' : 'Total Managers',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // Search bar container
            SearchContainer(
              controller: searchController,
              onSearch: filterUsers,
            ),
            const SizedBox(height: 15),
            // List of employees or managers
            BlocBuilder<UsersCubit, UsersState>(
              builder: (context, state) {
                final usersCubit = UsersCubit.get(context);
                if (state is GetUsersSuccess) {
                  if (widget.isEmployees) {
                    filteredUsers = usersCubit.employees;
                  } else if (!widget.isEmployees) {
                    filteredUsers = usersCubit.managers;
                  }
                }

                return (state is UsersLoading || filteredUsers.isNotEmpty)
                    ? Expanded(
                        child: Skeletonizer(
                          enabled: state is UsersLoading,
                          child: UsersList(
                            users:
                                filteredUsers.isEmpty && state is UsersLoading
                                    ? dummyUsersObjects
                                    : filteredUsers,
                          ),
                        ),
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            textAlign: TextAlign.center,
                            'No ${widget.isEmployees ? 'employees' : 'managers'} found',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
