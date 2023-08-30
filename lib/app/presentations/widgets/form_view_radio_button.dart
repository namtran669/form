import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talosix/app/blocs/form_question/form_detail_cubit.dart';
import 'package:talosix/app/styles/app_styles.dart';

//ignore: must_be_immutable
class FormViewRadioButton extends StatefulWidget {
  final RadioViewModel data;
  ValuesDataForm? selected;
  final bool editable;

  FormViewRadioButton({
    Key? key,
    required this.data,
    this.selected,
    required this.editable,
  }) : super(key: key);

  @override
  State<FormViewRadioButton> createState() => _FormViewRadioButtonState();
}

class _FormViewRadioButtonState extends State<FormViewRadioButton> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [];
    if (widget.data.values != null) {
      for (var value in widget.data.values!) {
        widgets.add(GestureDetector(
          onTap: () {
            if (widget.editable) {
              setState(() {
                widget.selected = value;
                context.read<FormDetailCubit>().addFormValue(
                      widget.data.questionKey,
                      ValueResponseForm(
                        value: widget.selected?.value,
                        displayValue: widget.selected?.label,
                      ),
                    );
              });
            }
          },
          child: Row(
            children: [
              Transform.scale(
                scale: 1.3,
                child: Radio<ValuesDataForm>(
                  value: value,
                  groupValue: widget.selected,
                  onChanged: (item) {
                    if (widget.editable) {
                      setState(() {
                        widget.selected = item;
                        context.read<FormDetailCubit>().addFormValue(
                              widget.data.questionKey,
                              ValueResponseForm(
                                value: widget.selected?.value,
                                displayValue: widget.selected?.label,
                              ),
                            );
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 20),
              Flexible(
                child: Text(
                  value.label ?? '',
                  style: AppTextStyles.w400s16black,
                ),
              ),
            ],
          ),
        ));
        widgets.add(const SizedBox(height: 10));
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
