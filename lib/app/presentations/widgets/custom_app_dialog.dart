import 'package:flutter/material.dart';
import 'package:talosix/app/styles/app_styles.dart';
import 'package:talosix/app/presentations/widgets/common_view.dart';

class AppCustomDialog extends StatefulWidget {
  const AppCustomDialog({
    Key? key,
    required this.parentContext,
    required this.title,
    required this.message,
    required this.actionTitle,
    required this.dismissTitle,
    required this.onAction,
    required this.onDismiss,
  }) : super(key: key);

  final String title, message, actionTitle, dismissTitle;
  final VoidCallback onAction, onDismiss;
  final BuildContext parentContext;

  @override
  State<AppCustomDialog> createState() => _AppCustomDialogState();
}

class _AppCustomDialogState extends State<AppCustomDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              DefaultTextStyle(
                style: AppTextStyles.w500s22black,
                child: Text(widget.title),
              ),
              const SizedBox(height: 40),
              DefaultTextStyle(
                style: AppTextStyles.w400s16grey.copyWith(height: 1.5),
                child: Text(widget.message, textAlign: TextAlign.center),
              ),
              SizedBox(height: widget.message.length > 80 ? 120 : 65),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: AppButtonStyles.r40blueDodger,
                  onPressed: () {
                    widget.onAction.call();
                    Navigator.of(widget.parentContext).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      widget.actionTitle,
                      style: AppTextStyles.w500s16white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              _enableNegativeButton()
                  ? TextButton(
                      onPressed: () {
                        widget.onDismiss.call();
                        Navigator.of(widget.parentContext).pop();
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          widget.dismissTitle,
                          style: AppTextStyles.w500s16dodgerBlue,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : emptyBox,
            ],
          ),
        ),
      ),
    );
  }

  _enableNegativeButton() {
    return widget.dismissTitle.isNotEmpty;
  }
}
