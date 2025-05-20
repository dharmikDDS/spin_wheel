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

final dummyPrizes = [
  PrizeItem(
    index: 0,
    label: '5% Off your order',
    probability: 1,
    type: PrizeItemType.guaranteed,
  ),
  PrizeItem(
    index: 1,
    label: '10% Off your order',
    probability: .75,
    type: PrizeItemType.guaranteed,
  ),
  PrizeItem(
    index: 2,
    label: 'FREE!',
    probability: 0,
    type: PrizeItemType.special,
  ),
  PrizeItem(
    index: 3,
    label: '5% Off your order',
    probability: 1,
    type: PrizeItemType.guaranteed,
  ),
  PrizeItem(
    index: 4,
    label: '10% Off your order',
    probability: .75,
    type: PrizeItemType.guaranteed,
  ),
  PrizeItem(
    index: 5,
    label: 'FREE!',
    probability: 0,
    type: PrizeItemType.special,
  ),
  PrizeItem(
    index: 6,
    label: '5% Off your order',
    probability: 1,
    type: PrizeItemType.guaranteed,
  ),
  PrizeItem(
    index: 7,
    label: '10% Off your order',
    probability: .75,
    type: PrizeItemType.guaranteed,
  ),
  PrizeItem(
    index: 8,
    label: 'FREE!',
    probability: 0,
    type: PrizeItemType.special,
  ),
  PrizeItem(
    index: 9,
    label: '5% Off your order',
    probability: 1,
    type: PrizeItemType.guaranteed,
  ),
  PrizeItem(
    index: 10,
    label: '10% Off your order',
    probability: .75,
    type: PrizeItemType.guaranteed,
  ),
  PrizeItem(
    index: 11,
    label: 'FREE!',
    probability: 0,
    type: PrizeItemType.special,
  ),
  PrizeItem(
    index: 12,
    label: '5% Off your order',
    probability: 1,
    type: PrizeItemType.guaranteed,
  ),
  PrizeItem(
    index: 13,
    label: '10% Off your order',
    probability: .75,
    type: PrizeItemType.guaranteed,
  ),
  PrizeItem(
    index: 14,
    label: 'FREE!',
    probability: 0,
    type: PrizeItemType.special,
  ),
  PrizeItem(
    index: 15,
    label: '5% Off your order',
    probability: 1,
    type: PrizeItemType.guaranteed,
  ),
  PrizeItem(
    index: 16,
    label: '10% Off your order',
    probability: .75,
    type: PrizeItemType.guaranteed,
  ),
  PrizeItem(
    index: 17,
    label: 'FREE!',
    probability: 0,
    type: PrizeItemType.special,
  )
];
