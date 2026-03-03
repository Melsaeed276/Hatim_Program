class AuthUserProfile {
  const AuthUserProfile({
    required this.uid,
    required this.name,
    required this.authProviders,
    this.phoneNumber,
    this.referenceCode,
    this.passwordEnabled = false,
    this.passwordHash,
  });

  final String uid;
  final String name;
  final String? phoneNumber;
  final String? referenceCode;
  final List<String> authProviders;
  final bool passwordEnabled;
  final String? passwordHash;

  bool get hasPassword =>
      passwordEnabled && (passwordHash?.isNotEmpty ?? false);

  bool hasProvider(String provider) => authProviders.contains(provider);

  AuthUserProfile copyWith({
    String? uid,
    String? name,
    String? phoneNumber,
    String? referenceCode,
    List<String>? authProviders,
    bool? passwordEnabled,
    String? passwordHash,
  }) {
    return AuthUserProfile(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      referenceCode: referenceCode ?? this.referenceCode,
      authProviders: authProviders ?? this.authProviders,
      passwordEnabled: passwordEnabled ?? this.passwordEnabled,
      passwordHash: passwordHash ?? this.passwordHash,
    );
  }

  Map<String, dynamic> toMap({required DateTime now}) {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'phoneNumber': phoneNumber,
      'referenceCode': referenceCode,
      'authProviders': authProviders,
      'passwordEnabled': passwordEnabled,
      'passwordHash': passwordHash,
      'updatedAt': now.toIso8601String(),
    };
  }

  factory AuthUserProfile.fromMap(Map<String, dynamic> map) {
    return AuthUserProfile(
      uid: map['uid'] as String,
      name: map['name'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String?,
      referenceCode: map['referenceCode'] as String?,
      authProviders: List<String>.from(
        (map['authProviders'] as List<dynamic>? ?? <dynamic>[]),
      ),
      passwordEnabled: map['passwordEnabled'] as bool? ?? false,
      passwordHash: map['passwordHash'] as String?,
    );
  }
}
