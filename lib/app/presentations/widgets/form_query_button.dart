import 'package:domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/form_queries/form_queries_cubit.dart';
import '../../constants/app_images.dart';
import '../../routes/routes.dart';
import '../../ui_model/form_query_status.dart';
import 'common_view.dart';

class FormQueryButton extends StatelessWidget {
  FormQueryButton({
    Key? key,
    required this.question,
    this.queryKey,
  }) : super(key: key);

  final String? queryKey;
  final Widget question;
  final List<FormQueryDetails> queries = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormQueriesCubit, FormQueriesState>(
      builder: (context, state) {
        if (state is FormQueriesLoaded) {
          queries
            ..clear()
            ..addAll(state.queries);
        } else if (state is FormQueriesExisted) {
          return _getQueriesOfQuestion(context, state.queries);
        }
        return _getQueriesOfQuestion(context, queries);
      },
    );
  }

  Widget _getQueriesOfQuestion(
    BuildContext context,
    List<FormQueryDetails> queries,
  ) {
    for (var query in queries) {
      if (isFormQuery(query) || isPageOrQuestionQuery(query, queryKey)) {
        return _queryIcon(context, query);
      }
    }
    return emptyBox;
  }

  bool isFormQuery(FormQueryDetails query) {
    return queryKey == null &&
        query.questionKey.isEmpty &&
        query.pageId.isEmpty;
  }

  bool isPageOrQuestionQuery(FormQueryDetails query, String? key) {
    if (key == null) return false;
    return query.pageId == key || query.questionKey == key;
  }

  Widget _queryIcon(BuildContext context, FormQueryDetails query) {
    var status = FormQueryStatusExt.createFromString(query.status);
    query.question = question;
    String icon;
    switch (status) {
      case FormQueryStatus.open:
        icon = AppIcons.formQueryOpen;
        break;
      case FormQueryStatus.approved:
        icon = AppIcons.formQueryApproved;
        break;
      case FormQueryStatus.rejected:
        icon = AppIcons.formQueryRejected;
        break;
    }
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        Routes.formQueryDetail,
        arguments: query,
      ),
      child: Image.asset(
        icon,
        width: 20,
        height: 20,
      ),
    );
  }
}
