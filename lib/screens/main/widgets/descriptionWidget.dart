import 'package:flutter/material.dart';

class DescriptionWidget extends StatefulWidget {
  final String name;
  final String description;
  final double screenWidth;

  const DescriptionWidget(
      {super.key,
      required this.name,
      required this.description,
      required this.screenWidth});

  @override
  State<DescriptionWidget> createState() => _DescriptionWidgetState();
}

class _DescriptionWidgetState extends State<DescriptionWidget> {
  bool isExpanded = false;
  static const int maxLentgh = 100;

  @override
  Widget build(BuildContext context) {
    String showDescription = isExpanded
        ? widget.description
        : widget.description.length > maxLentgh
            ? '${widget.description.substring(0, maxLentgh)}...'
            : widget.description;

    return Container(
      alignment: Alignment.center,
      width: widget.screenWidth / 2,
      height: isExpanded ? 200 : 120,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: const BorderRadius.only(topRight: Radius.circular(50)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          widget.name,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  showDescription,
                  overflow:
                      isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Text(
                  isExpanded ? 'Leer menos' : 'Leer más',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ))
      ]),
    );
  }
}
