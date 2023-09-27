import 'package:flutter/material.dart';
import '../../main.dart';
import '../../user_management/pte_app_theme.dart';

class GlassView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 24),
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: HexColor("#D7E0F9"),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 68, bottom: 12, right: 16, top: 12),
                        child: Text(
                          'Stay tuned for exciting features to enhance your experience!',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: PteAppTheme.fontName,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            letterSpacing: 0.0,
                            color: PteAppTheme.nearlyDarkBlue.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -5,
                left: 10,
                child: SizedBox(
                  width: 45,
                  height: 50,
                  child: Image.asset("assets/images/information.png"),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
