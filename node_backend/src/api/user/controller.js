//회원가입
exports.register = (req, res) => {
  res.send("User register");
};

//로그인
exports.login = (req, res) => {
  res.send("User login");
};

//마이페이지
exports.show = (req, res) => {
  res.send("User show");
};

//회원정보 수정
exports.profile = (req, res) => {
  res.send("User profile");
};

//회원탈퇴
exports.delete = (req, res) => {
  res.send("User 삭제");
};
