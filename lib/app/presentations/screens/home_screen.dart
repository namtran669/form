import 'dart:io';

import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:talosix/app/blocs/chat/chat_cubit.dart';
import 'package:talosix/app/blocs/form_counter/form_counter_cubit.dart';
import 'package:talosix/app/blocs/form_incomplete/form_incomplete_bloc.dart';
import 'package:talosix/app/blocs/study_patient/study_cubit.dart';
import 'package:talosix/app/blocs/treatment/treatment_bloc.dart';
import 'package:talosix/app/blocs/user/user_profile_cubit.dart';
import 'package:talosix/app/extensions/context_ext.dart';
import 'package:talosix/app/presentations/widgets/custom_app_dialog.dart';
import 'package:talosix/app/presentations/widgets/study_view.dart';
import 'package:talosix/app/styles/app_styles.dart';

import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/form_queries/form_queries_cubit.dart';
import '../../blocs/form_question/form_detail_cubit.dart';
import '../../constants/app_colors.dart';
import '../../routes/routes.dart';
import '../../ui_model/transfer_custom_data_model.dart';
import 'form_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _refreshController = RefreshController(initialRefresh: false);
  late Study curStudy;

  @override
  void initState() {
    super.initState();
    context.read<StudyCubit>().fetchStudies();
    _registerNotification();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      onRefresh: _fetchData,
      child: BlocListener<StudyCubit, StudyState>(
        listener: (context, state) {
          if (state is StudySelected) {
            curStudy = state.study;
            _fetchData();
          }
        },
        child: BlocListener<FormDetailCubit, FormDetailState>(
          listener: (context, state) {
            if (state is FormDetailSuccessForHomeScreen) {
              var data = FormComponentWithQueries(state.component, []);
              Navigator.of(context).pushNamed(
                Routes.formDetail,
                arguments: data,
              );
            } else if (state is FormDetailError) {
              context.showMessage(ToastMessageType.error, state.msg);
            }
          },
          child: SafeArea(
            child: Container(
              width: double.infinity,
              color: AppColors.background,
              padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          BlocConsumer<AppUserProfileCubit,
                              AppUserProfileState>(builder: (context, state) {
                            String firstName = '';
                            if (state is UserFetchProfileSuccess) {
                              firstName = state.firstName;
                            }
                            return Text(
                              'Hello, ${firstName.split(' ').first}!',
                              style: AppTextStyles.w500s20dodgerBlue,
                            );
                          }, listener: (context, state) {
                            if (state is UserInvalidRole) {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => AppCustomDialog(
                                  parentContext: context,
                                  title: 'Warning',
                                  message: Strings.tr.invalidAccountPermission,
                                  actionTitle: 'Got It',
                                  onAction: () =>
                                      context.read<AuthCubit>().logout(),
                                  dismissTitle: '',
                                  onDismiss: () {},
                                ),
                              );
                            } else if (state is UserFetchProfileError) {
                              context.showMessage(
                                ToastMessageType.error,
                                'Can\'t get account information, please logout and login again.',
                              );
                            }
                          }),
                          const Spacer(),
                          const StudyView(),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Have a nice day.',
                        style: AppTextStyles.w400s16rhino.copyWith(
                          color: AppColors.rhino.withOpacity(0.54),
                        ),
                      ),
                    ],
                  ),
                  const _WeeklyReview(),
                  const SizedBox(height: 20),
                  const Expanded(
                    flex: 5,
                    child: _IncompleteFormList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _fetchData() {
    context.read<PatientTreatmentBloc>().add(PatientUpdateStudy(curStudy));
    context.read<HomeBloc>().add(HomeUpdateStudy(curStudy));
    context.read<FormCounterCubit>().countFormStatus(curStudy.registryId);
    context.read<FormQueriesCubit>().fetchAssignedQueriesByRegistryId(curStudy.registryId);
    _refreshController.refreshCompleted();

  }

  _registerNotification() {
    FirebaseMessaging.instance
        .requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    ).then((settings) {
      bool isAuthorized =
          settings.authorizationStatus == AuthorizationStatus.authorized;
      if(isAuthorized) {
        FirebaseMessaging.instance.getToken().then((token) {
          String platform = Platform.isAndroid ? 'Android': 'iOS';
          context.read<AuthCubit>().updateFcmToken(token, platform);
        });

        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          if (message.notification != null) {
            String title = message.notification!.title!;
            String body = message.notification!.body!;
            showSimpleNotification(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(
                          Icons.notifications,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'New Notification',
                          style: AppTextStyles.w500s16white,
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                     Text(title, style: AppTextStyles.w600s16black),
                    const SizedBox(height: 3),
                     Text(body, style: AppTextStyles.w400s16white),
                  ],
                ),
                duration: const Duration(seconds: 4));
          }
        });
      }
    });
  }
}

class _IncompleteFormList extends StatelessWidget {
  const _IncompleteFormList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Incomplete Forms',
          style: AppTextStyles.w600s18midnightBlue,
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Center(
            child: BlocConsumer<HomeBloc, HomeState>(builder: (context, state) {
              if (state is FormIncompleteFetching) {
                return const CircularProgressIndicator();
              } else if (state is FormIncompleteFetched) {
                if (state.forms.isEmpty) {
                  return const Text('Your study forms are all complete!');
                }
                return ListView.builder(
                  itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        context.read<FormDetailCubit>().fetchForm(
                              state.forms[index].id,
                              isFromHomeScreen: true,
                            );
                      },
                      child: FormDataItem(formData: state.forms[index])),
                  itemCount: state.forms.length,
                );
              }
              return const Text('Your study forms are all complete!');
            }, listener: (context, state) {
              if (state is FormIncompleteFetchFail) {
                context.showMessage(ToastMessageType.error, state.error);
              }
            }),
          ),
        ),
      ],
    );
  }
}

class _WeeklyReview extends StatelessWidget {
  const _WeeklyReview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text('Summary', style: AppTextStyles.w600s18midnightBlue),
        const SizedBox(height: 15),
        BlocBuilder<FormCounterCubit, FormCounterState>(
          builder: (context, state) {
            int completed = 0, incomplete = 0;
            if (state is FormStatusCounted) {
              completed = state.completed;
              incomplete = state.incomplete;
            }
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1.0,
                  color: AppColors.hippieBlue.withOpacity(0.25),
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _WeeklyReviewItem(
                      title: 'Completed forms',
                      quantity: completed.toString(),
                    ),
                  ),
                  Container(
                    height: 75,
                    width: 1,
                    color: AppColors.hippieBlue.withOpacity(0.25),
                  ),
                  Expanded(
                    child: _WeeklyReviewItem(
                      title: 'Incomplete forms',
                      quantity: incomplete.toString(),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _WeeklyReviewItem extends StatelessWidget {
  const _WeeklyReviewItem({
    Key? key,
    required this.title,
    required this.quantity,
  }) : super(key: key);

  final String title, quantity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            quantity,
            style: AppTextStyles.w700s24black,
          ),
          Text(
            title,
            style: AppTextStyles.w500s14neptune,
          ),
        ],
      ),
    );
  }
}
