import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:talosix/app/styles/app_styles.dart';
import 'package:talosix/app/extensions/context_ext.dart';
import 'package:talosix/app/presentations/widgets/custom_webview.dart';
import 'package:talosix/di/locator.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../constants/app_colors.dart';
import '../../routes/routes.dart';
import '../widgets/common_view.dart';

class TermAndConditionScreen extends StatefulWidget {
  const TermAndConditionScreen({Key? key}) : super(key: key);

  @override
  State<TermAndConditionScreen> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<TermAndConditionScreen> {
  bool isAgree = false;
  var loadingPercentage = 0;

  @override
  void initState() {
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomWebView(url: locator<AppConfig>().termAndCondition),
            _isPageLoaded()
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                            value: isAgree,
                            onChanged: (value) {
                              setState(() {
                                isAgree = value!;
                              });
                            }),
                        const SizedBox(width: 3),
                        const Text(
                          'I agree to the information shown to me above.',
                        )
                      ],
                    ),
                  )
                : emptyBox
          ],
        ),
      ),
      bottomNavigationBar: _isPageLoaded()
          ? Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isAgree) {
                          Navigator.of(context).pushNamed(Routes.mfaSelectType);
                        } else {
                          context.showMessage(
                            ToastMessageType.error,
                            'Please read and accept the Term and Condition before continue',
                          );
                        }
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          isAgree ? AppColors.blueDodger : AppColors.bombay,
                        ),
                      ),
                      child: const Text(
                        'I Accept',
                        style: AppTextStyles.w700s18white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Flexible(
                    child: Text(
                      'Before you can continue, you must read and accept the Talosix Terms & Conditions.',
                      style: AppTextStyles.w400s10grey,
                    ),
                  ),
                ],
              ),
            )
          : emptyBox,
    );
  }

  bool _isPageLoaded() {
    return loadingPercentage == 100;
  }
}
