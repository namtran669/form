part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<QueryDocumentSnapshot<Object?>> docs;

  const ChatLoaded({required this.docs});

  @override
  List<Object?> get props => [docs];
}

class ChatError extends ChatState {}

class ChatAuthLoggedIn extends ChatState {}

class ChatAuthLoggedOut extends ChatState {}

class ChatImageDownloadLoading extends ChatState {}

class ChatImageDownloadLoaded extends ChatState {
  final Map<String, String> mapImageUrls;
  const ChatImageDownloadLoaded(this.mapImageUrls);
}

class ChatImageDownloadError extends ChatState {}

class ChatAvatarUploading extends ChatState {}

class ChatAvatarLoading extends ChatState {}

class ChatAvatarNotAvailable extends ChatState {}

class ChatAvatarLoaded extends ChatState {
  final String avatarLink;
  const ChatAvatarLoaded(this.avatarLink);
}

