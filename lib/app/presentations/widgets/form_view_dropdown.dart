import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/form_question/form_detail_cubit.dart';
import '../../styles/app_styles.dart';

//ignore: must_be_immutable
class FormViewDropdown extends StatefulWidget {
  final DropDownViewModel data;
  ValuesDataForm? selected;
  final bool editable;

  FormViewDropdown({
    Key? key,
    required this.data,
    this.selected,
    required this.editable,
  }) : super(key: key);

  @override
  State<FormViewDropdown> createState() => _FormViewDropdownState();
}

class _FormViewDropdownState extends State<FormViewDropdown> {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.editable,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
            width: double.maxFinite,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.0,
                color: Colors.grey,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(4.0),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 8,
            ),
            child: DropdownButton<ValuesDataForm>(
              underline: const SizedBox.shrink(),
              hint: Text(
                widget.selected?.label.toString() ?? 'Please select one item',
                style: AppTextStyles.w400s16black,
              ),
              isExpanded: true,
              items: widget.data.data.values
                  ?.map(
                    (element) => DropdownMenuItem<ValuesDataForm>(
                      value: element,
                      child: Text(
                        element.label.toString(),
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  widget.selected = newValue;
                  context.read<FormDetailCubit>().addFormValue(
                      widget.data.questionKey.toString(),
                      ValueResponseForm(
                        value: widget.selected?.value.toString(),
                        displayValue: widget.selected?.label.toString(),
                      ));
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
