package com.softwareofnote.dogtrackin.auth.domain

/**
 * Typed authentication failures, so callers can react to *why* an operation
 * failed (retry on [Network], prompt re-entry on [InvalidCredentials], etc.)
 * instead of parsing a raw message string.
 */
sealed class AuthError {
    /** No/failed connectivity reaching the backend — safe to offer a retry. */
    data object Network : AuthError()

    /** Wrong email/password, malformed credentials, or a disabled/expired login. */
    data object InvalidCredentials : AuthError()

    /** Sign-up attempted with an email that already has an account. */
    data object EmailAlreadyInUse : AuthError()

    /** No account exists for the supplied identifier. */
    data object UserNotFound : AuthError()

    /** Anything not otherwise classified; retains the original message for logs. */
    data class Unknown(val message: String?) : AuthError()
}
