import 'package:flutter/material.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("World"));
  }
}

class ProfileScreenAppBar extends StatelessWidget {
  const ProfileScreenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Text("PROFILE", style: Theme.of(context).textTheme.headlineLarge);
  }
}
