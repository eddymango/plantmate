// 라우터를 별도 파일로 분리
// 로직 명확하게 분리
// 라우트끼리 모아 관리 가능

const express = require("express");
const router = express.Router();

const multer = require("multer");
const upload = multer({ dest: "storage/" });
const cors = require("cors");
const app = express();

app.use(cors()); // 모든 도메인에서의 요청을 허용

const webContoller = require("./web/controller");
const apiUserController = require("./api/user/controller");
const apiGroupController = require("./api/group/controller");
const apiPlantController = require("./api/plant/controller");
const authenticateToken = require("./middleware/authenticate");

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

//가입한 그룹 조회
router.get("/group", apiGroupController.show);
//새로운 그룹 생성
router.post("/group", apiGroupController.register);
//그룹 가입
router.post("/group/join", apiGroupController.join);
//그룹 탈퇴
router.delete("/group/leave", apiGroupController.leave);

//식물

//식물 조회
router.get("/groups/:groupId/plants", apiPlantController.show);
//식물 추가
router.post("/groups/:groupId/plants", apiPlantController.register);
//식물 정보 수정
router.put("/groups/:groupId/plants/:id", apiPlantController.update);
//식물 삭제
router.delete("/groups/:groupId/plants/:id", apiPlantController.delete);
//식물 물주기
router.put("/plant/:id/water", apiPlantController.water);

module.exports = router;
