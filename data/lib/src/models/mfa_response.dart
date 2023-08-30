class MfaChallengeResponse {
  final String sessionId;
  final double expiredTime;

  MfaChallengeResponse(this.sessionId, this.expiredTime);

  factory MfaChallengeResponse.fromJson(Map<String, dynamic> json) {
    return MfaChallengeResponse(
      json['sessionId'],
      json['expiredTime'],
    );
  }
}
