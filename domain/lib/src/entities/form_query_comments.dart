class FormQueryComments {
  final int id;
  final String content;
  final String createdByUser;
  final String lastUpdated;
  final List<dynamic> attachments;

  FormQueryComments(
    this.id,
    this.content,
    this.createdByUser,
    this.lastUpdated,
    this.attachments,
  );
}
