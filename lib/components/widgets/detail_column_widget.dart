import 'dart:ui';
import 'package:flutter/material.dart';

class InformationColumnWidget extends StatelessWidget {
  final String title;
  final String value;
  final Icon icon;
  final Color shadowColor;
  const InformationColumnWidget({
    required this.shadowColor,
    required this.icon,
    required this.title,
    required this.value,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 40.0,
          sigmaY: 40.0,
        ),
        child: Container(
          width: size.width,
          height: size.height / 13,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(
                15,
              ),
            ),
            color: Color.fromARGB(
              30,
              158,
              158,
              158,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: shadowColor,
                              blurRadius: 5,
                              spreadRadius: 1,
                            )
                          ],
                          color: const Color(
                            0xff2C2D35,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              10,
                            ),
                          ),
                        ),
                        child: icon,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        title,
                      ),
                    ],
                  ),
                ),
                Text(
                  value,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
