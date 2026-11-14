/// Authentication backend abstraction. The app provides a Firebase implementation;
/// tests and previews use fakes. Main-actor isolated because every caller is UI-driven.
@MainActor
public protocol AuthRepository: AnyObject {
    /// The user signed in right now, if any.
    var currentUser: User? { get }

    /// Registers a callback for sign-in / sign-out changes. Called on the main actor.
    func observeUser(_ onChange: @escaping @MainActor @Sendable (User?) -> Void)

    func login(email: String, password: String) async -> Result<User, AuthError>
    func signUp(email: String, password: String) async -> Result<User, AuthError>
    func loginWithApple() async -> Result<User, AuthError>
    func loginWithGoogle() async -> Result<User, AuthError>
    func signOut()
}

/// Used when the backend isn't configured (e.g. no GoogleService-Info.plist in a fresh clone)
/// and in previews. Every sign-in fails with a clear `.unavailable` message.
@MainActor
public final class UnconfiguredAuthRepository: AuthRepository {
    private let reason: String

    public init(reason: String = "Firebase isn't configured in this build. Add GoogleService-Info.plist (see docs/ios-firebase-setup.md).") {
        self.reason = reason
    }

    public var currentUser: User? { nil }
    public func observeUser(_ onChange: @escaping @MainActor @Sendable (User?) -> Void) {}
    public func login(email: String, password: String) async -> Result<User, AuthError> { .failure(.unavailable(reason)) }
    public func signUp(email: String, password: String) async -> Result<User, AuthError> { .failure(.unavailable(reason)) }
    public func loginWithApple() async -> Result<User, AuthError> { .failure(.unavailable(reason)) }
    public func loginWithGoogle() async -> Result<User, AuthError> { .failure(.unavailable(reason)) }
    public func signOut() {}
}
