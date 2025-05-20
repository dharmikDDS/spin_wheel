import 'package:flutter/material.dart';
import 'package:spin_wheel/colors.dart';

class PrizeItem {
  final int index;
  final String label;
  final PrizeItemType type;
  final double probability;

  PrizeItem({
    required this.index,
    required this.label,
    this.type = PrizeItemType.guaranteed,
    this.probability = 1.0,
  }) : assert(probability <= 1 && probability >= 0,
            'Probability must between 0 to 1.');
}

enum PrizeItemType { guaranteed, special }

extension PrizeItemToPaint on PrizeItem {
  TextStyle get style => TextStyle(
        fontSize: type == PrizeItemType.special ? 16 : 14,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      );

  Color get bgColor => (index + 1) % 2 == 0 ? secondaryColor : yellowStatColor;
}
