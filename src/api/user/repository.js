const { pool } = require('../../database');

//회원가입
exports.register = async (email, password, name) => {
    const query = `INSERT INTO users (email, password, name) VALUES (?, ?, ?)`;
    return await pool.query(query, [email, password, name]);
    
};

//로그인 
exports.login = async (email, password) => {
    const query = `SELECT * FROM users WHERE email = ? AND password = ?`;
    let result = await pool.query(query, [email, password]);
    return (result.length < 0) ? null : result[0];
};

//이메일 중복 확인
exports.findByEmail = async (email) => {
    const query = `SELECT COUNT(*) AS count FROM users WHERE email = ?`;
    const result = await pool.query(query, [email]);
    return (result.length < 0) ? null : result[0];
};

//회원정보 조회
exports.findById = async (id) => {
    const query = `SELECT id, email, name, created_at FROM users WHERE id = ?`;
    const result = await pool.query(query, [id]);
    return (result.length < 0) ? null : result[0];
};

//회원정보 수정
exports.update = async (id, name, password) => {
    let query;
    let params;

    //이름과 비밀번호 모두 수정
    if (name && password) {
        query = `UPDATE users SET name = ?, password = ? WHERE id = ?`;
        params = [name, password, id];
    }
    //이름만 수정
    else if (name) {
        query = `UPDATE users SET name = ? WHERE id = ?`;
        params = [name, id];
    }
    //비밀번호만 수정
    else if (password) {
        query = `UPDATE users SET password = ? WHERE id = ?`;
        params = [password, id];
    } else {
        return { affectedRows: 0 };
    }

    const [result] = await pool.query(query, params);
    return result;
};

//회원탈퇴
exports.delete = async (id) => {
    const query = `DELETE FROM users WHERE id = ?`;
    const [result] = await pool.query(query, [id]);
    return result;
};