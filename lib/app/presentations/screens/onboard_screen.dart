import 'package:flutter/material.dart';
import 'package:talosix/app/styles/app_styles.dart';
import 'package:talosix/app/constants/app_images.dart';
import 'package:talosix/app/routes/routes.dart';

import '../../constants/app_colors.dart';

class OnboardScreen extends StatefulWidget {
  OnboardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();

  final onboardData = [
    _OnboardData(
      AppImages.onboard1,
      'Manage your patient reported outcomes',
      'Sign in with your Talosix account to view your patients and track study status',
    ),
    _OnboardData(
      AppImages.onboard2,
      'Easily capture patient data from your phone',
      'Capture PRO data right from your phone',
    ),
    _OnboardData(
      AppImages.onboard3,
      'Safe & Secure',
      'Rest easy knowing your data is save and secure',
    ),
  ];
}

class _OnboardScreenState extends State<OnboardScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String btnTitle = _isOnLastPage() ? 'Get Started' : 'Next';
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => _goToLogin(),
                child: const Text('Skip', style: AppTextStyles.w500s16dodgerBlue),
              ),
              Expanded(
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: widget.onboardData.length,
                  itemBuilder: (ctx, i) =>
                      _OnboardItem(data: widget.onboardData[i]),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          _isOnLastPage() ? _goToLogin() : _goToNextPage();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                        ),
                        child: Center(
                          child: Text(
                            btnTitle,
                            style: AppTextStyles.w500s16white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int i = 0; i < widget.onboardData.length; i++)
                        _OnboardIndicator(i == _currentPage)
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _goToNextPage() {
    _currentPage++;
    _pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  _goToLogin() {
    Navigator.of(context).pushReplacementNamed(Routes.login);
  }

  bool _isOnLastPage() {
    return _currentPage == widget.onboardData.length - 1;
  }
}

class _OnboardItem extends StatelessWidget {
  const _OnboardItem({Key? key, required this.data}) : super(key: key);

  final _OnboardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Expanded(
              flex: 2,
              child: Image.asset(data.image)),
          const SizedBox(height: 50),
          Expanded(
            flex:  3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    data.title,
                    style: AppTextStyles.w400s24black,
                  ),
                ),
                const SizedBox(height: 30),
                Flexible(
                  child: Text(
                    data.description,
                    style: AppTextStyles.w400s16black,
                  ),
                ),
                const Spacer()
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _OnboardIndicator extends StatelessWidget {
  final bool isActive;

  const _OnboardIndicator(this.isActive);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 3.3),
      height: 15,
      width: 15,
      decoration: BoxDecoration(
        color: isActive ? AppColors.dodgerBlue : Colors.grey,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}

class _OnboardData {
  final String image;
  final String title;
  final String description;

  _OnboardData(this.image, this.title, this.description);
}
