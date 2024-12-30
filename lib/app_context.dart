import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

abstract class UserContextStreamDelegate<TIdentity, TUser> {
  const UserContextStreamDelegate();
  Stream<TIdentity?> get identity;
  Stream<TUser?> user(TIdentity user);
  FutureOr<UserContext> context(TUser user);

  Stream<UserContext> get streamOf {
    final userStream = identity.map((u) => u != null ? user(u) : null);

    final contextStream = userStream.asyncMap((appUser) async => switch (
            appUser) {
          TUser appUser => await context(appUser),
          _ => UserContext.empty()
        });

    return contextStream;
  }
}

abstract class FirebaseUserContextStreamDelegate<TUser>
    extends UserContextStreamDelegate<User, TUser> {
  const FirebaseUserContextStreamDelegate({
    required this.firebaseAuth,
  });

  final FirebaseAuth firebaseAuth;
  @override
  Stream<User?> get identity => firebaseAuth.authStateChanges();
}

typedef IdentityToUser<TIdentity, TUser> = Stream<TUser?> Function(
    TIdentity user);
typedef UserToContext<TUser> = FutureOr<UserContext> Function(TUser user);

class DefaultFirebaseAppContextStreamDelegate<TUser>
    extends FirebaseUserContextStreamDelegate<TUser> {
  const DefaultFirebaseAppContextStreamDelegate({
    required super.firebaseAuth,
    required IdentityToUser<User, TUser> user,
    required UserToContext<TUser> context,
  })  : _user = user,
        _context = context;

  @override
  Stream<User?> get identity => firebaseAuth.authStateChanges();

  final IdentityToUser<User, TUser> _user;
  final UserToContext<TUser> _context;

  @override
  Stream<TUser?> user(User user) => _user(user);

  @override
  FutureOr<UserContext> context(user) => _context(user);
}

// abstract class FirebaseAppContextStreamConfigBase<T> {
//   const FirebaseAppContextStreamConfigBase({required this.firebaseAuth});
//   final FirebaseAuth firebaseAuth;
//   Stream<T?> user(User user);
//   FutureOr<AppContext> context(T user);
// }

// class FirebaseAppContextStreamConfig<T>
//     implements FirebaseAppContextStreamConfigBase {
//   const FirebaseAppContextStreamConfig(
//       {required this.firebaseAuth,
//       required Stream<T?> Function(User user) user,
//       required FutureOr<AppContext> Function(T user) context})
//       : _user = user,
//         _context = context;
//   @override
//   final FirebaseAuth firebaseAuth;

//   final Stream<T?> Function(User user) _user;
//   final FutureOr<AppContext> Function(T user) _context;

//   @override
//   Stream user(User user) => _user(user);

//   @override
//   FutureOr<AppContext> context(user) => _context(user);
// }

sealed class UserContext {
  const UserContext();

  factory UserContext.empty() => EmptyUserContext();
  factory UserContext.of(data) => CompleteUserContext(data);

  static Stream<UserContext> streamOf<TIdentity, TUser>(
      UserContextStreamDelegate<TIdentity, TUser> delegate) {
    final userStream = delegate.identity
        .map((user) => user != null ? delegate.user(user) : null);

    final contextStream = userStream.asyncMap((appUser) async => switch (
            appUser) {
          TUser appUser => await delegate.context(appUser),
          _ => UserContext.empty()
        });

    return contextStream;
  }

  // static Stream<AppContext> firebase<T>(
  //     FirebaseAppContextStreamConfigBase<T> config) {
  //   // Stream 1: When the authenticated user changes
  //   final authUserStream = config.firebaseAuth.authStateChanges();

  //   // Stream 2: Map the authenticated user to some store user
  //   final userStream =
  //       authUserStream.map((user) => user != null ? config.user(user) : null);

  //   // Stream 3: Map the store user to an [AppContext] using an optional mapper
  //   final contextStream = userStream.asyncMap((appUser) async => switch (
  //           appUser) {
  //         T appUser => await config.context(appUser),
  //         _ => AppContext.none()
  //       });

  //   return contextStream;
  // }

  // static Stream<AppContext> firebaseWith<T>({
  //   FirebaseAuth? firebaseAuth,
  //   required Stream<T?> Function(User user) user,
  //   FutureOr<AppContext> Function(T user)? context,
  // }) {
  //   final config = FirebaseAppContextStreamConfig(
  //       firebaseAuth: firebaseAuth ?? FirebaseAuth.instance,
  //       user: user,
  //       context: context ?? (T user) => AppContext.of(user));

  //   return firebase(config);
  // }
}

class EmptyUserContext implements UserContext {}

class CompleteUserContext<T> extends UserContext {
  const CompleteUserContext(this.data);
  final T data;
}
