import 'dart:math';
import 'dart:developer' as d;

import 'package:flutter/material.dart';
import 'package:spin_wheel/shared/prize_item_model.dart';

class SpinWheelController extends ChangeNotifier {
  SpinWheelController();

  final Random _random = Random();

  List<PrizeItem> _prizes = [];
  bool _isSpinning = false;
  double _angleToSpin = 0;
  PrizeItem? _wonPrize;
  List<PrizeItem> _winHistory = [];

  List<PrizeItem> get prizes => _prizes;
  bool get isSpinning => _isSpinning;
  double get angleToSpin => _angleToSpin;
  PrizeItem? get wonPrize => _wonPrize;
  List<PrizeItem> get winHistory => _winHistory;

  changeIsSpinning(bool newValue) {
    _isSpinning = newValue;
    notifyListeners();
  }

  changeAngleToSpin(double newValue) {
    _angleToSpin = newValue;
    notifyListeners();
  }

  listenAnimationChanges() {
    notifyListeners();
  }

  void initPrizes(List<PrizeItem> prizes) {
    _prizes = prizes;
    notifyListeners();
  }

  Future<void> spin() async {
    _wonPrize = null;
    final validPrizes = prizes.where((p) => p.probability > 0).toList();
    final totalProbability =
        validPrizes.fold(0.0, (sum, p) => sum + p.probability);

    double randomValue = _random.nextDouble() * totalProbability;

    double cumulative = 0.0;
    PrizeItem selectedPrize = validPrizes.first;
    for (final prize in validPrizes) {
      cumulative += prize.probability;

      if (randomValue < cumulative) {
        selectedPrize = prize;
        break;
      }
    }

    d.log("selected prize index => ${selectedPrize.index}");
    final segmentAngle = 2 * pi / prizes.length;
    final spinCount = 3 + _random.nextInt(3);
    final targetAngle = (2 * pi) - (segmentAngle * (selectedPrize.index + 1));
    final offset =
        _random.nextDouble() * (segmentAngle * 0.8) + (segmentAngle * 0.1);

    _wonPrize = selectedPrize;
    _winHistory.add(selectedPrize);
    changeAngleToSpin((spinCount * 2 * pi) + targetAngle + offset);
  }
}
