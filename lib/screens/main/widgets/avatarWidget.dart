import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String avatar;
  final String displayName;

  const AvatarWidget({
    super.key,
    required this.avatar,
    required this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(bottom: 5, top: 5, left: 15),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 73, 73, 73).withOpacity(0.8),
            blurRadius: 20,
            spreadRadius: -6,
          )
        ]),
        child: Row(
          children: [
            Text(
              displayName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                avatar,
              ),
            ),
          ],
        ));
  }
}
