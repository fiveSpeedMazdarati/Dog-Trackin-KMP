/// A signed-in person. Every person has their own account (spec FR-A1).
public struct User: Equatable, Sendable, Identifiable {
    public let id: String
    public let email: String
    public let displayName: String?

    public init(id: String, email: String, displayName: String? = nil) {
        self.id = id
        self.email = email
        self.displayName = displayName
    }
}
