import 'package:flutter/material.dart';

class AppTextFormField extends StatefulWidget {
  final String hint;
  final TextInputType keyboardType;
  final bool obscureText;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;

  const AppTextFormField({
    Key? key,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    required this.validator,
    required this.controller,
  }) : super(key: key);

  @override
  _AppTextFormField createState() => _AppTextFormField();
}

class _AppTextFormField extends State<AppTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: const TextStyle(color: Colors.grey),
        labelText: widget.hint,
        labelStyle: const TextStyle(
          color: Colors.white,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      validator: (value) {
        final validationResult = widget.validator(value!);
        if (validationResult != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(validationResult),
            ),
          );
        }
        return validationResult;
      },
    );
  }
}
