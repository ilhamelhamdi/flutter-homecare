// Example backend implementation for SSO endpoints
// This is just a reference - implement in your actual backend

/*
BACKEND ENDPOINT EXAMPLES (Node.js/Express style)

// Social Sign-In endpoint
app.post('/api/v1/register/social', async (req, res) => {
  try {
    const { provider, role, access_token, id_token, auth_code, email, name, profile_picture, google_id } = req.body;
    
    let userInfo = {};
    
    if (provider === 'google') {
      // Verify Google token
      const { OAuth2Client } = require('google-auth-library');
      const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);
      
      const ticket = await client.verifyIdToken({
        idToken: id_token,
        audience: process.env.GOOGLE_CLIENT_ID,
      });
      
      const payload = ticket.getPayload();
      userInfo = {
        email: payload.email,
        name: payload.name,
        profile_picture: payload.picture,
        provider_id: payload.sub,
        provider: 'google'
      };
      
    } else if (provider === 'wechat') {
      // Exchange WeChat auth code for access token
      const wechatTokenResponse = await fetch(`https://api.weixin.qq.com/sns/oauth2/access_token?appid=${process.env.WECHAT_APP_ID}&secret=${process.env.WECHAT_APP_SECRET}&code=${auth_code}&grant_type=authorization_code`);
      const tokenData = await wechatTokenResponse.json();
      
      if (tokenData.errcode) {
        throw new Error(`WeChat token error: ${tokenData.errmsg}`);
      }
      
      // Get user info from WeChat
      const userInfoResponse = await fetch(`https://api.weixin.qq.com/sns/userinfo?access_token=${tokenData.access_token}&openid=${tokenData.openid}&lang=en`);
      const wechatUserInfo = await userInfoResponse.json();
      
      userInfo = {
        email: wechatUserInfo.unionid + '@wechat.local', // WeChat doesn't provide email
        name: wechatUserInfo.nickname,
        profile_picture: wechatUserInfo.headimgurl,
        provider_id: wechatUserInfo.openid,
        provider: 'wechat'
      };
    }
    
    // Check if user exists
    let user = await User.findOne({ 
      $or: [
        { email: userInfo.email },
        { provider_id: userInfo.provider_id, provider: userInfo.provider }
      ]
    });
    
    if (!user) {
      // Create new user
      user = new User({
        username: userInfo.name || `${userInfo.provider}${Date.now()}`,
        email: userInfo.email,
        name: userInfo.name,
        role: role.toLowerCase(),
        provider: userInfo.provider,
        provider_id: userInfo.provider_id,
        profile_picture: userInfo.profile_picture,
        email_verified: true, // Social accounts are pre-verified
        created_at: new Date()
      });
      
      await user.save();
    } else {
      // Update existing user info
      user.name = userInfo.name || user.name;
      user.profile_picture = userInfo.profile_picture || user.profile_picture;
      user.last_login = new Date();
      await user.save();
    }
    
    // Generate JWT token
    const token = jwt.sign(
      { 
        user_id: user._id, 
        email: user.email, 
        role: user.role 
      },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );
    
    res.json({
      success: true,
      token: token,
      user: {
        id: user._id,
        username: user.username,
        email: user.email,
        name: user.name,
        role: user.role,
        profile_picture: user.profile_picture
      }
    });
    
  } catch (error) {
    console.error('Social sign-in error:', error);
    res.status(400).json({
      success: false,
      message: error.message || 'Social sign-in failed'
    });
  }
});

// Environment variables needed:
// GOOGLE_CLIENT_ID=your_google_client_id
// WECHAT_APP_ID=your_wechat_app_id  
// WECHAT_APP_SECRET=your_wechat_app_secret
// JWT_SECRET=your_jwt_secret

// Database schema example (MongoDB/Mongoose):
const userSchema = new Schema({
  username: { type: String, required: true, unique: true },
  email: { type: String, required: true, unique: true },
  name: String,
  role: { type: String, enum: ['patient', 'nurse', 'pharmacist', 'radiologist'], required: true },
  provider: { type: String, enum: ['email', 'google', 'wechat', 'facebook'] },
  provider_id: String,
  profile_picture: String,
  email_verified: { type: Boolean, default: false },
  created_at: { type: Date, default: Date.now },
  last_login: Date
});
*/
