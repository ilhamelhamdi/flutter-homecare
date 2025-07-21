// This file contains configuration instructions for WeChat SSO setup

/*
WECHAT SIGN-IN SETUP INSTRUCTIONS:

1. Register WeChat Open Platform account:
   - Go to https://open.weixin.qq.com/
   - Register as a developer
   - This requires a Chinese mobile number and business verification

2. Create Mobile Application:
   - Go to "管理中心" > "移动应用" > "创建移动应用"
   - Fill in app details:
     * App name: M2Health
     * App description: Healthcare platform
     * App category: Medical/Health
     * Package name: org.medmap.homecare

3. Get WeChat App ID and Secret:
   - After approval, you'll get WeChat App ID (starts with 'wx')
   - Example: wx1234567890abcdef
   - Keep the App Secret secure (don't put in client code)

4. Update configuration in code:
   - In SSOService, replace "wx1234567890abcdef" with your actual WeChat App ID
   - In AndroidManifest.xml, replace "wx1234567890abcdef" with your actual WeChat App ID

5. Android Configuration:
   - WeChat App ID must be added to AndroidManifest.xml intent-filter
   - Package name must match exactly with registered app

6. iOS Configuration (if needed):
   - Add WeChat App ID to Info.plist
   - Add URL schemes
   - Configure LSApplicationQueriesSchemes

7. WeChat SDK Integration:
   - The fluwx package handles most of the integration
   - Ensure WeChat app is installed on device for testing

TESTING:
- WeChat must be installed on the device
- Use real device (WeChat doesn't work well in emulators)
- Test with actual WeChat account

BACKEND INTEGRATION:
Your backend should handle WeChat auth:
POST /api/v1/register/social
{
  "provider": "wechat",
  "role": "patient|nurse|pharmacist|radiologist",
  "auth_code": "...",
  "state": "...",
  "nonce": "..."
}

Backend flow:
1. Receive auth_code from client
2. Exchange auth_code for access_token with WeChat API
3. Get user info from WeChat API using access_token
4. Create/login user in your system
5. Return JWT token

WeChat API Endpoints:
- Token: https://api.weixin.qq.com/sns/oauth2/access_token
- User Info: https://api.weixin.qq.com/sns/userinfo

IMPORTANT NOTES:
- WeChat registration requires business verification in China
- This may take several weeks to complete
- Alternative: Use WeChat Mini Program for easier approval
- Consider using WeChat Work (企业微信) for business applications

DEVELOPMENT TIPS:
- Use WeChat Developer Tools for testing
- Enable debug mode in WeChat app: WeChat > Me > Settings > General > Discovery Management > Enable "Developer Tools"
- Check WeChat logs for debugging
*/
