package com.softwareofnote.dogtrackin.auth.data

import com.softwareofnote.dogtrackin.auth.domain.AuthError
import com.softwareofnote.dogtrackin.auth.domain.AuthRepository
import com.softwareofnote.dogtrackin.auth.domain.AuthResult
import com.softwareofnote.dogtrackin.auth.domain.User
import dev.gitlive.firebase.Firebase
import dev.gitlive.firebase.auth.FirebaseAuth
import dev.gitlive.firebase.auth.FirebaseAuthInvalidCredentialsException
import dev.gitlive.firebase.auth.FirebaseAuthInvalidUserException
import dev.gitlive.firebase.auth.FirebaseAuthUserCollisionException
import dev.gitlive.firebase.auth.auth
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

/**
 * @param auth the Firebase auth handle. Defaults to [Firebase.auth] for production;
 * inject a different instance (e.g. one pointed at the emulator) in tests.
 */
class FirebaseAuthRepository(
    private val auth: FirebaseAuth = Firebase.auth
) : AuthRepository {

    override suspend fun login(email: String, password: String): AuthResult {
        return try {
            val result = auth.signInWithEmailAndPassword(email, password)
            val user = result.user?.toDomainUser()
            if (user != null) {
                AuthResult.Success(user)
            } else {
                AuthResult.Error(AuthError.Unknown("User not found after login"))
            }
        } catch (e: Exception) {
            AuthResult.Error(e.toAuthError())
        }
    }

    override suspend fun signUp(email: String, password: String): AuthResult {
        return try {
            val result = auth.createUserWithEmailAndPassword(email, password)
            val user = result.user?.toDomainUser()
            if (user != null) {
                AuthResult.Success(user)
            } else {
                AuthResult.Error(AuthError.Unknown("User not found after signup"))
            }
        } catch (e: Exception) {
            AuthResult.Error(e.toAuthError())
        }
    }

    override suspend fun loginWithGoogle(): AuthResult {
        // In a real app, this would involve platform-specific intent/web flow
        // For KMP, we often use expect/actual or a library that handles it.
        // dev.gitlive:firebase-auth has some support, but Google login usually needs
        // more platform-specific setup (GoogleSignIn on Android, etc.)
        return AuthResult.Error(AuthError.Unknown("Google login not implemented in this mock/initial version"))
    }

    override suspend fun loginWithApple(): AuthResult {
        return AuthResult.Error(AuthError.Unknown("Apple login not implemented in this mock/initial version"))
    }

    override fun getCurrentUser(): Flow<User?> {
        return auth.authStateChanged.map { it?.toDomainUser() }
    }

    override suspend fun signOut() {
        auth.signOut()
    }

    private fun dev.gitlive.firebase.auth.FirebaseUser.toDomainUser(): User {
        return User(
            id = uid,
            email = email ?: "",
            name = displayName
        )
    }

    private fun Throwable.toAuthError(): AuthError = when (this) {
        is FirebaseAuthInvalidUserException -> AuthError.UserNotFound
        is FirebaseAuthInvalidCredentialsException -> AuthError.InvalidCredentials
        is FirebaseAuthUserCollisionException -> AuthError.EmailAlreadyInUse
        else ->
            // gitlive surfaces connectivity failures as a generic exception rather
            // than a dedicated type, so fall back to inspecting the message.
            if (message?.contains("network", ignoreCase = true) == true) {
                AuthError.Network
            } else {
                AuthError.Unknown(message)
            }
    }
}
