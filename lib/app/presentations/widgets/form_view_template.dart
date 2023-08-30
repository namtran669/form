
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:talosix/app/presentations/widgets/form_view_datetime.dart';
import 'package:talosix/app/presentations/widgets/form_view_dropdown.dart';
import 'package:talosix/app/presentations/widgets/form_view_radio_button.dart';
import 'package:talosix/app/presentations/widgets/form_view_select_boxes.dart';
import 'package:talosix/app/presentations/widgets/form_view_textfield.dart';
import 'package:talosix/app/styles/app_styles.dart';

import '../../blocs/form_question/form_detail_cubit.dart';
import '../../constants/app_constants.dart';
import 'attachment_photo_button.dart';
import 'common_view.dart';
import 'custom_required_question.dart';
import 'form_query_button.dart';
import 'form_view_radio_button.dart';

class FormViewTemplate extends StatefulWidget {
  final ComponentDetail detail;
  final FormComponentResponse formData;
  final bool editable;
  final FormQueryDetails? query;

  const FormViewTemplate({
    Key? key,
    required this.detail,
    required this.formData,
    required this.editable,
    this.query,
  }) : super(key: key);

  @override
  State<FormViewTemplate> createState() => _FormViewTemplateState();
}

class _FormViewTemplateState extends State<FormViewTemplate> {
  @override
  Widget build(BuildContext context) {
    var currentData = context.read<FormDetailCubit>().saveSubmitData;

    Widget answer;
    switch (widget.detail.type) {
      case 'radio':
      case 'radioButtonWithOther':
        ValuesDataForm? selected;
        if (widget.detail.values != null) {
          for (var item in widget.detail.values!) {
            if (item.value.toString() ==
                currentData[widget.detail.key]?.value.toString()) {
              selected = item;
              break;
            }
          }
        }
        answer = Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: FormViewRadioButton(
            data: RadioViewModel(
              widget.detail.values,
              widget.detail.key,
            ),
            selected: selected,
            editable: widget.editable,
          ),
        );
        break;
      case 'datetime':
        DateTime? selected;
        String format = widget.detail.format ?? 'MM/dd/yyyy';
        String hint = widget.detail.placeholder ?? 'MM/DD/YYYY';
        String? data = currentData[widget.detail.key]?.displayValue;
        String? value = currentData[widget.detail.key]?.value;
        if (value != '' && data != null && data.isNotEmpty) {
          try {
            selected = DateFormat(format).parse(data);
          } catch (e) {
            print('Bad date time data: $data');
          }
        }
        answer = Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: FormViewDateTime(
            data: DateTimeViewModel(
              questionKey: widget.detail.key,
              format: format,
              placeholder: hint,
            ),
            selected: selected,
            editable: widget.editable,
          ),
        );
        break;
      case 'number':
      case 'textfield':
      case 'email':
      case 'phoneNumber':
        String current = '';
        if (currentData[widget.detail.key]?.value?.runtimeType != null) {
          current = currentData[widget.detail.key]?.displayValue.toString() ?? '';
        }
        answer = Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: FormViewTextField(
            data: TextFieldViewModel(
              id: widget.detail.id,
              questionKey: widget.detail.key,
              suffix: widget.detail.suffix,
              type: widget.detail.type,
            ),
            value: current,
            editable: widget.editable,
          ),
        );
        break;
      case 'selectboxes':
        Map<String, bool>? selected = {};
        if (currentData[widget.detail.key] != null) {
          var value = currentData[widget.detail.key];
          if (value != null) {
            selected.addAll(Map<String, bool>.from(value.value));
          }
        }
        answer = Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: FormViewSelectBoxes(
            data: SelectBoxViewModel(
              questionKey: widget.detail.key,
              values: widget.detail.values ?? [],
            ),
            selected: selected,
            editable: widget.editable,
          ),
        );
        break;

      case 'select':
      case 'rangeInput':
        ValuesDataForm? selected;
        if (widget.detail.data?.values != null) {
          for (var item in widget.detail.data!.values!) {
            if (item.value.toString() ==
                currentData[widget.detail.key]?.value.toString()) {
              selected = item;
              break;
            }
          }
        }

        answer = Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: FormViewDropdown(
            data: DropDownViewModel(
              questionKey: widget.detail.key,
              data: widget.detail.data ?? DataForm('', '', '', []),
            ),
            selected: selected,
            editable: widget.editable,
          ),
        );
        break;

      default:
        answer = emptyBox;
    }

    return BlocBuilder<FormDetailCubit, FormDetailState>(
      builder: (context, state) {
        if (state is FormDetailSelected) {
          Conditional? conditional = widget.detail.conditional;
          String? conditionalKey = conditional?.when;
          if (state.key == conditionalKey) {
            if (state.value != conditional?.eq.toString()) {
              return emptyBox;
            }
          } else {
            if (!isShouldShow()) return emptyBox;
          }
        } else {
          if (!isShouldShow()) return emptyBox;
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 16),
              question(),
              const SizedBox(height: 3),
              FormQueryButton(
                queryKey: widget.detail.key,
                question: question(),
              ),
              const SizedBox(height: 3),
              _shouldShowOptionsQuestion()
                  ? AttachmentPhotoButton(questionKey: widget.detail.key)
                  : emptyBox,
              widget.editable ? eligibleMessage() : emptyBox,
              requireEligibleAnswer(),
              const SizedBox(height: 3),
              unansweredReason(),
              answer,
            ],
          ),
        );
      },
    );
  }

  bool _shouldShowOptionsQuestion() => widget.detail.input && widget.editable;

  Widget question() {
    String label = widget.detail.label;
    if (widget.detail.type == 'htmlelement') {
      return Html(
        data: widget.detail.content,
        style: {
          'body': Style(
            fontSize: const FontSize(16.0),
            fontFamily: AppConstants.fontFamily,
          ),
        },
      );
    } else {
      if (label.startsWith('<')) {
        return Html(
          data: label,
          style: {
            'body': Style(
              fontSize: const FontSize(16.0),
              fontFamily: AppConstants.fontFamily,
              fontWeight: FontWeight.w400,
            ),
          },
        );
      }
      bool required = widget.detail.validate.required;
      return required
          ? RequiredText(label)
          : Text(
              label,
              style: AppTextStyles.w400s16black,
            );
    }
  }

  bool isShouldShow() {
    var data = context.read<FormDetailCubit>().saveSubmitData;
    String conditionalKey = widget.detail.conditional?.when ?? '';

    if (widget.detail.conditional?.show == null) return true;
    if (!data.containsKey(conditionalKey)) return false;
    if (data[conditionalKey]?.value != widget.detail.conditional?.eq) {
      return false;
    }
    return widget.detail.conditional?.show ?? true;
  }

  Widget eligibleMessage() {
    var saveSubmitData = context.read<FormDetailCubit>().saveSubmitData;
    if (widget.detail.eligibleValues == null) return emptyBox;
    if (widget.detail.eligibleValues!.isEmpty) return emptyBox;
    if (!saveSubmitData.containsKey(widget.detail.key)) return emptyBox;
    if (saveSubmitData[widget.detail.key]?.value == '') return emptyBox;

    String selected = [saveSubmitData[widget.detail.key]?.value].toString();
    if (widget.detail.eligibleValues.toString().compareTo(selected) != 0) {
      return const Text(
        'This patient is not eligible to participate in this study.',
        style: AppTextStyles.w400s16red,
      );
    }

    return emptyBox;
  }

  Widget unansweredReason() {
    var data = context.read<FormDetailCubit>().saveSubmitData;
    if (!data.containsKey(widget.detail.key)) return emptyBox;
    if (data[widget.detail.key]?.unansweredReason == null) return emptyBox;
    return Text(
      data[widget.detail.key]!.displayValue!,
      style: AppTextStyles.w400s16red,
    );
  }

  Widget requireEligibleAnswer() {
    return BlocBuilder<FormDetailCubit, FormDetailState>(
        builder: (context, state) {
      if (state is FormDetailValidateEligible) {
        if (state.questions.contains(widget.detail)) {
          return const Text(
            'The answer for this eligibility question cannot be empty',
            style: AppTextStyles.w400s16red,
          );
        }
      }
      return emptyBox;
    });
  }
}