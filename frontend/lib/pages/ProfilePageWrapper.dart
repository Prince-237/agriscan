import 'package:flutter/material.dart';
import 'profile.dart';

class ProfilePageWrapper extends StatelessWidget {
  final int userId;
  final String token;

  const ProfilePageWrapper({
    super.key,
    required this.userId,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return ProfilePage(userId: userId, token: token);
  }
}