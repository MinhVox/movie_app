// ignore_for_file: unnecessary_this, constant_identifier_names

import 'package:final_training_aia/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldInput extends StatefulWidget {
  final String? label;
  final double? labelSize;
  final String? hint;
  final String? text;
  final String? textValidateOK;
  final int? maxLength;
  final String? regex;
  final Color? hintColor;
  final double? textHintSize;
  final FontWeight? fontWeight;
  final bool? readOnly;
  final bool? obscureText;
  final TextAlign? gravity;
  final TextEditingController? controllerText;
  final TextInputType keyboardType;
  final Function(String?)? onSave;
  final GestureTapCallback? onTap;
  final Function(String?)? onChanged;
  final TextStyle? textStyle;
  final String? Function(String?)? validation;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Function(String)? onFieldSubmitted;
  final Function()? onEditingComplete;
  final bool passwordField;
  final String? validationText;
  final FocusNode? focusNode;
  final bool? enabled;

  const TextFieldInput(
      {Key? key,
      this.focusNode,
      this.label,
      this.labelSize,
      this.hint,
      this.text,
      this.textValidateOK,
      this.validationText,
      this.fontWeight,
      this.maxLength,
      this.controllerText,
      this.obscureText = false,
      this.gravity,
      this.regex,
      this.textHintSize,
      this.hintColor,
      this.keyboardType = TextInputType.text,
      this.onSave,
      this.onChanged,
      this.onTap,
      this.readOnly,
      this.textStyle,
      this.validation,
      this.textInputAction,
      this.suffixIcon,
      this.prefixIcon,
      this.onFieldSubmitted,
      this.onEditingComplete,
      this.passwordField = false,
      this.enabled = true})
      : super(key: key);

  @override
  _TextFieldInputState createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  String? validationText;
  bool hidePassword = true;
  DateTime date = DateTime.now();
  bool isTouching = false;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.validationText != null) {
      validationText = widget.validationText;
    }
    return TextFormField(
      focusNode: widget.focusNode,
      onFieldSubmitted: widget.onFieldSubmitted,
      enabled: widget.enabled,
      onTap: widget.onTap,
      readOnly: widget.readOnly ?? false,
      controller: widget.controllerText,
      maxLength: widget.maxLength,
      style: TextStyle(color: AppColors.colorFFFFFF),
      decoration: InputDecoration(
        // border: InputBorder.none,
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.red)),
        errorStyle: const TextStyle(color: Colors.red),
        hintText: widget.hint,
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                width: 2, color: AppColors.colorFFFFFF.withOpacity(0.1))),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                width: 2, color: AppColors.colorFFFFFF.withOpacity(0.1))),
        labelText: widget.label,
        labelStyle: TextStyle(
            color: AppColors.colorFFFFFF.withOpacity(0.5), fontSize: 13),
        suffixIcon: Visibility(
          visible: widget.passwordField,
          child: IconButton(
            padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
            icon: Icon(
              hidePassword ? Icons.visibility_off : Icons.visibility,
              size: 18,
              color: AppColors.colorFFFFFF,
            ),
            onPressed: () {
              setState(() {
                this.hidePassword = !this.hidePassword;
              });
            },
          ),
        ),
      ),
      keyboardType: widget.keyboardType,
      inputFormatters: (widget.regex != null && widget.regex!.isNotEmpty)
          ? [
              LengthLimitingTextInputFormatter(widget.maxLength ?? 255),
              FilteringTextInputFormatter.allow(RegExp(widget.regex!))
            ]
          : [],
      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction ?? TextInputAction.next,
      onEditingComplete: () {
        if (widget.onEditingComplete != null) {
          widget.onEditingComplete?.call();
        } else {
          FocusScope.of(context).nextFocus();
        }
      },
      obscureText: (widget.passwordField && hidePassword),
      onSaved: widget.onSave,
      validator: (value) {
        validationText = widget.validation?.call(value);
        return validationText;
      },
      initialValue: widget.text,
    );
  }
}
