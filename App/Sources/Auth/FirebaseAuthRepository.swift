import Foundation
import FirebaseAuth
import DogTrackinCore

/// Firebase-backed `AuthRepository`. Email/password is live; Apple and Google
/// sign-in are wired in phase P1 (see docs/implementation-plan.md, ADR-6).
@MainActor
final class FirebaseAuthRepository: AuthRepository {
    private let auth: Auth
    private var listenerHandles: [any NSObjectProtocol] = []

    init(auth: Auth = Auth.auth()) {
        self.auth = auth
    }

    var currentUser: DogTrackinCore.User? {
        auth.currentUser.map(Self.domainUser)
    }

    func observeUser(_ onChange: @escaping @MainActor @Sendable (DogTrackinCore.User?) -> Void) {
        let handle = auth.addStateDidChangeListener { _, firebaseUser in
            // Firebase calls this on the main thread. Map to a Sendable value first.
            let user = firebaseUser.map(Self.domainUser)
            MainActor.assumeIsolated { onChange(user) }
        }
        listenerHandles.append(handle)
    }

    func login(email: String, password: String) async -> Result<DogTrackinCore.User, DogTrackinCore.AuthError> {
        await withCheckedContinuation { continuation in
            auth.signIn(withEmail: email, password: password) { result, error in
                continuation.resume(returning: Self.map(result: result, error: error))
            }
        }
    }

    func signUp(email: String, password: String) async -> Result<DogTrackinCore.User, DogTrackinCore.AuthError> {
        await withCheckedContinuation { continuation in
            auth.createUser(withEmail: email, password: password) { result, error in
                continuation.resume(returning: Self.map(result: result, error: error))
            }
        }
    }

    func loginWithApple() async -> Result<DogTrackinCore.User, DogTrackinCore.AuthError> {
        .failure(.unavailable("Sign in with Apple is coming soon."))
    }

    func loginWithGoogle() async -> Result<DogTrackinCore.User, DogTrackinCore.AuthError> {
        .failure(.unavailable("Sign in with Google is coming soon."))
    }

    func signOut() {
        try? auth.signOut()
    }

    // MARK: - Mapping

    private nonisolated static func domainUser(_ user: FirebaseAuth.User) -> DogTrackinCore.User {
        DogTrackinCore.User(id: user.uid, email: user.email ?? "", displayName: user.displayName)
    }

    private nonisolated static func map(result: AuthDataResult?, error: Error?) -> Result<DogTrackinCore.User, DogTrackinCore.AuthError> {
        if let error { return .failure(authError(from: error)) }
        guard let user = result?.user else { return .failure(.unknown("No user returned")) }
        return .success(domainUser(user))
    }

    private nonisolated static func authError(from error: Error) -> DogTrackinCore.AuthError {
        let nsError = error as NSError
        if nsError.domain == NSURLErrorDomain { return .network }
        guard let code = AuthErrorCode(rawValue: nsError.code) else {
            return .unknown(nsError.localizedDescription)
        }
        switch code {
        case .networkError: return .network
        case .wrongPassword, .invalidCredential, .invalidEmail, .userDisabled: return .invalidCredentials
        case .userNotFound: return .userNotFound
        case .emailAlreadyInUse: return .emailAlreadyInUse
        default: return .unknown(nsError.localizedDescription)
        }
    }
}
