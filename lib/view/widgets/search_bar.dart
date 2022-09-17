import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar(
      {Key? key,
      required this.title,
      required this.function,
      required this.subtitle})
      : super(key: key);
  final String title;
  final String subtitle;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Text(title),
          const Spacer(),
          GestureDetector(
            onTap: () {
              function;
            },
            child: Row(
              children: [
                Text(subtitle),
                const Icon(Icons.chevron_right),
              ],
            ),
          )
        ],
      ),
    );
  }
}
