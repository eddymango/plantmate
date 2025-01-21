const repository = require("./repository");
const moment = require("moment-timezone");

// 그룹 생성
exports.createGroup = async (req, res) => {
  const { userId, name, description, password } = req.body;
  try {
    // 그룹 생성
    const groupId = await repository.createGroup(
      name,
      description,
      password,
      userId
    );

    // 성공 응답 반환
    res.status(201).json({ result: "ok", groupId });
  } catch (err) {
    console.error("Error creating group:", err.message);
    res
      .status(500)
      .json({ result: "fail", message: "서버 오류가 발생했습니다." });
  }
};

// 전체 그룹 조회
exports.getAllGroups = async (req, res) => {
  const userId = req.query.userId; // 쿼리 매개변수로 전달된 userId

  try {
    const groups = await repository.getAllGroups();
    const userGroups = await repository.getUserGroups(userId);

    const updatedGroups = groups.map((group) => ({
      ...group,
      isJoined: userGroups.some((userGroup) => userGroup.group_id === group.id),
    }));

    res.status(200).json({ result: "ok", data: updatedGroups });
  } catch (err) {
    console.error("Error fetching groups:", err);
    res.status(500).json({ result: "fail", message: "오류가 발생했습니다." });
  }
};

// 특정 그룹 조회
exports.getGroupById = async (req, res) => {
  const { groupId } = req.params;

  try {
    const group = await repository.getGroupById(groupId);
    if (!group) {
      return res
        .status(404)
        .json({ result: "fail", message: "그룹을 찾을 수 없습니다." });
    }
    res.status(200).json({ result: "ok", data: group });
  } catch (err) {
    console.error("Error fetching group:", err);
    res.status(500).json({ result: "fail", message: "오류가 발생했습니다." });
  }
};

// 그룹 가입
exports.joinGroup = async (req, res) => {
  const { userId, groupId, password } = req.body;

  try {
    const isValid = await repository.verifyGroupPassword(groupId, password);
    if (!isValid) {
      return res
        .status(401)
        .json({ result: "fail", message: "비밀번호가 올바르지 않습니다." });
    }

    // 그룹 가입 로직 (group_users 테이블에 사용자 추가)
    const joinResult = await repository.joinGroup(groupId, userId);
    res.status(200).json({ result: "ok", message: "그룹에 가입되었습니다." });
  } catch (err) {
    console.error("Error joining group:", err);
    res.status(500).json({ result: "fail", message: "오류가 발생했습니다." });
  }
};

// 그룹 탈퇴
exports.leaveGroup = async (req, res) => {
  const { groupId } = req.params;
  const userId = req.query.userId; // 로그인한 사용자 ID

  try {
    const result = await repository.leaveGroup(groupId, userId);
    if (result.affectedRows === 0) {
      return res.status(404).json({
        result: "fail",
        message: "그룹을 찾을 수 없거나, 이미 탈퇴한 상태입니다.",
      });
    }
    res.status(200).json({ result: "ok", message: "그룹에서 탈퇴하였습니다." });
  } catch (err) {
    console.error("Error leaving group:", err);
    res.status(500).json({ result: "fail", message: "오류가 발생했습니다." });
  }
};

// 그룹 삭제
exports.deleteGroup = async (req, res) => {
  const groupId = req.query.groupId;
  const userId = req.query.userId; // 로그인한 사용자 ID

  try {
    const result = await repository.deleteGroup(groupId, userId);
    if (!result.success) {
      return res.status(403).json({ result: "fail", message: result.message });
    }
    res.status(200).json({ result: "ok", message: "그룹이 삭제되었습니다." });
  } catch (err) {
    console.error("Error deleting group:", err);
    res
      .status(500)
      .json({ result: "fail", message: "서버 오류가 발생했습니다." });
  }
};

//그룹에 속한 식물 조회회
exports.getGroupPlants = async (req, res) => {
  const { groupId } = req.params;

  try {
    const plants = await repository.getGroupPlants(groupId);
    // console.log("Plants to be sent in response:", plants); // 응답으로 보낼 데이터 로그 출력

    if (!plants || plants.length === 0) {
      return res
        .status(404)
        .json({ result: "fail", message: "식물을 찾을 수 없습니다." });
    }
    const updatedPlants = plants.map((plant) => ({
      ...plant,
      last_watered_at: moment(plant.last_watered_at)
        .tz("Asia/Seoul")
        .format("YYYY-MM-DD HH:mm:ss"),
      created_at: moment(plant.created_at)
        .tz("Asia/Seoul")
        .format("YYYY-MM-DD HH:mm:ss"),
    }));

    console.log("Plants to be sent in response:", updatedPlants); // 응답으로 보낼 데이터 로그 출력

    res.status(200).json({ result: "ok", data: updatedPlants });
  } catch (err) {
    console.error("Error fetching group plants:", err);
    res.status(500).json({ result: "fail", message: "오류가 발생했습니다." });
  }
};
