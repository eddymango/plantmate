require("dotenv").config();
const express = require("express");
const app = express();
const port = process.env.PORT || 3000;
const router = require("./src/router");
const bodyParser = require("body-parser");
const path = require("path");

// JSON 형식의 데이터 처리
app.use(bodyParser.json());
// URL-encoded 형식의 데이터 처리
app.use(bodyParser.urlencoded({ extended: true }));
app.use("/storage", express.static(path.join(__dirname, "storage")));

//라우터를 애플리케이션에 등록
app.use("/", router);

//서버 실행
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
