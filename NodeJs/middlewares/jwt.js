const jwt = require('jsonwebtoken');

const refreshSecret = process.env.REFRESH_TOKEN_SECRET; 
const accessSecret = process.env.ACCESS_TOKEN_SECRET;

const generateAccessToken = (user) => {
    return jwt.sign(user, accessSecret, { expiresIn: '30m' });
}

const generateRefreshToken = (user) => {
    return jwt.sign(user, refreshSecret);
}

const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

// if (!token) {
//     return res.status(401).send('인증되지 않은 요청입니다.');
// }

    jwt.verify(token, accessSecret, (err, decoded) => {
        if (err) {
            if(err.name === "TokenExpiredError"){
                return res.status(401).send('만료된 토큰입니다');
            } else {
                return res.status(403).send('잘못된 토큰입니다.');
            }
        }
        req.user = decoded;
        next();
    });
}

const authenticateRefreshToken = (req, res) => {
    const refreshToken = req.body.refreshToken;

    jwt.verify(refreshToken, refreshSecret, (err, decoded) => {
        if(err) {
            if(err.name === "TokenExpiredError"){
                return res.status(401).send('만료된 토큰입니다');
            } else {
                return res.status(403).send('잘못된 토큰입니다.');
            }
        }
        req.user = decoded;
        const accessToken = generateAccessToken();
        const refreshToken = generateRefreshToken();
        return res.json({ 'accessToekn': accessToken, 'refreshToken': refreshToken});
    } );
}

module.exports= {generateAccessToken, generateRefreshToken, authenticateToken, authenticateRefreshToken };
