import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class RiveLoginAnimation extends StatefulWidget {
  final Function(
    SMIBool isChecking,
    SMIBool isHandsUp,
    SMIBool isLookDown,
    SMITrigger trigSuccess,
    SMITrigger trigFail,
  )
  onInit;

  const RiveLoginAnimation({super.key, required this.onInit});

  @override
  State<RiveLoginAnimation> createState() => _RiveLoginAnimationState();
}

class _RiveLoginAnimationState extends State<RiveLoginAnimation> {
  Artboard? _artboard;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/animations/bear_login.riv').then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      final controller = StateMachineController.fromArtboard(
        artboard,
        'Login Machine',
      );

      if (controller != null) {
        artboard.addController(controller);

        final isChecking = controller.findInput<bool>('isChecking') as SMIBool;
        final isHandsUp = controller.findInput<bool>('isHandsUp') as SMIBool;
        final isLookDown = controller.findInput<bool>('isLookDown') as SMIBool;
        final trigSuccess =
            controller.findInput<bool>('trigSuccess') as SMITrigger;
        final trigFail = controller.findInput<bool>('trigFail') as SMITrigger;

        widget.onInit(isChecking, isHandsUp, isLookDown, trigSuccess, trigFail);

        setState(() {
          _artboard = artboard;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _artboard == null
        ? const Center(child: CircularProgressIndicator())
        : Rive(artboard: _artboard!, fit: BoxFit.contain);
  }
}
