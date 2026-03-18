# DogTrackinKMP Project Guidelines

This document provides project-specific details for development, building, and testing the DogTrackinKMP Kotlin Multiplatform (KMP) project.

## 1. Build & Configuration

The project uses Kotlin Multiplatform targeting **Android** and **iOS**.

### Prerequisites
- **Android Studio** (or IntelliJ IDEA with KMP plugin)
- **Xcode** (for iOS development)
- **JDK 11** (configured in `composeApp/build.gradle.kts`)

### Build Commands
- **Android Debug Build**:
  ```bash
  ./gradlew :composeApp:assembleDebug
  ```
- **iOS Framework**:
  The iOS framework is generated as part of the Gradle build. Xcode projects in `iosApp/` are configured to trigger this automatically.

## 2. Testing

Testing is centralized in the `commonTest` source set to ensure logic works across all platforms.

### Running Tests
- **All common tests (on all available targets)**:
  ```bash
  ./gradlew :composeApp:allTests
  ```
- **Specific test class**:
  ```bash
  ./gradlew :composeApp:testDebugUnitTest --tests "com.softwareofnote.dogtrackin.ComposeAppCommonTest"
  ```

### Adding New Tests
1.  Navigate to `composeApp/src/commonTest/kotlin/com/softwareofnote.dogtrackin/`.
2.  Create a Kotlin file/class.
3.  Use `kotlin.test` annotations (`@Test`, `assertEquals`, etc.).
4.  If platform-specific behavior needs testing, use `expect`/`actual` or define tests in `androidMain/kotlin` and `iosMain/kotlin` source sets.

### Example Test
```kotlin
package com.softwareofnote.dogtrackin

import kotlin.test.Test
import kotlin.test.assertTrue

class PlatformTest {
    @Test
    fun testPlatformNameIsNotEmpty() {
        val platform = getPlatform()
        assertTrue(platform.name.isNotBlank())
    }
}
```

## 3. Development Information

### Project Structure
- `composeApp/src/commonMain`: Shared UI (Compose Multiplatform) and business logic.
- `composeApp/src/androidMain`: Android-specific implementations and resources.
- `composeApp/src/iosMain`: iOS-specific implementations.
- `iosApp/`: Native iOS application entry point (SwiftUI).

### Code Style
- Follow standard Kotlin coding conventions.
- Use `libs.versions.toml` for dependency management.
- Prefer `commonMain` for all logic unless platform APIs are strictly required.
- Use `expect`/`actual` for platform-specific implementations (e.g., `getPlatform()`).

### Debugging
- Use the **Android** run configuration for Android debugging.
- Use the **iosApp** configuration (which launches the iOS simulator) for iOS debugging.
