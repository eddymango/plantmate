//가입 그룹 조회
exports.show = (req, res) => {
  res.send("Group show");
};

//새로운 그룹 생성
exports.register = (req, res) => {
  res.send("Group register");
};

//그룹 가입
exports.join = (req, res) => {
  res.send("Group join");
};

//그룹 탈퇴퇴
exports.leave = (req, res) => {
  res.send("Group leave");
};
