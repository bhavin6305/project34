const express = require('express');
const { RtcTokenBuilder, RtcRole } = require('agora-access-token');
require('dotenv').config();

const app = express();

app.get('/rtcToken', (req, res) => {
  const channelName = req.query.channel;
  if (!channelName) {
    return res.status(400).json({ error: 'channel is required' });
  }

  const uid = req.query.uid ? Number(req.query.uid) : 0; // 0 means auto
  const role = RtcRole.PUBLISHER; // or SUBSCRIBER
  const expireTime = 3600; // 1 hour
  const currentTime = Math.floor(Date.now() / 1000);
  const privilegeExpireTs = currentTime + expireTime;

  const token = RtcTokenBuilder.buildTokenWithUid(
    process.env.APP_ID,
    process.env.APP_CERTIFICATE,
    channelName,
    uid,
    role,
    privilegeExpireTs
  );

  res.json({ token });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Token server running on port ${PORT}`));
