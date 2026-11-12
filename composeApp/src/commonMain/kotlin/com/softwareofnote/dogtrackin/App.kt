package com.softwareofnote.dogtrackin

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.softwareofnote.dogtrackin.auth.data.FirebaseAuthRepository
import com.softwareofnote.dogtrackin.auth.presentation.AuthViewModel
import com.softwareofnote.dogtrackin.auth.presentation.LoginScreen
import org.jetbrains.compose.resources.painterResource

import dogtrackin.composeapp.generated.resources.Res
import dogtrackin.composeapp.generated.resources.compose_multiplatform

@Composable
@Preview
fun App() {
    MaterialTheme {
        val authRepository = remember { FirebaseAuthRepository() }
        val authViewModel: AuthViewModel = viewModel { AuthViewModel(authRepository) }
        val currentUser by authViewModel.currentUser.collectAsState()

        if (currentUser == null) {
            LoginScreen(
                viewModel = authViewModel,
                onLoginSuccess = {
                    // Current user will be updated by repository
                }
            )
        } else {
            MainContent(
                userEmail = currentUser?.email ?: "Unknown",
                onLogout = { authViewModel.signOut() }
            )
        }
    }
}

@Composable
fun MainContent(userEmail: String, onLogout: () -> Unit) {
    var showContent by remember { mutableStateOf(false) }
    Column(
        modifier = Modifier
            .background(MaterialTheme.colorScheme.primaryContainer)
            .safeContentPadding()
            .fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        Text("Logged in as: $userEmail", modifier = Modifier.padding(top = 16.dp))
        
        Button(onClick = { showContent = !showContent }) {
            Text("Click me!")
        }
        
        AnimatedVisibility(showContent) {
            val greeting = remember { Greeting().greet() }
            Column(
                modifier = Modifier.fillMaxWidth(),
                horizontalAlignment = Alignment.CenterHorizontally,
            ) {
                Image(painterResource(Res.drawable.compose_multiplatform), null)
                Text("Compose: $greeting")
            }
        }
        
        Button(onClick = onLogout, modifier = Modifier.padding(top = 32.dp)) {
            Text("Logout")
        }
    }
}