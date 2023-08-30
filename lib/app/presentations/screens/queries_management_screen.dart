import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:talosix/app/blocs/form_queries/form_queries_cubit.dart';
import 'package:talosix/app/presentations/widgets/query_filter_status_view.dart';
import 'package:talosix/app/presentations/widgets/query_status_view.dart';

import '../../constants/app_colors.dart';
import '../../routes/routes.dart';
import '../../styles/app_styles.dart';
import '../../ui_model/form_query_status.dart';
import '../widgets/study_view.dart';

class QueriesManagementScreen extends StatelessWidget {
  QueriesManagementScreen({Key? key}) : super(key: key);
  final _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    List<FormQueryDetails> queries = [];
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      onRefresh: () {
        context.read<FormQueriesCubit>().refreshAssignedQueriesByRegistryId();
        _refreshController.refreshCompleted();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FittedBox(
                      child: Text(
                        Strings.tr.queryManagement,
                        style: AppTextStyles.w500s18blueDodger,
                      ),
                    ),
                    const Spacer(),
                    const StudyView(),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Your queries',
                  style: TextStyle(
                    color: AppColors.rhino.withOpacity(0.54),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 15),
                const QueryFilterStatusView(),
                const SizedBox(height: 15),
                Expanded(
                  child: BlocBuilder<FormQueriesCubit, FormQueriesState>(
                      builder: (context, state) {
                    if (state is FormQueriesAssignedLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is FormQueriesAssignedLoaded) {
                      queries
                        ..clear()
                        ..addAll(state.queries);
                    }
                    if (queries.isEmpty) {
                      return const Center(
                        child: Text('There is no query assigned to you now.'),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: queries.length,
                      itemBuilder: (context, index) =>
                          _QueryItem(query: queries[index]),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QueryItem extends StatelessWidget {
  final FormQueryDetails query;

  const _QueryItem({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FormQueryStatus status = FormQueryStatusExt.createFromString(query.status);
    query.question = Text(
      query.originalResponse,
      style: const TextStyle(fontStyle: FontStyle.italic),
    );
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        Routes.formQueryDetail,
        arguments: query,
      ),
      child: Card(
        elevation: 3,
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        QueryStatusView(
                          status: status,
                          verticalPadding: 5,
                          horizontalPadding: 20,
                          iconWidth: 14,
                          iconHeight: 14,
                          fontSize: 12,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '${query.assigneeId} - ${query.assignee}',
                            style: AppTextStyles.w500s15black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    query.question,
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(CupertinoIcons.question_square, size: 20),
                        const SizedBox(width: 5),
                        Text(
                          query.description,
                          style: AppTextStyles.w400s15black,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(
              child: Icon(
                Icons.arrow_forward_ios_outlined,
                size: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
