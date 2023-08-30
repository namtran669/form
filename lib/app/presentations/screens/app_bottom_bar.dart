import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talosix/app/presentations/screens/home_screen.dart';
import 'package:talosix/app/presentations/screens/patient_treatment_screen.dart';
import 'package:talosix/app/presentations/screens/profile_screen.dart';
import 'package:talosix/app/presentations/screens/queries_management_screen.dart';

import '../../blocs/app_bottom_bar/app_bottom_bar_bloc.dart';
import '../../styles/sizes.dart';
import 'chat_list_screen.dart';
import '../widgets/custom_bottom_navigation_bar.dart';

class AppBottomBarScreen extends StatelessWidget {
  const AppBottomBarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BottomBar();
  }
}

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with TickerProviderStateMixin {
  List<Widget> pages = <Widget>[
    const Center(child: HomeScreen()),
    const Center(child: PatientTreatmentsScreen()),
    Center(child: QueriesManagementScreen()),
    const Center(child: ChatListScreen()),
    const Center(child: ProfileScreen()),
  ];

  late List<Key> destinationKeys;
  late List<AnimationController> faders;
  late AnimationController hideBottomBar;

  @override
  void initState() {
    super.initState();
    faders = List<AnimationController>.generate(
      pages.length,
      (_) => AnimationController(
        vsync: this,
        duration: kThemeAnimationDuration,
      ),
    );
    faders[context.read<AppBottomBarBloc>().state.index].value = 1.0;
    destinationKeys = List<Key>.generate(
      pages.length,
      (int index) => GlobalKey(),
    ).toList();
    hideBottomBar = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
    );
    SchedulerBinding.instance.addPostFrameCallback((_) {
      hideBottomBar.forward();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Sizes.init(
      BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      designSize: const Size(750, 1450),
    );
  }

  @override
  void dispose() {
    for (AnimationController controller in faders) {
      controller.dispose();
    }
    hideBottomBar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<AppBottomBarBloc>().state;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: List<Widget>.generate(pages.length, (int index) {
          final Widget view = FadeTransition(
            opacity: faders[index].drive(CurveTween(curve: Curves.fastOutSlowIn)),
            child: KeyedSubtree(
              key: destinationKeys[index],
              child: pages[index],
            ),
          );
          if (index == currentIndex.index) {
            faders[index].forward();
            return view;
          } else {
            faders[index].reverse();
            if (faders[index].isAnimating) {
              return IgnorePointer(child: view);
            }
            return Offstage(child: view);
          }
        }).toList(),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
