import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_card.dart';

class PasswordFormBuilder extends StatefulWidget {
  final String? initialValue, hintText;
  final bool? enabled;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode, nextFocusNode;
  final VoidCallback? submitAction;
  final FormFieldValidator<String>? validateFunction;
  final void Function(String)? onSaved, onChange;
  final IconData? prefix, suffix;
  final ObscureTextValue obscureTextValue = ObscureTextValue(true);
  final String? helperText, errorText, labelText;

  PasswordFormBuilder({
    this.prefix,
    this.suffix,
    this.initialValue,
    this.enabled,
    this.hintText,
    this.textInputType,
    this.controller,
    this.textInputAction,
    this.nextFocusNode,
    this.focusNode,
    this.submitAction,
    this.validateFunction,
    this.onSaved,
    this.onChange,
    Key? key,
    this.helperText,
    this.errorText,
    this.labelText,
  }) : super(key: key);

  @override
  State<PasswordFormBuilder> createState() => _PasswordFormBuilderState();
}

class _PasswordFormBuilderState extends State<PasswordFormBuilder> {
  String? error;

  @override
  Widget build(BuildContext context) {
    bool isFocused = false;
    return FocusScope(
      onFocusChange: (focused) => isFocused = focused,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCard(
            borderRadius: BorderRadius.circular(5.0),
            child: Theme(
              data: ThemeData(
                primaryColor: Theme.of(context).colorScheme.secondary,
                colorScheme: ColorScheme.fromSwatch().copyWith(
                    secondary: Theme.of(context).colorScheme.secondary),
              ),
              child: TextFormField(
                initialValue: widget.initialValue,
                enabled: widget.enabled,
                onChanged: (val) {
                  widget.onChange?.call(val);
                },
                style: const TextStyle(fontSize: 15.0),
                key: widget.key,
                controller: widget.controller,
                obscureText: widget.obscureTextValue.isObscure,
                keyboardType: widget.textInputType,
                validator: widget.validateFunction,
                onSaved: (val) {
                  error = widget.validateFunction!(val);
                  setState(() {});
                  widget.onSaved!(val!);
                },
                textInputAction: widget.textInputAction,
                focusNode: widget.focusNode,
                onFieldSubmitted: (String term) {
                  if (widget.nextFocusNode != null) {
                    widget.focusNode!.unfocus();
                    FocusScope.of(context).requestFocus(widget.nextFocusNode);
                  } else {
                    widget.submitAction!();
                  }
                },
                decoration: decoration(isFocused),
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          Visibility(
            visible: error != null,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                '$error',
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  decoration(isFocused) {
    return InputDecoration(
        prefixIcon: Icon(
          widget.prefix,
          size: 15.0,
          color: isFocused ? Theme.of(context).colorScheme.secondary : null,
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() => widget.obscureTextValue.changeStatus());
          },
          child: Icon(
            widget.obscureTextValue.isObscure
                ? widget.suffix ?? CupertinoIcons.eye_fill
                : CupertinoIcons.eye_slash_fill,
            color: isFocused ? Theme.of(context).colorScheme.secondary : null,
            size: 15.0,
          ),
        ),
        fillColor: Colors.white,
        filled: true,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Colors.grey[400],
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        border: border(context),
        enabledBorder: border(context),
        focusedBorder: focusBorder(context),
        errorText: widget.errorText,
        labelText: widget.labelText);
  }

  border(BuildContext context) {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(5.0),
      ),
      borderSide: BorderSide(
        color: Colors.black,
        width: 1.0,
      ),
    );
  }

  focusBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      ),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.secondary,
        width: 1.0,
      ),
    );
  }
}

class ObscureTextValue {
  bool isObscure;

  ObscureTextValue(this.isObscure);

  changeStatus() {
    isObscure = !isObscure;
  }
}
