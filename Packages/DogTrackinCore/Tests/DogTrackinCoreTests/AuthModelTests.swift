import Testing
@testable import DogTrackinCore

@MainActor
final class FakeAuthRepository: AuthRepository {
    private(set) var currentUser: User?
    private var observers: [@MainActor @Sendable (User?) -> Void] = []
    var loginResult: Result<User, AuthError> = .failure(.invalidCredentials)
    private(set) var lastLoginEmail: String?

    func observeUser(_ onChange: @escaping @MainActor @Sendable (User?) -> Void) {
        observers.append(onChange)
    }

    func emit(_ user: User?) {
        currentUser = user
        observers.forEach { $0(user) }
    }

    func login(email: String, password: String) async -> Result<User, AuthError> {
        lastLoginEmail = email
        if case .success(let user) = loginResult { emit(user) }
        return loginResult
    }

    func signUp(email: String, password: String) async -> Result<User, AuthError> {
        let user = User(id: "new", email: email)
        emit(user)
        return .success(user)
    }

    func loginWithApple() async -> Result<User, AuthError> { .failure(.unavailable("not yet")) }
    func loginWithGoogle() async -> Result<User, AuthError> { .failure(.unavailable("not yet")) }
    func signOut() { emit(nil) }
}

@MainActor
struct AuthModelTests {
    @Test func startsIdleAndSignedOut() {
        let model = AuthModel(repository: FakeAuthRepository())
        #expect(model.status == .idle)
        #expect(model.currentUser == nil)
    }

    @Test func successfulLoginSetsUser() async {
        let repo = FakeAuthRepository()
        let user = User(id: "1", email: "test@test.com", displayName: "Test")
        repo.loginResult = .success(user)
        let model = AuthModel(repository: repo)

        await model.login(email: "  test@test.com ", password: "password")

        #expect(model.status == .idle)
        #expect(model.currentUser == user)
        #expect(repo.lastLoginEmail == "test@test.com", "email is trimmed before sending")
    }

    @Test func failedLoginSurfacesTypedError() async {
        let repo = FakeAuthRepository()
        repo.loginResult = .failure(.invalidCredentials)
        let model = AuthModel(repository: repo)

        await model.login(email: "a@b.com", password: "wrong")

        #expect(model.status == .failed(.invalidCredentials))
        #expect(model.currentUser == nil)
    }

    @Test func clearErrorReturnsToIdle() async {
        let model = AuthModel(repository: FakeAuthRepository())
        await model.login(email: "a@b.com", password: "wrong")
        model.clearError()
        #expect(model.status == .idle)
    }

    @Test func externalSignOutIsObserved() async {
        let repo = FakeAuthRepository()
        repo.loginResult = .success(User(id: "1", email: "a@b.com"))
        let model = AuthModel(repository: repo)
        await model.login(email: "a@b.com", password: "pw")

        repo.signOut()

        #expect(model.currentUser == nil)
    }

    @Test func unconfiguredBackendExplainsItself() async {
        let model = AuthModel(repository: UnconfiguredAuthRepository(reason: "no config"))
        await model.login(email: "a@b.com", password: "pw")
        #expect(model.status == .failed(.unavailable("no config")))
    }

    @Test func userMessagesAreHumanReadable() {
        #expect(AuthError.network.userMessage.contains("Network"))
        #expect(AuthError.unknown(nil).userMessage == "Something went wrong. Please try again.")
    }
}
