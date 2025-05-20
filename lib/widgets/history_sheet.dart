import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spin_wheel/controllers/spin_wheel_controller.dart';
import 'package:spin_wheel/shared/colors.dart';
import 'package:spin_wheel/shared/date_time_ext.dart';
import 'package:spin_wheel/shared/models/history_model.dart';

class HistorySheet extends StatelessWidget {
  HistorySheet({super.key});

  final DraggableScrollableController controller =
      DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: controller,
      expand: false,
      shouldCloseOnMinExtent: true,
      builder: (context, controller) {
        return Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: Navigator.of(context).pop,
                icon: Icon(Icons.clear),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "History",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTable(
                    [
                      TableRow(
                        children: [
                          _buildTableCell(
                            text: "No.",
                            bgColor: primaryColor,
                            textColor: whiteColor,
                          ),
                          _buildTableCell(
                            text: "Time",
                            bgColor: primaryColor,
                            textColor: whiteColor,
                          ),
                          _buildTableCell(
                            text: "Reward",
                            bgColor: primaryColor,
                            textColor: whiteColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller,
                      child: _buildTable(
                        context
                            .watch<SpinWheelController>()
                            .winHistory
                            .reversed
                            .indexed
                            .map((e) => _buildTabelRow(e.$1, e.$2))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Table _buildTable(List<TableRow> children) {
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(
          color: primaryColor,
        ),
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(3),
      },
      children: children,
    );
  }

  TableRow _buildTabelRow(int index, HistoryModel prize) {
    final bgColor = ((index + 1) % 2 == 0 ? yellowStatColor : secondaryColor);
    return TableRow(
      children: [
        _buildTableCell(
          text: (index + 1).toString(),
          bgColor: bgColor,
          textColor: primaryColor,
        ),
        _buildTableCell(
          text: DateTime.now().ddMMyyHHss,
          bgColor: bgColor,
          textColor: primaryColor,
        ),
        _buildTableCell(
          text: prize.prize.label,
          bgColor: bgColor,
          textColor: primaryColor,
        ),
      ],
    );
  }

  _buildTableCell({
    required String text,
    required Color bgColor,
    Color? textColor,
  }) {
    return TableCell(
      child: Container(
        color: bgColor,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Text(text, style: TextStyle(fontSize: 16, color: textColor)),
      ),
    );
  }
}
