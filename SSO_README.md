# Social Sign-On (SSO) Setup Guide

This guide explains how to set up Google Sign-In and WeChat Sign-In for the M2Health app.

## Overview

The app supports three social sign-in methods:

- ✅ Google Sign-In (Implemented)
- ✅ WeChat Sign-In (Implemented)
- 🚧 Facebook Sign-In (Placeholder)

## Files Added/Modified

### New Files:

- `lib/services/sso_service.dart` - Main SSO service implementation
- `docs/google_sso_setup.dart` - Google setup instructions
- `docs/wechat_sso_setup.dart` - WeChat setup instructions
- `docs/backend_sso_example.dart` - Backend implementation example
- `android/app/google-services.json.template` - Google services template
- `android/app/proguard-rules.pro` - ProGuard rules for release builds
- `test/sso_service_test.dart` - Unit tests for SSO service

### Modified Files:

- `pubspec.yaml` - Added SSO dependencies
- `lib/cubit/signup/sign_up_cubit.dart` - Integrated SSO service
- `android/app/build.gradle` - Added Google services plugin
- `android/build.gradle` - Added Google services classpath
- `android/app/src/main/AndroidManifest.xml` - Added SSO permissions and activities

## Setup Instructions

### 1. Google Sign-In Setup

1. **Create Google Cloud Project**

   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create new project or select existing one

2. **Enable Google Sign-In API**

   - Navigate to "APIs & Services" > "Library"
   - Search and enable "Google Sign-In API"

3. **Create OAuth Credentials**

   - Go to "APIs & Services" > "Credentials"
   - Create OAuth 2.0 Client ID for Android
   - Package name: `org.medmap.homecare`
   - Get SHA-1 fingerprint: `cd android && ./gradlew signingReport`

4. **Download Configuration**

   - Download `google-services.json`
   - Place in `android/app/google-services.json`

5. **Update Client ID**
   - Copy client ID from `google-services.json`
   - Update in `lib/services/sso_service.dart`

### 2. WeChat Sign-In Setup

1. **Register WeChat Developer Account**

   - Go to [WeChat Open Platform](https://open.weixin.qq.com/)
   - Register developer account (requires Chinese mobile number)

2. **Create Mobile Application**

   - Submit app for review with business verification
   - Get WeChat App ID (format: `wx1234567890abcdef`)

3. **Update Configuration**
   - Replace WeChat App ID in `lib/services/sso_service.dart`
   - Update App ID in `android/app/src/main/AndroidManifest.xml`

### 3. Backend Setup

Your backend needs to handle social authentication:

```javascript
POST /api/v1/register/social
{
  "provider": "google|wechat",
  "role": "patient|nurse|pharmacist|radiologist",
  "access_token": "...", // For Google
  "id_token": "...",      // For Google
  "auth_code": "...",     // For WeChat
  "email": "user@example.com",
  "name": "User Name"
}
```

See `docs/backend_sso_example.dart` for detailed implementation.

## Usage

### In Sign-Up Page

```dart
// Google Sign-In
context.read<SignUpCubit>().signUpWithGoogle(_selectedRole!);

// WeChat Sign-In
context.read<SignUpCubit>().signUpWithWeChat(_selectedRole!);

// Facebook Sign-In (placeholder)
context.read<SignUpCubit>().signUpWithFacebook(_selectedRole!);
```

### Testing

1. **Google Sign-In Testing**

   - Use real device or emulator with Google Play Services
   - Debug builds work with debug SHA-1 fingerprint
   - Release builds need release SHA-1 fingerprint

2. **WeChat Sign-In Testing**
   - WeChat app must be installed on device
   - Use real device (emulators may not work)
   - Test with actual WeChat account

## Security Considerations

1. **Never commit sensitive files:**

   - `android/app/google-services.json`
   - WeChat App Secret (backend only)

2. **Use different credentials for:**

   - Development/Debug builds
   - Production/Release builds

3. **Validate tokens on backend:**
   - Always verify Google ID tokens server-side
   - Exchange WeChat auth codes for tokens server-side

## Troubleshooting

### Common Issues:

1. **Google Sign-In fails**

   - Check SHA-1 fingerprint matches
   - Verify package name is correct
   - Ensure Google Play Services is available

2. **WeChat Sign-In fails**

   - Verify WeChat app is installed
   - Check WeChat App ID is correct
   - Ensure app is approved by WeChat

3. **Build errors**
   - Run `flutter clean && flutter pub get`
   - Check all dependencies are properly added
   - Verify Android configuration is correct

### Debug Commands:

```bash
# Get SHA-1 fingerprint
cd android && ./gradlew signingReport

# Clean and rebuild
flutter clean
flutter pub get
cd android && ./gradlew clean

# Check dependencies
flutter doctor
```

## Next Steps

1. **Complete Google setup** with actual credentials
2. **Register WeChat developer account** (requires business verification)
3. **Implement backend endpoints** for social authentication
4. **Add Facebook Sign-In** using `flutter_facebook_auth` package
5. **Add proper error handling** and user feedback
6. **Implement sign-out functionality**
7. **Add account linking** for existing users

## Support

For issues with:

- **Google Sign-In**: Check Google Cloud Console and Firebase documentation
- **WeChat Sign-In**: Contact WeChat Open Platform support (Chinese required)
- **Implementation**: Check Flutter documentation and package repositories
