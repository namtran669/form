import 'package:domain/domain.dart';

enum FormDataChangedType { unanswered, changeQuery }

class FormComponentWithQueries {
  final FormComponentResponse components;
  final List<FormQueryDetails> queries;

  FormComponentWithQueries(this.components, this.queries);
}

class FormDataChangedWithType {
  final List<DataChangedForm> questions;
  final FormDataChangedType type;

  FormDataChangedWithType(this.questions, this.type);
}
