import 'dart:collection';

import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talosix/app/styles/app_styles.dart';

import '../../blocs/form_question/form_detail_cubit.dart';

//ignore: must_be_immutable
class FormViewSelectBoxes extends StatefulWidget {
  final SelectBoxViewModel data;
  Map<String, bool>? selected;
  final bool editable;

  FormViewSelectBoxes({
    Key? key,
    required this.data,
    this.selected,
    required this.editable,
  }) : super(key: key);

  @override
  State<FormViewSelectBoxes> createState() => _FormViewSelectBoxesState();
}

class _FormViewSelectBoxesState extends State<FormViewSelectBoxes> {
  @override
  void initState() {
    super.initState();
    widget.selected ??= {};
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [];

    widget.data.values.asMap().forEach((key, value) {
      widgets.add(
        ListTile(
          title: Text(
            value.label!,
            style: AppTextStyles.w400s16black,
          ),
          leading: Checkbox(
            value: widget.selected?[key.toString()] ?? false,
            onChanged: (selected) {
              if(widget.editable) {
                setState(() {
                  widget.selected?[key.toString()] = selected!;
                  context.read<FormDetailCubit>().addFormValue(
                    widget.data.questionKey,
                    ValueResponseForm(
                      value: widget.selected,
                      displayValue: [],
                    ),
                    shouldNotifyChange: false
                  );
                });
              }
            },
          ),
          contentPadding: const EdgeInsets.only(left: 0),
        ),
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
