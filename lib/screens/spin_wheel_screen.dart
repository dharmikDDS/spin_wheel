import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spin_wheel/shared/colors.dart';
import 'package:spin_wheel/widgets/history_sheet.dart';
import 'package:spin_wheel/shared/models/prize_item_model.dart';
import 'package:spin_wheel/controllers/spin_wheel_controller.dart';
import 'package:spin_wheel/widgets/triangle_clipper.dart';
import 'package:spin_wheel/widgets/wheel_painter.dart';

class SpinWheelScreen extends StatefulWidget {
  const SpinWheelScreen({super.key});

  @override
  State<SpinWheelScreen> createState() => _SpinWheelScreenState();
}

class _SpinWheelScreenState extends State<SpinWheelScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _initAnimation();
    _setupListners();

    // Initialize Prizes
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<SpinWheelController>().initPrizes(dummyPrizes),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animation.removeListener(
      context.read<SpinWheelController>().listenAnimationChanges,
    );
    _animation.removeListener(_showResultDialog);
    super.dispose();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutExpo,
    );
  }

  void _setupListners() {
    _animation.addListener(
      context.read<SpinWheelController>().listenAnimationChanges,
    );

    _animation.addListener(_showResultDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Consumer<SpinWheelController>(
        builder: (context, controller, _) {
          return SafeArea(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                _buildHeadingView(controller),

                // Spin wheel
                Positioned(
                  right: -100,
                  left: -100,
                  top: -200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Main wheel
                      SizedBox.square(
                        dimension: 800,
                        child: Transform.rotate(
                          angle: _animation.value * controller.angleToSpin,
                          child: CustomPaint(
                            painter: WheelPainter(controller.prizes),
                          ),
                        ),
                      ),

                      // Center of wheel
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: primaryColor,
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: secondaryColor,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: primaryColor,
                            child: Icon(
                              Icons.star,
                              color: whiteColor,
                              size: 40,
                            ),
                          ),
                        ),
                      ),

                      // Pointer
                      Positioned(
                        bottom: 60,
                        child: ClipPath(
                          clipper: TriangleClipper(),
                          child: Material(
                            color: transparentColor,
                            elevation: 50,
                            child: Container(
                              color: whiteColor,
                              height: 70,
                              width: 50,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          useSafeArea: true,
          isScrollControlled: true,
          enableDrag: true,
          showDragHandle: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          builder: (_) => HistorySheet(),
        ),
        child: Icon(Icons.history_rounded),
      ),
    );
  }

  Widget _buildHeadingView(SpinWheelController controller) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 20,
        children: [
          Text(
            "Spin to Win!",
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: whiteColor),
          ),
          Text(
            "Spin the wheel to win your\nweekly reward!",
            style: TextStyle(fontSize: 16, color: whiteColor),
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            onPressed: _animationController.isAnimating
                ? () {}
                : () {
                    context.read<SpinWheelController>().spin();
                    // Reset and start the animation
                    _animationController.reset();
                    _animationController.forward();
                  },
            child: Text(
              _animationController.isAnimating ? 'Spinning...' : 'SPIN!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox.shrink(),
        ],
      ),
    );
  }

  void _showResultDialog() {
    if (_animation.isCompleted) {
      Future.delayed(Duration(milliseconds: 500));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Congratulations!'),
            content: Text(
              'You won: ${context.read<SpinWheelController>().wonPrize?.label}',
            ),
            backgroundColor: Colors.purple[100],
            titleTextStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
            contentTextStyle: const TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Claim Prize'),
              ),
            ],
          );
        },
      );
    }
  }
}
