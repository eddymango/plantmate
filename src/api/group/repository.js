const { pool } = require("../../database");

// 그룹 생성
exports.createGroup = async (name, description, password, createdBy) => {
  try {
    // 그룹 정보를 group_info 테이블에 삽입
    const query = `INSERT INTO group_info (name, description, password, created_by) VALUES (?, ?, ?, ?)`;
    const result = await pool.query(query, [
      name,
      description,
      password,
      createdBy,
    ]);

    // 생성된 그룹 ID 확인
    const groupId = result.insertId;

    // 그룹 생성자를 group_users 테이블에 추가
    const joinQuery = `INSERT INTO group_users (group_id, user_id) VALUES (?, ?)`;
    await pool.query(joinQuery, [groupId, createdBy]);

    return groupId; // 성공적으로 생성된 그룹 ID 반환
  } catch (error) {
    console.error("Error in createGroup:", error.message);
    throw error; // 에러를 호출한 함수로 전달
  }
};

// 그룹 조회 (전체)
exports.getAllGroups = async () => {
  const query = `SELECT id, name, description, created_by, created_at FROM group_info`;
  const rows = await pool.query(query);
  return rows; // 그룹 목록 반환
};

// 특정 그룹 조회
exports.getGroupById = async (groupId) => {
  const query = `SELECT id, name, description, created_by, created_at FROM group_info WHERE id = ?`;
  const [rows] = await pool.query(query, [groupId]);
  return rows.length > 0 ? rows[0] : null; // 그룹 정보 반환 또는 null
};

// 그룹 비밀번호 검증
exports.verifyGroupPassword = async (groupId, password) => {
  const query = `SELECT password FROM group_info WHERE id = ?`;
  const rows = await pool.query(query, [groupId]);

  if (rows.length === 0) return false; // 그룹이 없으면 false 반환
  return password === rows[0].password; // 비밀번호 비교
};
//유저가 가입한 그룹 정보
exports.getUserGroups = async (userId) => {
  const query = `SELECT group_id FROM group_users WHERE user_id = ?`;
  const rows = await pool.query(query, [userId]);
  return rows;
};
// 그룹 가입
exports.joinGroup = async (groupId, userId) => {
  const query = `INSERT INTO group_users (group_id, user_id) VALUES (?, ?)`;
  const result = await pool.query(query, [groupId, userId]);
  return result;
};

// 그룹 탈퇴
exports.leaveGroup = async (groupId, userId) => {
  const query = `DELETE FROM group_users WHERE group_id = ? AND user_id = ?`;
  const result = await pool.query(query, [groupId, userId]);
  return result; // 탈퇴 결과 반환
};

// 그룹 삭제
exports.deleteGroup = async (groupId, userId) => {
  // 그룹 생성자인지 확인
  const query = `SELECT created_by FROM group_info WHERE id = ?`;
  const rows = await pool.query(query, [groupId]);

  console.log("Query Result:", rows);

  if (!rows || (Array.isArray(rows) && rows.length === 0)) {
    return { success: false, message: "그룹을 찾을 수 없습니다." }; // 그룹이 없으면 반환
  }

  // 결과가 배열인지 확인
  const createdBy = Array.isArray(rows) ? rows[0]?.created_by : rows.created_by;

  if (!createdBy) {
    return { success: false, message: "그룹을 찾을 수 없습니다." }; // 그룹이 없으면 반환
  }

  // 생성자가 아닌 경우
  if (String(createdBy) !== String(userId)) {
    return { success: false, message: "그룹 삭제 권한이 없습니다." };
  }

  // 그룹 삭제
  const deleteQuery = `DELETE FROM group_info WHERE id = ?`;
  const result = await pool.query(deleteQuery, [groupId]);

  return { success: result.affectedRows > 0 };
};

//rmfnqdp 속한 식물 조회
exports.getGroupPlants = async (groupId) => {
  const query = `SELECT * FROM plants WHERE group_id = ?`;
  const rows = await pool.query(query, [groupId]);
  // console.log("Query Result from DB:", rows); // 쿼리 결과 로그 출력

  return rows;
};
