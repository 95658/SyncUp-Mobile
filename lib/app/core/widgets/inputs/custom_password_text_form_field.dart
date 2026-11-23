import 'package:flutter/material.dart';
import 'package:syncup/app/core/widgets/buttons/custom_ink_well.dart';
import 'package:syncup/app/core/widgets/inputs/custom_text_form_field.dart';

class CustomPasswordTextFormField extends StatefulWidget {
  final String? title;
  final String? hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  const CustomPasswordTextFormField({
    super.key,
    this.title,
    this.hint,
    this.controller,
    this.focusNode,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  State<CustomPasswordTextFormField> createState() => _CustomPasswordTextFormFieldState();
}

class _CustomPasswordTextFormFieldState extends State<CustomPasswordTextFormField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      title: widget.title,
      hint: widget.hint,
      controller: widget.controller,
      focusNode: widget.focusNode,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      obscureText: _obscure,
      keyboardType: TextInputType.visiblePassword,
      prefixIcon: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Icon(Icons.lock_outline, size: 20),
      ),
      suffixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: CustomInkWell(
          onTap: () => setState(() => _obscure = !_obscure),
          child: Icon(
            _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            size: 20,
          ),
        ),
      ),
    );
  }
}
