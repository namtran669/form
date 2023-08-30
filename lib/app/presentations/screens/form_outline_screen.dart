import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../styles/app_styles.dart';
import '../../constants/app_colors.dart';

class FormOutlineScreen extends StatefulWidget {
  const FormOutlineScreen({Key? key}) : super(key: key);

  @override
  State<FormOutlineScreen> createState() => _FormOutlineScreenState();
}

class _FormOutlineScreenState extends State<FormOutlineScreen> {
  FocusNode tfNode = FocusNode();
  String hint = 'Type page number to go there.';

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as FormOutlineData;
    int? page;
    final keyTf = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          data.formName,
          style: AppTextStyles.w500s16black,
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: AppColors.background,
      ),
      body: Form(
        key: keyTf,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const SizedBox(height: 8),
                TextFormField(
                  focusNode: tfNode,
                  style: AppTextStyles.w400s16black,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: AppTextFieldStyle.borderNormal,
                    hintText: 'Type page number to go there.',
                    suffixIcon: GestureDetector(
                      child: const Icon(CupertinoIcons.arrow_right_circle),
                      onTap: () {
                        if (keyTf.currentState?.validate() ?? false) {
                          Navigator.of(context).pop(page);
                        }
                      },
                    ),
                    focusedBorder: AppTextFieldStyle.borderFocused,
                    errorBorder: AppTextFieldStyle.borderError,
                  ),
                  onChanged: (value) => page = int.parse(value),
                  validator: (value) {
                    if (page! < 0 || page! > data.outlines.length) {
                      return 'Please input a valid page number';
                    }
                  },
                ),
                const SizedBox(height: 20),
                const Text('Form Pages', style: AppTextStyles.w500s18black),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      int displayIndex = index + 1;
                      return GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 15),
                            child: Row(
                              children: [
                                Text(
                                  '$displayIndex . ${data.outlines[index].title.toUpperCase()}',
                                  style: AppTextStyles.w400s18black,
                                ),
                                const Spacer(),
                                const Icon(CupertinoIcons.arrow_right_circle),
                              ],
                            ),
                          ),
                          onTap: () => Navigator.of(context).pop(displayIndex));
                    },
                    itemCount: data.outlines.length,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FormOutlineData {
  final String formName;
  final List<FormOutline> outlines;

  FormOutlineData(this.formName, this.outlines);
}

class FormOutline {
  final String title;

  FormOutline(this.title);
}
