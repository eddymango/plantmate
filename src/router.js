// 라우터를 별도 파일로 분리
// 로직 명확하게 분리
// 라우트끼리 모아 관리 가능

const express = require("express");
const router = express.Router();

const multer = require("multer");
const cors = require("cors");
const app = express();
const path = require("path");

app.use(cors()); // 모든 도메인에서의 요청을 허용
app.use("/storage", express.static(path.join(__dirname, "storage")));

const webContoller = require("./web/controller");
const apiUserController = require("./api/user/controller");
const apiGroupController = require("./api/group/controller");
const apiPlantController = require("./api/plant/controller");
const authenticateToken = require("./middleware/authenticate");

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "storage/");
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
    cb(null, uniqueSuffix + "-" + file.originalname);
  },
});
const upload = multer({ storage: storage });

router.get("/", webContoller.home);
router.get("/page/:route", webContoller.page);

//파일 업로드
router.post("/file", upload.single("file"), (req, res) => {
  console.log(req.file);
  res.json(req.file);
});

//사용자
router.post("/user/register", apiUserController.register); //회원가입
router.post("/user/login", apiUserController.login); //로그인

// router.use(authenticateToken); //토큰 검증

router.put("/user/profile", apiUserController.update); //회원정보 수정
router.delete("/user/profile/:id", apiUserController.delete); //회원탈퇴

//그룹

//그룹
router.post("/groups", apiGroupController.createGroup); //그룹 생성
router.get("/groups", apiGroupController.getAllGroups); //전체 그룹 조회
router.get("/groups/:groupId", apiGroupController.getGroupById); //특정 그룹 조회
router.post("/groups/join", apiGroupController.joinGroup); //그룹 가입
router.delete("/groups/leave/:groupId", apiGroupController.leaveGroup); //그룹 탈퇴
router.delete("/groups", apiGroupController.deleteGroup); //그룹 삭제
router.get("/groups/:groupId/plants", apiGroupController.getGroupPlants); //그룹 식물 조회

//식물
//식물 추가
router.post("/plants", upload.single("photo_url"), apiPlantController.addPlant);
//식물 수정
router.put(
  "/plants/:id",
  upload.single("photo_url"),
  apiPlantController.updatePlant
);
//식물 삭제
router.delete("/plants/:id", apiPlantController.deletePlant);
//식물 조회
router.get("/plants/:id", apiPlantController.getPlant);
//식물 물주기
router.post("/plants/:id/water", apiPlantController.waterPlant);
//물주기 주기 계산
router.get(
  "/plants/:id/watering-schedule",
  apiPlantController.getWateringSchedule
);

module.exports = router;
