// This file contains configuration instructions for Google SSO setup

/*
GOOGLE SIGN-IN SETUP INSTRUCTIONS:

1. Go to Google Cloud Console (https://console.cloud.google.com/)

2. Create a new project or select existing project

3. Enable Google Sign-In API:
   - Go to "APIs & Services" > "Library"
   - Search for "Google Sign-In API" 
   - Click "Enable"

4. Create OAuth 2.0 credentials:
   - Go to "APIs & Services" > "Credentials"
   - Click "Create Credentials" > "OAuth 2.0 Client IDs"
   
5. For Android:
   - Application type: Android
   - Package name: org.medmap.homecare
   - SHA-1 certificate fingerprint: Get from running:
     * Debug: cd android && ./gradlew signingReport
     * Or use: keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

6. For iOS (if needed):
   - Application type: iOS
   - Bundle ID: org.medmap.homecare

7. For Web (if needed):
   - Application type: Web application
   - Authorized redirect URIs: Add your domain

8. Download the configuration files:
   - Android: Download google-services.json and put in android/app/
   - iOS: Download GoogleService-Info.plist and put in ios/Runner/

9. Update the client ID in SSOService:
   - Replace '123456789-abcdefgh.apps.googleusercontent.com' with your actual client ID
   - The client ID can be found in your google-services.json file

10. Add google-services plugin to android/app/build.gradle:
    - Add at the top: id 'com.google.gms.google-services'
    - Add at the bottom: apply plugin: 'com.google.gms.google-services'

11. Add to android/build.gradle dependencies:
    - classpath 'com.google.gms:google-services:4.3.15'

TESTING:
- Use a real device or emulator with Google Play Services
- Debug build will work with debug SHA-1 fingerprint
- Release build needs release SHA-1 fingerprint

BACKEND INTEGRATION:
Your backend should have an endpoint to handle social sign-in:
POST /api/v1/register/social
{
  "provider": "google",
  "role": "patient|nurse|pharmacist|radiologist", 
  "access_token": "...",
  "id_token": "...",
  "email": "user@gmail.com",
  "name": "User Name",
  "profile_picture": "https://...",
  "google_id": "123456789"
}

Response should include:
{
  "token": "jwt_token_here",
  "user": {
    "id": 123,
    "username": "user123",
    "email": "user@gmail.com",
    "role": "patient"
  }
}
*/
