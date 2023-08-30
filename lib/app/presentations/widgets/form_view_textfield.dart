import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talosix/app/styles/app_styles.dart';
import 'package:talosix/app/util/debounce.dart';

import '../../blocs/form_question/form_detail_cubit.dart';
import 'common_view.dart';

//ignore: must_be_immutable
class FormViewTextField extends StatefulWidget {
  final TextFieldViewModel data;
  String value;
  TextEditingController? controller;
  final bool editable;

  FormViewTextField({
    Key? key,
    required this.data,
    required this.value,
    required this.editable,
  }) : super(key: key);

  @override
  State<FormViewTextField> createState() => _FormViewTextFieldState();

  String getValue() {
    return controller!.text.toString();
  }
}

class _FormViewTextFieldState extends State<FormViewTextField> {
  late TextInputType inputType;
  final _debounce = Debounce(milliseconds: 1000);

  @override
  void initState() {
    widget.controller ??= TextEditingController(text: widget.value);
    switch (widget.data.type) {
      case 'number':
        inputType = TextInputType.number;
        break;
      default:
        inputType = TextInputType.text;
        break;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  style: AppTextStyles.w400s16black,
                  readOnly: !widget.editable,
                  controller: widget.controller,
                  keyboardType: inputType,
                  maxLines: null,
                  decoration: widget.editable
                      ? AppTextFieldStyle.inputEnable
                      : AppTextFieldStyle.inputDisable,
                  onChanged: (value) {
                    _debounce.run(() {
                      context.read<FormDetailCubit>().addFormValue(
                          widget.data.questionKey,
                          ValueResponseForm(
                            value: value,
                            displayValue: value,
                          ));
                    });
                  },
                ),
              ),
              widget.data.suffix?.isNotEmpty ?? false
                  ? _SuffixWidget(
                      text: widget.data.suffix!,
                      onCheckedChange: (isChecked) {},
                    )
                  : emptyBox,
            ],
          ),
        )
      ],
    );
  }
}

class _SuffixWidget extends StatefulWidget {
  final String text;
  final Function(bool) onCheckedChange;

  const _SuffixWidget(
      {Key? key, required this.text, required this.onCheckedChange})
      : super(key: key);

  @override
  State<_SuffixWidget> createState() => _SuffixWidgetState();
}

class _SuffixWidgetState extends State<_SuffixWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.text == 'Unknown') {
      return Row(
        children: [
          const VerticalDivider(
            thickness: 1,
            color: Colors.black54,
          ),
          Checkbox(
            value: true,
            onChanged: (isChecked) {
              widget.onCheckedChange(isChecked!);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 5),
            child: Text(widget.text),
          ),
        ],
      );
    } else {
      return emptyBox;
    }
  }
}
