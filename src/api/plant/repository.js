const fs = require('fs/promises');
const { pool } = require("../../database");

// 식물 추가
exports.addPlant = async (name, description, watering_interval, group_id, photo_url) => {
    const query = `INSERT INTO plants (name, description, watering_interval, group_id, photo_url) VALUES (?, ?, ?, ?, ?)`;
    const result = await pool.query(query, [name, description, watering_interval, group_id, photo_url]);
    return result;
};

// 식물 수정
exports.updatePlant = async (id, name, description, watering_interval, photo_url) => {
    const query = `UPDATE plants SET name = ?, description = ?, watering_interval = ?, photo_url = ? WHERE id = ?`;
    const result = await pool.query(query, [name, description, watering_interval, photo_url, id]);
    return result;
};

// 식물 삭제
exports.deletePlant = async (id) => {
   const connection = await pool.getConnection();
   try{
    await connection.beginTransaction();

    const queryGetPhotoUrl = `SELECT photo_url FROM plants WHERE id = ?`;
    const [resultGetPhotoUrl] = await connection.query(queryGetPhotoUrl, [id]);
    console.log("Photo URL Query Result:", resultGetPhotoUrl);
    const photoUrl = resultGetPhotoUrl.length > 0 ? resultGetPhotoUrl[0].photo_url : null;

    if(photoUrl){
        await fs.unlink(photoUrl);
    }

    const query = `DELETE FROM plants WHERE id = ?`;
    const [result] = await connection.query(query, [id]);
    await connection.commit();
    return result;
   } catch (error) {
    await connection.rollback();
    console.error("Error in deletePlant:", error.message);
    throw error;
   } finally {
    connection.release();
   }
};

// 식물 조회
exports.getPlant = async (id) => {
    const query = `SELECT * FROM plants WHERE id = ?`;
    const result = await pool.query(query, [id]);
    return result;
};

// 식물 물주기
exports.waterPlant = async (plantId, userId) => {
    const connection = await pool.getConnection();
    try {
        await connection.beginTransaction();

        // 물주기 로그 추가
        const logQuery = `INSERT INTO plant_logs (plant_id, user_id) VALUES (?, ?)`;
        await connection.query(logQuery, [plantId, userId]);

        // 마지막 물 준 날짜 업데이트
        const updateQuery = `UPDATE plants SET last_watered_at = CURRENT_TIMESTAMP WHERE id = ?`;
        await connection.query(updateQuery, [plantId]);

        await connection.commit();
    } catch (error) {
        await connection.rollback();
        console.error("Error in waterPlant:", error.message);
        throw error;
    } finally {
        connection.release();
    }
};

// 물주기 주기 계산
exports.getWateringSchedule = async (plantId) => {
    const query = `SELECT watering_interval, last_watered_at FROM plants WHERE id = ?`;
    const result = await pool.query(query, [plantId]);

    if (result.length === 0) {
        return null;
    }

    const { watering_interval, last_watered_at } = result[0];

    const nextWateringDate = new Date(last_watered_at + 'Z');
    nextWateringDate.setDate(nextWateringDate.getDate() + watering_interval);

    const today = new Date();
    const diffTime = nextWateringDate.getTime() - today.getTime();
    const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));

    return {
        nextWateringDate: nextWateringDate.toISOString().split('T')[0],
        daysUntilNextWatering: diffDays >= 0 ? diffDays : 0,
    };
};

