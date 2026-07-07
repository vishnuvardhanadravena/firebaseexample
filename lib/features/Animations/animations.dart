import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:math';

class AnimationExample extends StatefulWidget {
  const AnimationExample({super.key});

  @override
  State<AnimationExample> createState() => _AnimationExampleState();
}

class _AnimationExampleState extends State<AnimationExample>
    with TickerProviderStateMixin {
  late Ticker _ticker;
  int time = 0;
  int callbackCount = 0;
  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      print("${elapsed.inSeconds}");
      print(
        'Second: ${elapsed.inSeconds}, '
        'Callbacks: $callbackCount',
      );
      setState(() {
        time = elapsed.inSeconds;
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _ticker.stop();
    _ticker.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(time.toString()),
          ElevatedButton(
            onPressed: () => _ticker.stop(),
            child: Text("Stop ticker"),
          ),
        ],
      ),
    );
  }
}

class AnimationWithTween extends StatefulWidget {
  const AnimationWithTween({super.key});

  @override
  State<AnimationWithTween> createState() => _AnimationWithTweenState();
}

class _AnimationWithTweenState extends State<AnimationWithTween>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  bool intilized = false;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    intilized = true;

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        // animationController.forward();
      }
    });

    animationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (intilized) {
      animation = Tween<double>(
        begin: 100,
        end: MediaQuery.sizeOf(context).width,
      ).animate(animationController);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(animation.value),
            ),
            border: Border.all(),
          ),
          height: animation.value,
          width: animation.value,
          child: Text("Animation"),
        ),
      ),
    );
  }
}

class SlideAnmationexample extends StatefulWidget {
  const SlideAnmationexample({super.key});

  @override
  State<SlideAnmationexample> createState() => _SlideAnmationexampleState();
}

class _SlideAnmationexampleState extends State<SlideAnmationexample>
    with TickerProviderStateMixin {
  late AnimationController _sidecontroller;
  late Animation<Offset> slideanimation;

  @override
  void initState() {
    super.initState();
    _sidecontroller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    slideanimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: Offset(-1, 0),
    ).animate(_sidecontroller);
    _sidecontroller.forward().then((e) {
      _sidecontroller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: SlideTransition(
        position: slideanimation,
        child: Container(
          height: MediaQuery.sizeOf(context).width / 2,
          width: MediaQuery.sizeOf(context).width / 2,
          decoration: BoxDecoration(border: Border.all()),
          child: TextButton(
            onPressed: () {
              // _sidecontroller.forward().then(());
            },
            child: Text("slide"),
          ),
        ),
      ),
    );
  }
}

class TransfromAnimation extends StatefulWidget {
  const TransfromAnimation({super.key});

  @override
  State<TransfromAnimation> createState() => _TransfromAnimationState();
}

class _TransfromAnimationState extends State<TransfromAnimation> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Transform.rotate(
          angle: pi / 4,
          child: Container(
            width: 50,
            height: 50,
            color: Colors.red,
            child: Text("Transfrom.rotate"),
          ),
        ),
        SizedBox(height: 20),
        Transform.translate(
          offset: Offset(20, 20),
          child: Container(
            child: Center(
              child: Text(
                "Transfrom.translate",
                style: TextStyle(color: Colors.amber),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Center(
          child: Transform.scale(
            scale: 1,
            child: Container(
              width: 100,
              height: 100,
              color: const Color.fromARGB(255, 29, 8, 184),
              child: Text(
                "Transfrom.scale",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CombinedTransformLogo extends StatelessWidget {
  const CombinedTransformLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform(
        alignment: Alignment.center,
        origin: const Offset(20, 20),
        filterQuality: FilterQuality.high,
        transform: Matrix4.identity()
          ..translate(20.0, 20.0)
          ..rotateX(pi / 4)
          ..rotateY(pi / 4)
          ..rotateZ(pi / 4)
          ..scale(1.3)
          ..setEntry(3, 2, 0),
        child: const FlutterLogo(size: 120),
      ),
    );
  }
}
