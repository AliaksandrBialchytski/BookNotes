// ignore_for_file: no_logic_in_create_state, prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, unnecessary_this, unnecessary_brace_in_string_interps

import 'package:book_proj/log_in/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'log_in/authorized_page.dart';

class AnimationPage extends StatefulWidget {
  AnimationPage(
      {required this.authCubit,
      required this.firstName,
      required this.telephone});
  AuthCubit authCubit;
  String firstName;
  String telephone;
  @override
  _AnimationPageState createState() => _AnimationPageState(
      authCubit: this.authCubit, firstName: firstName, telephone: telephone);
}

class _AnimationPageState extends State<AnimationPage>
    with TickerProviderStateMixin {
  _AnimationPageState(
      {required this.authCubit,
      required this.firstName,
      required this.telephone});
  AuthCubit authCubit;
  late AnimationController _controller;
  String firstName;
  String telephone;

  final colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];
  final colorizeTextStyle = TextStyle(
    fontSize: 30.0,
    fontFamily: 'Horizon',
    color: Colors.yellow[900],
  );
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    WidgetsBinding.instance!.addPostFrameCallback((_) => _playAnimation());
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      await _controller.forward().orCancel;
      await _controller.reverse().orCancel;
      authCubit.endTheAnimation();
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signing in process'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: Container(
          alignment: Alignment.bottomCenter,
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            border: Border.all(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Flexible(
                child: AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'Welcome',
                      speed: Duration(milliseconds: 200),
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                    TypewriterAnimatedText(
                      'Welcome, ${firstName}',
                      speed: Duration(milliseconds: 40),
                      textStyle: colorizeTextStyle,
                    ),
                    WavyAnimatedText(
                      'Your phone is  ${telephone}',
                      speed: Duration(milliseconds: 40),
                      textStyle: colorizeTextStyle,
                    ),
                  ],
                  onTap: () {},
                ),
              ),
              Expanded(
                child: StaggerAnimation(controller: _controller //.view
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({Key? key, required this.controller})
      : opacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              0.100,
              curve: Curves.ease,
            ),
          ),
        ),
        width = Tween<double>(
          begin: 50.0,
          end: 150.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.125,
              0.250,
              curve: Curves.ease,
            ),
          ),
        ),
        height = Tween<double>(
          begin: 50.0,
          end: 150.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.250,
              0.375,
              curve: Curves.ease,
            ),
          ),
        ),
        borderRadius = BorderRadiusTween(
          begin: BorderRadius.circular(4.0),
          end: BorderRadius.circular(75.0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.375,
              0.500,
              curve: Curves.ease,
            ),
          ),
        ),
        color = ColorTween(
          begin: Colors.orange,
          end: Colors.purple,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.500,
              0.750,
              curve: Curves.ease,
            ),
          ),
        ),
        padding = EdgeInsetsTween(
          begin: EdgeInsets.only(bottom: 20),
          end: EdgeInsets.only(bottom: 100),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.250,
              0.375,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final AnimationController controller;
  final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<EdgeInsets> padding;
  final Animation<BorderRadius?> borderRadius;
  final Animation<Color?> color;

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Container(
      padding: padding.value,
      alignment: Alignment.bottomCenter,
      child: Opacity(
        opacity: opacity.value,
        child: Container(
          width: width.value,
          height: height.value,
          decoration: BoxDecoration(
            color: color.value,
            border: Border.all(
              color: Colors.indigo[300]!,
              width: 3.0,
            ),
            borderRadius: borderRadius.value,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
      child: AuthorizedPage(),
    );
  }
}
