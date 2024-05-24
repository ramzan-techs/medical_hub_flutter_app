import 'package:flutter/material.dart';

import '../../../models/base_user.dart';

class UserTypeSegment extends StatefulWidget {
  final UserType selectedValue;
  final Function(Set<UserType>)? onSelectionChanged;
  const UserTypeSegment(
      {super.key,
      required this.selectedValue,
      required this.onSelectionChanged});

  @override
  State<UserTypeSegment> createState() => _UserTypeSegmentState();
}

class _UserTypeSegmentState extends State<UserTypeSegment> {
  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(4),
          side: WidgetStateProperty.all(
              const BorderSide(color: Colors.green, width: 1.5)),
        ),
        segments: const [
          ButtonSegment<UserType>(
            value: UserType.user,
            label: Text("User"),
            icon: Icon(Icons.person),
          ),
          ButtonSegment<UserType>(
            value: UserType.doctor,
            label: Text("Doctor"),
            icon: Icon(Icons.add),
          ),
        ],
        selected: <UserType>{widget.selectedValue},
        onSelectionChanged: widget.onSelectionChanged);
  }
}
