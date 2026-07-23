package com.softwareofnote.dogtrackin.auth.domain

data class User(
    val id: String,
    val email: String,
    val name: String? = null
)

sealed class AuthResult {
    data class Success(val user: User) : AuthResult()
    data class Error(val error: AuthError) : AuthResult()
}
