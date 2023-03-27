const bcrypt = require('bcrypt');
const { User } = require('../models/userDTO');
const mysql = require('mysql2/promise');
const config = require('../env/db_config.json');
const jwt = require('../middlewares/jwt');

const pool = mysql.createPool(config);

const loginUser = async (req, res) => {
  const { id, password } = req.body;

  const connection = await pool.getConnection();
  try{
    const [rows] = await connection.query('SELECT * FROM user WHERE user_id = ?', [id]);
    if(rows.length == 0){
      throw new Error('일치하는 사용자 ID가 없습니다. 다시 입력해주세요')
    }

    const user = rows[0];
    const passwordMatch = await bcrypt.compare(password, user.user_password);
    if (!passwordMatch) {
      throw new Error('비밀번호가 일치하지 않습니다.');
    }

    const accessToken = jwt.generateAccessToken(new User(user.id, user.name, user.password));
    const refreshToken = jwt.generateRefreshToken(new User(user.id, user.name, user.password));

    res.json({ success: true, message: '로그인 성공', token: accessToken });
    res.cookie('refreshToken', refreshToken, { httpOnly: true, secure: true });
  } catch (error) {
    res.status(401).json({ success: false, message: "로그인 실패, 다시 시도해 주세요." });
  } finally {
    connection.release();
  }
}

const joinUser = async (req, res) => {
  const { id, name, password } = req.body;

  const connection = await pool.getConnection();
  try{
    await connection.beginTransaction();

    const [rows] = await connection.query('SELECT * FROM user WHERE user_name = ?', [name]);
    if(rows.length > 0){
      throw new Error('이미 존재하는 사용자입니다. 다시 시도해주세요')
    } else {
      const [rows] = await connection.query('SELECT * FROM user WHERE user_id = ?', [id]);
      if(rows.length > 0){
      throw new Error('이미 존재하는 ID입니다. 다시 시도해주세요!')
      }
    }

    const saltRounds = 10;
    const salt = await bcrypt.genSalt(saltRounds);
    const hashedPassword = await bcrypt.hash(password, salt);

    await connection.query('INSERT INTO user (user_id, user_name, user_password) VALUES (?, ?, ?)', [id, name, hashedPassword]);
    
    await connection.commit();
    res.json({ success: true, message: '회원가입 성공' });

  } catch (error) {
    res.status(401).json({ success: false, message: '회원가입 실패, 다시 시도해 주세요' });
    await connection.rollback();
    
  } finally {
    connection.release();
  }
}

module.exports = { joinUser, loginUser }