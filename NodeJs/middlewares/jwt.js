const jwt = require('jsonwebtoken');
const mysql = require('mysql2/promise');
const config = require('../env/db_config.json');

require('dotenv').config();

const refreshSecret = process.env.REFRESH_TOKEN_SECRET; 
const accessSecret = process.env.ACCESS_TOKEN_SECRET;

const pool = mysql.createPool(config);

const getUserData = async (refreshToken) => {
    const connection = await pool.getConnection();

    try{
        const [rows] = await connection.query('SELECT * FROM token WHERE refresh_token = ?', [refreshToken]);
        if(rows.length == 0){
            throw new Error('일치하는 정보가 없습니다. 다시 시도해 주세요.')
        }
        return rows[0];
    } catch (error) {
        throw new Error('?');
    } finally {
        connection.release();
      }
}

const generateAccessToken = (user) => {
    return jwt.sign(user, accessSecret, { expiresIn: '1m' });
}

const generateRefreshToken = () => {
    return jwt.sign({}, refreshSecret, {expiresIn: '1 days'});
}

const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const accessToken = authHeader && authHeader.split(' ')[1];

    if (!accessToken) {
        return res.status(401).send('인증되지 않은 요청입니다.');
    }

    jwt.verify(accessToken, accessSecret, (err, decoded) => {
        if (err) {
            if(err.name === "TokenExpiredError"){
                return res.status(401).send('만료된 토큰입니다');
            } else {
                return res.status(403).send('잘못된 토큰입니다1.');
            }
        }
        req.user = decoded;
        next();
    });
}

const authenticateRefreshToken = (req, res) => {
    const refreshToken = req.body.refreshToken;
    if (!refreshToken) {
        return res.status(401).send('인증되지 않은 요청입니다.');
    }

    jwt.verify(refreshToken, refreshSecret, async (err, decoded) => {
        if(err) {
            if(err.name === "TokenExpiredError"){
                return res.status(401).send('만료된 토큰입니다');
            } else {
                return res.status(403).send('잘못된 토큰입니다.');
            }
        }
        const user = await getUserData(refreshToken);
        const newAccessToken = generateAccessToken(user);
        const newRefreshToken = generateRefreshToken();

        return res.json({ 'accessToekn': newAccessToken, 'refreshToken': newRefreshToken});
    } );
}

module.exports= {generateAccessToken, generateRefreshToken, authenticateToken, authenticateRefreshToken };
