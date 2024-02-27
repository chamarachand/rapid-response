import "package:flutter/material.dart";
import "package:flutter/rendering.dart";

class signin_button extends StatelessWidget {
  final Function()? onTap;

  const signin_button({super.key, required, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // TODO:
      child: Container(
        padding: EdgeInsets.all(25),
        margin: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 165, 223, 249),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
            child: Text(
          "SignIn",
          style: TextStyle(
            color: const Color.fromARGB(255, 4, 47, 86),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        )),
      ),
    );
  }
}
