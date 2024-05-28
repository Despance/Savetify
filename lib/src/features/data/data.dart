import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Map<String, dynamic>> transactionsData = [
  {
    "icon": FaIcon(
      FontAwesomeIcons.burger,
      color: Colors.grey[600],
    ),
    "color": const Color.fromARGB(255, 211, 94, 4),
    "name": "Food",
    "totalAmount": "-₺145.00",
    "date": "Today",
  },
  {
    "icon": FaIcon(
      FontAwesomeIcons.bagShopping,
      color: Colors.grey[600],
    ),
    "color": const Color.fromARGB(255, 17, 205, 208),
    "name": "Shopping",
    "totalAmount": "-₺699.90",
    "date": "Today",
  },
  {
    "icon": FaIcon(
      FontAwesomeIcons.heartCircleCheck,
      color: Colors.grey[600],
    ),
    "color": const Color.fromARGB(255, 186, 5, 5),
    "name": "Health",
    "totalAmount": "-₺235.00",
    "date": "Yesterday",
  },
  {
    "icon": FaIcon(
      FontAwesomeIcons.planeUp,
      color: Colors.grey[600],
    ),
    "color": const Color.fromARGB(255, 166, 20, 239),
    "name": "Travel",
    "totalAmount": "-₺750.00",
    "date": "Yesterday",
  }
];
