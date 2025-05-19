import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spin_wheel/colors.dart';
import 'package:spin_wheel/prize_item_model.dart';
import 'package:spin_wheel/triangle_clipper.dart';
import 'package:spin_wheel/wheel_painter.dart';

class SpinWheelScreen extends StatefulWidget {
  const SpinWheelScreen({super.key});

  @override
  State<SpinWheelScreen> createState() => _SpinWheelScreenState();
}

class _SpinWheelScreenState extends State<SpinWheelScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _animation;

  final Random _random = Random();

  double _finalAngle = 0;

  bool _isSpinning = false;

  String _result = "";

  final List<PrizeItem> _prizes = [
    PrizeItem(label: "5% Off Your Order", color: yellowStatColor),
    PrizeItem(label: "5% Off Your Order", color: secondaryColor),
    PrizeItem(label: "5% Off Your Order", color: yellowStatColor),
    PrizeItem(
      label: "FREE MEAL!",
      color: secondaryColor,
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
    ),
    PrizeItem(label: "5% Off Your Order", color: yellowStatColor),
    PrizeItem(label: "5% Off Your Order", color: secondaryColor),
    PrizeItem(label: "5% Off Your Order", color: yellowStatColor),
    PrizeItem(
      label: "FREE MEAL!",
      color: secondaryColor,
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
    ),
    PrizeItem(label: "5% Off Your Order", color: yellowStatColor),
    PrizeItem(label: "5% Off Your Order", color: secondaryColor),
    PrizeItem(label: "5% Off Your Order", color: yellowStatColor),
    PrizeItem(
      label: "FREE MEAL!",
      color: secondaryColor,
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
    ),
    PrizeItem(label: "5% Off Your Order", color: yellowStatColor),
    PrizeItem(label: "5% Off Your Order", color: secondaryColor),
    PrizeItem(label: "5% Off Your Order", color: yellowStatColor),
    PrizeItem(
      label: "FREE MEAL!",
      color: secondaryColor,
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutExpo,
    );

    _animation.addListener(() {
      setState(() {});
    });

    _animation.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          setState(
            () {
              _isSpinning = false;

              // Determine which prize was won based on the final angle
              final segmentAngle = 2 * pi / _prizes.length;
              final normalizedAngle = (_finalAngle % (2 * pi));
              final segment = ((normalizedAngle) / segmentAngle).floor();
              _result = _prizes[(segment % _prizes.length) - 1].label;

              // Show the result dialog
              Future.delayed(
                const Duration(milliseconds: 500),
                () {
                  // _showResultDialog(_result);
                  if (!mounted) return;
                  _showResultDialog(_result);
                },
              );
            },
          );
        }
      },
    );
  }

  void _spinWheel() {
    if (_isSpinning) return;

    setState(() {
      _isSpinning = true;
      _result = "";

      // Generate a random number of full rotations (3-5) plus a random angle
      final spinCount = 3 + _random.nextInt(3);
      final randomAngle = _random.nextDouble() * 2 * pi;
      _finalAngle = (spinCount * 2 * pi) + randomAngle;

      // Reset and start the animation
      _animationController.reset();
      _animationController.forward();
    });
  }

  void _showResultDialog(String prize) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: Text('You won: $prize'),
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
          child: Stack(
        children: [
          _buildHeadingView(),
          // Spin wheel
          Positioned(
            right: -100,
            left: -100,
            bottom: -200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Main wheel
                SizedBox.square(
                  dimension: 700,
                  child: Transform.rotate(
                    angle: _animation.value * _finalAngle,
                    child: CustomPaint(
                      painter: WheelPainter(_prizes),
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
                  top: 20,
                  child: ClipPath(
                    clipper: TriangleClipper(isRotated: true),
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
      )),
    );
  }

  Widget _buildHeadingView() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        spacing: 20,
        children: [
          const SizedBox.shrink(),
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
            onPressed: _isSpinning ? () {} : _spinWheel,
            child: Text(
              _isSpinning ? 'Spinning...' : 'SPIN!',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
