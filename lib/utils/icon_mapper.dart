// Fonction utilitaire qui convertit un nom d'icône (String) en IconData Flutter
// Permet d'afficher dynamiquement des icônes selon le nom stocké en base
import 'package:flutter/material.dart';

IconData getIconFromString(String iconName) {
  switch (iconName) {
    case 'computer':
      return Icons.computer;
    case 'public':
      return Icons.public;
    case 'calculate':
      return Icons.calculate;
    case 'science':
      return Icons.science;
    case 'language':
      return Icons.language;
    case 'attach_money':
      return Icons.attach_money;
    case 'gavel':
      return Icons.gavel;
    case 'auto_awesome':
      return Icons.auto_awesome;
    case 'flag':
      return Icons.flag;
    case 'health_and_safety':
      return Icons.health_and_safety;
    case 'eco':
      return Icons.eco;
    case 'movie':
      return Icons.movie;
    case 'lightbulb':
      return Icons.lightbulb;
    case 'menu_book':
      return Icons.menu_book;
    case 'extension':
      return Icons.extension;
    default:
      return Icons.category;
  }
}
