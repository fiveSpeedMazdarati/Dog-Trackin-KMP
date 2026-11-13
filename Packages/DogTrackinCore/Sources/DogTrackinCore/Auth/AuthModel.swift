import Observation

/// Observable state for sign-in screens. Successor to the old Kotlin `AuthViewModel`.
@MainActor
@Observable
public final class AuthModel {
    public enum Status: Equatable, Sendable {
        case idle
        case loading
        case failed(AuthError)
    }

    public private(set) var status: Status = .idle
    public private(set) var currentUser: User?

    private let repository: any AuthRepository

    public init(repository: any AuthRepository) {
        self.repository = repository
        self.currentUser = repository.currentUser
        repository.observeUser { [weak self] user in
            self?.currentUser = user
        }
    }

    public var isLoading: Bool { status == .loading }

    public func login(email: String, password: String) async {
        await run { try await self.repository.login(email: email.trimmed, password: password).get() }
    }

    public func signUp(email: String, password: String) async {
        await run { try await self.repository.signUp(email: email.trimmed, password: password).get() }
    }

    public func loginWithApple() async {
        await run { try await self.repository.loginWithApple().get() }
    }

    public func loginWithGoogle() async {
        await run { try await self.repository.loginWithGoogle().get() }
    }

    public func signOut() {
        repository.signOut()
        status = .idle
    }

    public func clearError() {
        status = .idle
    }

    private func run(_ operation: () async throws -> User) async {
        status = .loading
        do {
            currentUser = try await operation()
            status = .idle
        } catch let error as AuthError {
            status = .failed(error)
        } catch {
            status = .failed(.unknown(String(describing: error)))
        }
    }
}

private extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}
