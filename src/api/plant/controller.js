const repository = require("./repository");

// 식물 추가
exports.addPlant = async (req, res) => {
  const { name, description, watering_interval, group_id } = req.body;
  const photo_url = req.file ? 'storage/' + req.file.filename : null;

  try {
    const result = await repository.addPlant(name, description, watering_interval, group_id, photo_url);
    res.status(200).json({ result: "ok", data: result });
  } catch (error) {
    console.error("Error in addPlant:", error.message);
    res.status(500).json({ result: "fail", message: "오류가 발생했습니다." });
  }
};

// 식물 수정
exports.updatePlant = async (req, res) => {
  const { id } = req.params;
  const { name, description, watering_interval } = req.body;
  const photo_url = req.file ? 'storage/' + req.file.filename : null;
  
  try {
    const result = await repository.updatePlant(id, name, description, watering_interval, photo_url);
    if (result.affectedRows > 0) {
      res.status(200).json({ result: "ok", data: result });
    } else {
      res.status(404).json({ result: "fail", message: "식물을 찾을 수 없습니다." });
    }
  } catch (error) {
    console.error("Error in updatePlant:", error.message);
    res.status(500).json({ result: "fail", message: "오류가 발생했습니다." });
  }
};

// 식물 삭제
exports.deletePlant = async (req, res) => {
  const { id } = req.params;
  try {
    const result = await repository.deletePlant(id);
    if (result.affectedRows > 0) {
      res.status(200).json({ result: "ok", message: "식물이 삭제되었습니다." });
    } else {
      res.status(404).json({ result: "fail", message: "식물을 찾을 수 없습니다." });
    }
  } catch (error) {
    console.error("Error in deletePlant:", error.message);
    res.status(500).json({ result: "fail", message: "오류가 발생했습니다." });
  }
};

// 식물 조회
exports.getPlant = async (req, res) => {
  const { id } = req.params;
  try {
    const result = await repository.getPlant(id);
    if (result.length > 0) {
      res.status(200).json({ result: "ok", data: result[0] });
    } else {
      res.status(404).json({ result: "fail", message: "식물을 찾을 수 없습니다." });
    }
  } catch (error) {
    console.error("Error in getPlant:", error.message);
    res.status(500).json({ result: "fail", message: "오류가 발생했습니다." });
  }
};

// 식물 물주기
exports.waterPlant = async (req, res) => {
  const { id } = req.params;
  const userId = req.body.userId;
  try {
    const result = await repository.waterPlant(id, userId);
    res.status(200).json({ result: "ok", data: result });
  } catch (error) {
    console.error("Error in waterPlant:", error.message);
    res.status(500).json({ result: "fail", message: "오류가 발생했습니다." });
  }
};

// 물주기 주기 계산
exports.getWateringSchedule = async (req, res) => {
  const { id } = req.params;
  try {
    const result = await repository.getWateringSchedule(id);
    if (!result) {
      return res.status(404).json({ result: "fail", message: "식물을 찾을 수 없습니다." });
    }
    res.status(200).json({ result: "ok", data: { nextWateringDate: result.nextWateringDate, daysUntilNextWatering: result.daysUntilNextWatering } 
    });
  } catch (error) {
    console.error("Error fetching watering schedule:", error.message);
    res.status(500).json({ result: "fail", message: "오류가 발생했습니다." });
  }
};
