package com.softwareofnote.dogtrackin.auth.domain

import kotlinx.coroutines.flow.Flow

interface AuthRepository {
    suspend fun login(email: String, password: String): AuthResult
    suspend fun signUp(email: String, password: String): AuthResult
    suspend fun loginWithGoogle(): AuthResult
    suspend fun loginWithApple(): AuthResult
    fun getCurrentUser(): Flow<User?>
    suspend fun signOut()
}
