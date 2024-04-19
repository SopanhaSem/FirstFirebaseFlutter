import 'package:flutter/material.dart';

class TextFielWidget extends StatelessWidget {
  TextFielWidget(
      {super.key,
      this.controller,
      this.hieght,
      this.hintText,
      this.isReadonly,
      this.prefixIcon,
      this.suffixIcon,
      this.width,
      this.hintPassword});
  TextEditingController? controller = TextEditingController();
  String? hintText;
  bool? isReadonly;
  bool? hintPassword;
  double? hieght;

  double? width;
  IconData? prefixIcon;
  IconButton? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: hieght ?? 60,
        width: width ?? double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.grey),
        child: TextField(
          obscureText: hintPassword ?? false,
          controller: controller,
          readOnly: isReadonly ?? false,
          decoration: InputDecoration(
              prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              hintText: hintText ?? 'Enter some text'),
        ),
      ),
    );
  }
}
