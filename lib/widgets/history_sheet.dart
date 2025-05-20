import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spin_wheel/controllers/spin_wheel_controller.dart';
import 'package:spin_wheel/shared/colors.dart';

class HistorySheet extends StatelessWidget {
  const HistorySheet({super.key});

  @override
  Widget build(BuildContext context) {
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
            spacing: 20,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "History",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Table(
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
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Text("No."),
                      ),
                      TableCell(child: Text("Time")),
                      TableCell(child: Text("Reward")),
                    ],
                  ),
                  ...context
                      .watch<SpinWheelController>()
                      .winHistory
                      .indexed
                      .map(
                    (e) {
                      return TableRow(
                        children: [
                          TableCell(child: Text((e.$1 + 1).toString())),
                          TableCell(child: Text(DateTime.now().toString())),
                          TableCell(child: Text(e.$2.label)),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
