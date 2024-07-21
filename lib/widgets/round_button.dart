import "package:flutter/material.dart";

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback ontap;

  bool loading;
  RoundButton(
      {super.key,
      required this.title,
      required this.ontap,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
              color: Colors.purple, borderRadius: BorderRadius.circular(12)),
          child: Center(
              child: loading
                  ? CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    )
                  : Text(
                      title,
                      style: TextStyle(color: Colors.white),
                    )),
        ),
      ),
    );
  }
}
