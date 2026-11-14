import SwiftUI
import DesignSystem
import DogTrackinCore

struct LoginView: View {
    @Environment(AuthModel.self) private var auth
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false

    private var canSubmit: Bool { !email.isEmpty && !password.isEmpty && !auth.isLoading }

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: DTSpacing.xl) {
                    header

                    VStack(spacing: DTSpacing.m) {
                        TextField("Email", text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .modifier(FieldStyle())
                        SecureField("Password", text: $password)
                            .textContentType(isSignUp ? .newPassword : .password)
                            .modifier(FieldStyle())
                    }

                    if case .failed(let error) = auth.status {
                        BannerView(kind: .warning, title: "Couldn't sign in", message: error.userMessage, onDismiss: { auth.clearError() })
                            .clipShape(RoundedRectangle(cornerRadius: DTRadius.medium, style: .continuous))
                    }

                    Button {
                        Task {
                            if isSignUp {
                                await auth.signUp(email: email, password: password)
                            } else {
                                await auth.login(email: email, password: password)
                            }
                        }
                    } label: {
                        if auth.isLoading {
                            ProgressView().tint(DTColor.onAccent)
                        } else {
                            Text(isSignUp ? "Create account" : "Sign in")
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(!canSubmit)

                    Button(isSignUp ? "Already have an account? Sign in" : "New here? Create an account") {
                        isSignUp.toggle()
                        auth.clearError()
                    }
                    .font(DTFont.subheadline)
                    .foregroundStyle(DTColor.onBackground)
                    .frame(maxWidth: .infinity)

                    divider

                    // P1: replace with SignInWithAppleButton (AuthenticationServices) and the Google SDK button.
                    VStack(spacing: DTSpacing.m) {
                        Button("Continue with Apple") { Task { await auth.loginWithApple() } }
                            .buttonStyle(SecondaryButtonStyle())
                        Button("Continue with Google") { Task { await auth.loginWithGoogle() } }
                            .buttonStyle(SecondaryButtonStyle())
                    }
                    .disabled(auth.isLoading)
                }
                .padding(DTSpacing.l)
                .frame(maxWidth: 480)
                // iPad (regular width): centre the form vertically instead of leaving
                // the lower part of the screen empty. iPhone stays top-aligned.
                .frame(
                    maxWidth: .infinity,
                    minHeight: isRegularWidth ? proxy.size.height : nil,
                    alignment: isRegularWidth ? .center : .top
                )
            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .background(DTColor.background)
    }

    private var isRegularWidth: Bool { horizontalSizeClass == .regular }

    private var header: some View {
        VStack(alignment: .leading, spacing: DTSpacing.s) {
            Glyph.animal.image
                .font(DTFont.title1)
                .foregroundStyle(DTColor.onAccent)
                .frame(width: 64, height: 64)
                .background(DTColor.accentPrimary, in: RoundedRectangle(cornerRadius: DTRadius.large, style: .continuous))
            Text("Dog Trackin'").font(DTFont.display).foregroundStyle(DTColor.onBackground)
            Text("Everyone who loves your dog, on the same page.")
                .font(DTFont.body)
                .foregroundStyle(DTColor.textSecondary)
        }
        .padding(.top, isRegularWidth ? 0 : DTSpacing.xxl)
    }

    private var divider: some View {
        HStack(spacing: DTSpacing.m) {
            Rectangle().fill(DTColor.divider).frame(height: 1)
            Text("or").font(DTFont.footnote).foregroundStyle(DTColor.textSecondary)
            Rectangle().fill(DTColor.divider).frame(height: 1)
        }
    }
}

private struct FieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(DTFont.body)
            .padding(.horizontal, DTSpacing.l)
            .frame(minHeight: DTSize.buttonHeight)
            .overlay(
                RoundedRectangle(cornerRadius: DTRadius.medium, style: .continuous)
                    .strokeBorder(DTColor.divider, lineWidth: 1)
            )
    }
}

#Preview {
    LoginView()
        .environment(AuthModel(repository: UnconfiguredAuthRepository()))
}
