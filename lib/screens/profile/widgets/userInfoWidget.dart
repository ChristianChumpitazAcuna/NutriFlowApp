import 'package:flutter/material.dart';

class UserInfoWidget extends StatelessWidget {
  final String displayName;
  final String email;
  final String photoUrl;

  const UserInfoWidget({
    super.key,
    required this.displayName,
    required this.email,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(photoUrl),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          displayName,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          email,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        )
      ],
    );
  }
}
