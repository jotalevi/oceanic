import 'package:flutter/material.dart';

class TextFieldInput extends StatefulWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final Function(String)? callback;
  final bool Function(String) validator;
  const TextFieldInput({
    super.key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
    this.callback,
    this.validator = _defaultValidator,
  });

  @override
  State<TextFieldInput> createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(
        context,
        color: _crColor(widget.textEditingController.text, widget.validator),
        width: 1,
      ),
    );

    return TextField(
      controller: widget.textEditingController,
      style: TextStyle(
        color: _crColor(widget.textEditingController.text, widget.validator),
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontSize: 14,
        ),
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: widget.textInputType,
      obscureText: widget.isPass,
      onChanged: (_) {
        widget.callback!(_);
      },
    );
  }
}

Color _crColor(text, validator) {
  return text.isEmpty
      ? Colors.white.withOpacity(0.5)
      : validator(text)
          ? Colors.white.withOpacity(0.75)
          : Colors.white.withOpacity(0.5);
}

bool _defaultValidator(String text) => text.isNotEmpty;
