/// Typed authentication failures, so callers react to *why* something failed
/// (offer retry on `.network`, prompt re-entry on `.invalidCredentials`, …)
/// instead of parsing message strings.
public enum AuthError: Error, Equatable, Sendable {
    /// No or failed connectivity reaching the backend — safe to offer a retry.
    case network
    /// Wrong email/password, malformed credentials, or a disabled login.
    case invalidCredentials
    /// Sign-up attempted with an email that already has an account.
    case emailAlreadyInUse
    /// No account exists for the supplied identifier.
    case userNotFound
    /// The sign-in method isn't available in this build (e.g. not wired up yet, or no Firebase config).
    case unavailable(String)
    /// Anything not otherwise classified; keeps the original message for logs.
    case unknown(String?)

    /// User-facing message. (Move to a String Catalog when localizing.)
    public var userMessage: String {
        switch self {
        case .network: "Network error. Check your connection and try again."
        case .invalidCredentials: "Incorrect email or password."
        case .emailAlreadyInUse: "That email is already registered."
        case .userNotFound: "No account found for that email."
        case .unavailable(let reason): reason
        case .unknown(let message): message ?? "Something went wrong. Please try again."
        }
    }
}
