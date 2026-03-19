package com.softwareofnote.dogtrackin

import com.softwareofnote.dogtrackin.auth.domain.AuthRepository
import com.softwareofnote.dogtrackin.auth.domain.AuthResult
import com.softwareofnote.dogtrackin.auth.domain.User
import com.softwareofnote.dogtrackin.auth.presentation.AuthViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.*
import kotlin.test.*

class FakeAuthRepository : AuthRepository {
    private val currentUserFlow = MutableStateFlow<User?>(null)
    
    override suspend fun login(email: String, password: String): AuthResult {
        if (email == "test@test.com" && password == "password") {
            val user = User("1", email, "Test User")
            currentUserFlow.value = user
            return AuthResult.Success(user)
        }
        return AuthResult.Error("Invalid credentials")
    }

    override suspend fun signUp(email: String, password: String): AuthResult {
        val user = User("1", email, "New User")
        currentUserFlow.value = user
        return AuthResult.Success(user)
    }

    override suspend fun loginWithGoogle(): AuthResult {
        return AuthResult.Error("Not implemented")
    }

    override suspend fun loginWithApple(): AuthResult {
        return AuthResult.Error("Not implemented")
    }

    override fun getCurrentUser(): Flow<User?> = currentUserFlow

    override suspend fun signOut() {
        currentUserFlow.value = null
    }
}

@OptIn(ExperimentalCoroutinesApi::class)
class AuthViewModelTest {

    private lateinit var viewModel: AuthViewModel
    private lateinit var repository: FakeAuthRepository
    private val testDispatcher = StandardTestDispatcher()

    @BeforeTest
    fun setup() {
        // Since we are in commonTest, we can use standard Coroutine testing
        // Note: In some KMP setups, we'd need to set the Main dispatcher.
        repository = FakeAuthRepository()
        viewModel = AuthViewModel(repository)
    }

    @Test
    fun testLoginSuccess() = runTest {
        viewModel.login("test@test.com", "password")
        advanceUntilIdle()
        val user = viewModel.currentUser.value
        assertNotNull(user)
        assertEquals("test@test.com", user.email)
    }

    @Test
    fun testLoginFailure() = runTest {
        viewModel.login("wrong@test.com", "password")
        advanceUntilIdle()
        val user = viewModel.currentUser.value
        assertNull(user)
    }

    @Test
    fun testSignOut() = runTest {
        viewModel.login("test@test.com", "password")
        advanceUntilIdle()
        assertNotNull(viewModel.currentUser.value)
        
        viewModel.signOut()
        advanceUntilIdle()
        assertNull(viewModel.currentUser.value)
    }
}
