import 'package:flutter/widgets.dart';

import '../../domain.dart';

class FormQueryDetails {
  final int id;
  final String status;
  final String createdByUser;
  final String assignee;
  final int assigneeId;
  final String description;
  late Widget question;
  final String lastUpdated;
  final String pageId;
  final String questionKey;
  final String originalResponse;
  final FormData? formData;

  FormQueryDetails(
    this.id,
    this.status,
    this.createdByUser,
    this.assignee,
    this.description,
    this.lastUpdated,
    this.pageId,
    this.questionKey,
    this.assigneeId,
    this.originalResponse,
    this.formData,
  );
}
