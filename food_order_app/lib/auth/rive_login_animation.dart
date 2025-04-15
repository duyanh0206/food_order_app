import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

/// Controller interface for the bear animation
abstract class RiveController {
  void setLookDirection(double value);
  void setHandsUp(bool handsUp);
  void setWrongInput(bool wrong);
  void setSuccess();
  void setFail();
}

/// InheritedWidget to provide animation controller to descendants
class RiveLoginAnimationController extends InheritedWidget {
  final RiveController controller;

  const RiveLoginAnimationController({
    required this.controller,
    required Widget child,
    super.key,
  }) : super(child: child);

  static RiveController? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<RiveLoginAnimationController>()
        ?.controller;
  }

  @override
  bool updateShouldNotify(RiveLoginAnimationController oldWidget) => false;
}

class RiveLoginAnimationWrapper extends StatefulWidget {
  final Widget child;

  const RiveLoginAnimationWrapper({required this.child, super.key});

  @override
  RiveLoginAnimationWrapperState createState() => RiveLoginAnimationWrapperState();
}

class RiveLoginAnimationWrapperState extends State<RiveLoginAnimationWrapper>
    implements RiveController {
  Artboard? _artboard;
  StateMachineController? _controller;

  // State machine inputs
  SMIBool? _isHandsUp;
  SMIBool? _isChecking;
  SMINumber? _numLook;
  SMITrigger? _trigSuccess;
  SMITrigger? _trigFail;

  // Animation control variables
  double _currentLookValue = 0.0;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  Future<void> _loadRiveFile() async {
    try {
      final bytes = await rootBundle.load('assets/animations/bear.riv');
      final file = RiveFile.import(bytes);

      final artboard = file.mainArtboard;
      var controller = StateMachineController.fromArtboard(
        artboard,
        'Login Machine',
      );

      if (controller != null) {
        artboard.addController(controller);
        _controller = controller;

        // Initialize state machine inputs
        _isHandsUp = controller.findSMI('isHandsUp') as SMIBool?;
        _isChecking = controller.findSMI('isChecking') as SMIBool?;
        _numLook = controller.findSMI('numLook') as SMINumber?;
        _trigSuccess = controller.findSMI('trigSuccess') as SMITrigger?;
        _trigFail = controller.findSMI('trigFail') as SMITrigger?;

        // Set initial states
        _numLook?.value = 0.0;
        _isHandsUp?.value = false;
        _isChecking?.value = false;
      }

      setState(() => _artboard = artboard);
    } catch (e) {
      debugPrint('Error loading Rive file: $e');
    }
  }

  void _animateLookValue(double targetValue) {
    if (_isAnimating) return;
    _isAnimating = true;

    const duration = Duration(milliseconds: 300);
    final startValue = _currentLookValue;
    final diff = targetValue - startValue;

    const steps = 30;
    for (int i = 0; i <= steps; i++) {
      Future.delayed(duration * i ~/ steps, () {
        if (_numLook != null) {
          final progress = i / steps;
          _currentLookValue = startValue + (diff * progress);
          _numLook!.value = _currentLookValue;
        }
        if (i == steps) _isAnimating = false;
      });
    }
  }

  @override
  void setLookDirection(double value) {
    // Only move eyes during email input, not during other states
    if (_numLook != null && 
        !_isHandsUp!.value && 
        !_isChecking!.value) {
      final targetValue = value.clamp(0.0, 1.0);
      if (_currentLookValue != targetValue) {
        _animateLookValue(targetValue);
      }
    }
  }

  @override
  void setHandsUp(bool handsUp) {
    if (_isHandsUp != null) {
      _isHandsUp!.value = handsUp;
      if (handsUp) {
        _animateLookValue(0.0);
      }
    }
  }

  @override
  void setWrongInput(bool wrong) {
    // Only show anxiety on login validation failures
    if (wrong && _isChecking != null) {
      _isChecking!.value = true;
      _isHandsUp?.value = false;
      _animateLookValue(0.0);
      _trigFail?.fire();
    }
  }

  @override
  void setSuccess() {
    _isChecking?.value = false;
    _isHandsUp?.value = false;
    _animateLookValue(0.0);
    _trigSuccess?.fire();
  }

  @override
  void setFail() {
    _isChecking?.value = true;
    _isHandsUp?.value = false;
    _animateLookValue(0.0);
    _trigFail?.fire();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RiveLoginAnimationController(
      controller: this,
      child: Column(
        children: [
          BearAnimationWidget(artboard: _artboard),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}

class BearAnimationWidget extends StatelessWidget {
  final Artboard? artboard;
  const BearAnimationWidget({super.key, required this.artboard});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: artboard == null
            ? const CircularProgressIndicator()
            : Rive(
                artboard: artboard!,
                fit: BoxFit.contain,
                antialiasing: true,
              ),
      ),
    );
  }
}