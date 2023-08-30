import 'package:domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:talosix/app/extensions/context_ext.dart';
import 'package:talosix/app/styles/app_styles.dart';
import 'package:talosix/app/ui_model/transfer_custom_data_model.dart';

import '../../blocs/form_question/form_detail_cubit.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../routes/routes.dart';
import '../widgets/common_view.dart';
import '../widgets/custom_required_question.dart';

class FormDataChangedListScreen extends StatelessWidget {
  const FormDataChangedListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FormDataChangedWithType data =
        ModalRoute.of(context)!.settings.arguments as FormDataChangedWithType;
    String unansweredTitle = 'There are some required questions are unanswered.'
        ' Please go back to complete all these questions'
        ' or specify the reason for unanswered questions';
    String changeQueryTitle = 'There are some questions which have query change'
        ' responses. Please specific the reason for questions';
    String title = data.type == FormDataChangedType.unanswered
        ? unansweredTitle
        : changeQueryTitle;

    List<String> options = data.type == FormDataChangedType.unanswered
        ? unansweredOptions
        : changedQueryOptions;

    String unansweredScreenTitle = 'Complete Required Questions';
    String changeQueryScreenTitle = 'Reason For Changes';
    String screenTitle = data.type == FormDataChangedType.unanswered
        ? unansweredScreenTitle
        : changeQueryScreenTitle;

    List<Widget> questions = [];
    for (var question in data.questions) {
      questions.add(DataChangedSection(
        data: question,
        options: options,
        type: data.type,
      ));
    }

    var formDetailCubit = context.read<FormDetailCubit>();
    formDetailCubit.clearAllUnSubmitReason();
    return BlocConsumer<FormDetailCubit, FormDetailState>(
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is FormDetailSubmitDataProcessing,
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: Text(
                screenTitle,
                style: AppTextStyles.w500s18holly,
              ),
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black),
              actions: [
                IconButton(
                  onPressed: () {
                    context.read<FormDetailCubit>().submit();
                  },
                  icon: ImageIcon(
                    AssetImage(AppIcons.formSubmit),
                    color: Colors.blue,
                    size: 24,
                  ),
                )
              ],
              centerTitle: false,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    title,
                    style: AppTextStyles.w500s16black,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) => DataChangedSection(
                        data: data.questions[index],
                        options: options,
                        type: data.type,
                      ),
                      itemCount: data.questions.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) async {
        if (state is FormDetailSubmitSuccess) {
          Navigator.of(context).popUntil(
                (route) => route.settings.name == Routes.forms,
          );
        } else if (state is FormDetailError) {
          context.showMessage(ToastMessageType.error, state.msg);
        }
      },
    );
  }
}

class DataChangedSection extends StatelessWidget {
  final DataChangedForm data;
  final List<String> options;
  final FormDataChangedType type;

  const DataChangedSection({
    Key? key,
    required this.data,
    required this.options,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> questions = [];
    for (var item in data.questions) {
      questions.add(_DataChangedItem(
        question: item,
        options: options,
        type: type,
      ));
    }
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.0,
            color: Colors.black54,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.title.toUpperCase(),
              style: const TextStyle(
                color: AppColors.shakespeare,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: questions,
            )
          ],
        ),
      ),
    );
  }
}

class _DataChangedItem extends StatefulWidget {
  const _DataChangedItem({
    Key? key,
    required this.question,
    required this.options,
    required this.type,
  }) : super(key: key);

  final ComponentDetail question;
  final List<String> options;
  final FormDataChangedType type;

  @override
  State<_DataChangedItem> createState() => _DataChangedItemState();
}

class _DataChangedItemState extends State<_DataChangedItem> {
  bool _isValid = true;
  String? reason;
  String? otherReason;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var formDetailCubit = context.read<FormDetailCubit>();
    controller.text = otherReason ?? '';
    return BlocBuilder<FormDetailCubit, FormDetailState>(
      builder: (context, state) {
        if (state is FormDetailDataChangedInvalid) {
          _isValid = !state.questions.contains(widget.question);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _question(),
            const SizedBox(height: 10),
            Container(
              height: 60,
              width: double.maxFinite,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: _isValid ? Colors.black54 : Colors.red,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(4.0),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 8,
              ),
              child: DropdownButton<String>(
                underline: const SizedBox.shrink(),
                value: reason,
                isExpanded: true,
                items: widget.options
                    .map((element) => DropdownMenuItem<String>(
                        value: element,
                        child: Text(
                          element,
                          style: AppTextStyles.w400s16black,
                          maxLines: null,
                          softWrap: true,
                        )))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    reason = newValue;
                    _isValid = true;
                    if (widget.type == FormDataChangedType.unanswered) {
                      formDetailCubit.addUnansweredReason(
                        widget.question.key,
                        reason,
                      );
                    } else {
                      formDetailCubit.addChangeAnswerReason(
                        widget.question.key,
                        reason,
                      );
                    }
                  });
                },
              ),
            ),
            _isValid
                ? emptyBox
                : const Text(
                    'Required',
                    style: AppTextStyles.w400s16red,
                  ),
            _getInputReasonView()
          ],
        );
      },
    );
  }

  Widget _getInputReasonView() {
    if (reason != widget.options.last) return emptyBox;
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: Colors.black54,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Other reason...',
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onChanged: (value) {
              otherReason = value;
              context
                  .read<FormDetailCubit>()
                  .addUnansweredReason(widget.question.key, value);
            },
          ),
        ),
      ],
    );
  }

  Widget _question() {
    String label = widget.question.label;
    if (widget.question.type == 'htmlelement') {
      return Html(data: widget.question.content);
    } else {
      if (label.startsWith('<')) {
        return Html(data: label);
      }
      bool required = widget.question.validate.required;
      return required ? RequiredText(label) : Text(label);
    }
  }
}

const List<String> unansweredOptions = [
  'Question not applicable to subject/patient.',
  'Subject/patient not willing to answer.',
  'Subject/patient unable to choose from available answer options.',
  'Subject/patient unable to comprehend/understand the question after repeated explanations.',
  'Data not available in medical records.',
  'Assessment not performed.',
  'Other.'
];

const List<String> changedQueryOptions = [
  'Data Missing',
  'Typographical error',
  'Wrong source used',
  'Confirmed correct (no error)',
  'Other'
];
