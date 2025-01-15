//식물 조회
exports.show = (req, res) => {
  res.send("Plant show");
};

//식물 추가
exports.register = (req, res) => {
  res.send("Plant register");
};

//식물 정보 수정
exports.update = (req, res) => {
  res.send("Plant update");
};

//식물 삭제
exports.delete = (req, res) => {
  res.send("Plant delete");
};

//식물 물주기
exports.water = (req, res) => {
  res.send("Plant water");
};
