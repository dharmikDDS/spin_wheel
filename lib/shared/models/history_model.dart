import 'package:spin_wheel/shared/models/prize_item_model.dart';

class HistoryModel {
  final DateTime wonAt;
  final PrizeItem prize;

  HistoryModel({required this.wonAt, required this.prize});
}
