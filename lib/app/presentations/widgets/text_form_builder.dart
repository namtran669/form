import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import 'custom_card.dart';

class TextFormBuilder extends StatefulWidget {
  final String? initialValue;
  final bool? enabled;
  final String? hintText;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final bool? obscureText;
  final FocusNode? focusNode, nextFocusNode;
  final VoidCallback? submitAction;
  final void Function(String)? onChange;
  final IconData? prefix;
  final IconData? suffix;
  final InputDecoration? inputDecoration;
  final String? helperText, errorText, labelText;

  const TextFormBuilder({
    Key? key,
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
    this.obscureText = false,
    this.onChange,
    this.inputDecoration,
    this.helperText,
    this.errorText,
    this.labelText,
  }) : super(key: key);

  @override
  State<TextFormBuilder> createState() => _TextFormBuilderState();
}

class _TextFormBuilderState extends State<TextFormBuilder> {
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
                onChanged: (val) => widget.onChange?.call(val),
                style: const TextStyle(fontSize: 15.0),
                controller: widget.controller,
                obscureText: widget.obscureText!,
                keyboardType: widget.textInputType,
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
        suffixIcon: Icon(
          widget.suffix,
          size: 15.0,
        ),
        hintText: widget.hintText,
        helperText: widget.helperText,
        errorText: widget.errorText,
        fillColor: Colors.white,
        filled: true,
        hintStyle: TextStyle(color: Colors.grey[400]),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        border: border(),
        enabledBorder: border(),
        focusedBorder: focusBorder(),
        labelText: widget.labelText);
  }

  border() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(5.0),
      ),
      borderSide: BorderSide(
        color: Colors.black,
        width: 1,
      ),
    );
  }

  focusBorder() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(5.0),
      ),
      borderSide: BorderSide(
        color: AppColors.pictonBlue,
        width: 1.0,
      ),
    );
  }
}
