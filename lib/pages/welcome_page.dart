import 'package:flutter/material.dart';
import 'package:logic_app/core/constants.dart';
import 'package:logic_app/widgets/custom_dialog.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: const Text('UBoth'),
      backgroundColor: const Color.fromARGB(255, 150, 182, 207),
      foregroundColor: Colors.white,
      centerTitle: true,
    );
  }

  _buildBody() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextAnimator(
              WELCOME_MESSAGE,
              atRestEffect: WidgetRestingEffects.pulse(effectStrength: 0.75),
              style: GoogleFonts.zenDots(
                textStyle: const TextStyle(fontSize: 15),
              ),
              incomingEffect: WidgetTransitionEffects.incomingSlideInFromTop(
                blur: const Offset(0, 20),
                duration: const Duration(milliseconds: 700),
                scale: 10,
              ),
            ),
          ),
          // TODO: controller chamando a função de login com o Google
          InkWell(
            onTap: () {
              const snack = SnackBar(content: Text('clicou'));

              ScaffoldMessenger.of(context).showSnackBar(snack);
            },
            onHover: (hovering) {
              setState(() {
                isHovering = hovering;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              curve: Curves.ease,
              padding: EdgeInsets.all(isHovering ? 3 : 0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(242, 242, 242, 250),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Ink(
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Image.asset('assets/icons/gmail_icon_ctn.png'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
