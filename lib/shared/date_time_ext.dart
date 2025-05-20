import 'package:intl/intl.dart';

extension FormatExtension on DateTime {
  String get ddMMyyHHss => DateFormat("dd/MM/yy HH:mm:ss").format(this);
}
