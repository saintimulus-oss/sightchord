enum AccountAvailability { unknown, available, unconfigured, error }

class AppAccountUser {
  const AppAccountUser({
    required this.id,
    this.email,
    this.emailVerified = false,
  });

  final String id;
  final String? email;
  final bool emailVerified;

  String get displayLabel {
    final resolvedEmail = email?.trim();
    if (resolvedEmail != null && resolvedEmail.isNotEmpty) {
      return resolvedEmail;
    }
    return id;
  }
}

enum AccountMessageCode {
  signedIn,
  signedUp,
  signedOut,
  deleted,
  passwordResetSent,
  invalidCredentials,
  emailInUse,
  weakPassword,
  userNotFound,
  tooManyRequests,
  networkError,
  authUnavailable,
  deleteRequiresRecentLogin,
  dataDeletionFailed,
  unknownError,
}

class AccountState {
  const AccountState({
    this.availability = AccountAvailability.unknown,
    this.currentUser,
    this.isBusy = false,
    this.messageCode,
  });

  final AccountAvailability availability;
  final AppAccountUser? currentUser;
  final bool isBusy;
  final AccountMessageCode? messageCode;

  bool get isConfigured => availability == AccountAvailability.available;
  bool get isSignedIn => currentUser != null;

  AccountState copyWith({
    AccountAvailability? availability,
    Object? currentUser = _accountStateSentinel,
    bool? isBusy,
    Object? messageCode = _accountStateSentinel,
  }) {
    return AccountState(
      availability: availability ?? this.availability,
      currentUser: identical(currentUser, _accountStateSentinel)
          ? this.currentUser
          : currentUser as AppAccountUser?,
      isBusy: isBusy ?? this.isBusy,
      messageCode: identical(messageCode, _accountStateSentinel)
          ? this.messageCode
          : messageCode as AccountMessageCode?,
    );
  }
}

const Object _accountStateSentinel = Object();
