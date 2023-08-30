import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:talosix/app/blocs/form_question/form_detail_cubit.dart';

import '../../styles/app_styles.dart';

//ignore: must_be_immutable
class FormViewDateTime extends StatefulWidget {
  final DateTimeViewModel data;
  DateTime? selected;
  final bool editable;

  FormViewDateTime({
    Key? key,
    required this.data,
    this.selected,
    required this.editable,
  }) : super(key: key);

  @override
  State<FormViewDateTime> createState() => _FormViewDateTimeState();
}

class _FormViewDateTimeState extends State<FormViewDateTime> {
  late TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    if (widget.selected != null) {
      String selectedTime =
          DateFormat(widget.data.format).format(widget.selected!);
      controller = TextEditingController(text: selectedTime);
    } else {
      controller = TextEditingController();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          child: TextFormField(
            style: AppTextStyles.w400s16black,
            readOnly: true,
            controller: controller,
            onTap: () async {
              if (widget.editable) {
                var time = await showDatePicker(
                    context: context,
                    initialDate: widget.selected ?? DateTime.now(),
                    firstDate: DateTime(1960),
                    lastDate: DateTime(2099));
                if (time != null) {
                  setState(() {
                    widget.selected = time;
                    String displayValue =
                        DateFormat(widget.data.format).format(time);
                    controller.text = displayValue;
                    context.read<FormDetailCubit>().addFormValue(
                        widget.data.questionKey,
                        ValueResponseForm(
                          value: widget.selected!.toString(),
                          displayValue: displayValue,
                        ));
                  });
                }
              }
            },
            decoration: widget.editable
                ? AppTextFieldStyle.inputEnable.copyWith(
                    hintText: widget.data.placeholder,
                    suffixIcon: const Icon(Icons.calendar_month),
                  )
                : AppTextFieldStyle.inputDisable.copyWith(
                    hintText: widget.data.placeholder,
                    suffixIcon: const Icon(Icons.calendar_month),
                  ),
          ),
        ),
      ],
    );
  }
}
