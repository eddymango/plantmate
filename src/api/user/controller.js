const repository = require("./repository");
const crypto = require("crypto");
const jwt = require("./jwt");

//회원가입
exports.register = async (req, res) => {
  const { email, password, name } = req.body;

  //이메일 중복 확인
  const { count: emailCount } = await repository.findByEmail(email);
  if (emailCount > 0) {
    return res
      .status(400)
      .json({ result: "fail", message: "중복된 이메일이 존재합니다." });
  }

  //비밀번호 암호화
  // const hashedPassword = crypto
  //   .pbkdf2Sync(password, process.env.SALT_KEY, 50, 100, "sha512")
  //   .toString("base64");

  //사용자 등록
  const { affectedRows, insertId } = await repository.register(
    email,
    password,
    name
  );
  if (affectedRows > 0) {
    const token = await jwt({ id: insertId, name });
    res.status(201).json({ result: "ok", access_token: token });
  } else {
    res
      .status(500)
      .json({ result: "fail", message: "사용자 등록에 실패했습니다." });
  }
};

//로그인
exports.login = async (req, res) => {
  const { email, password } = req.body;

  //비밀번호 암호화 후 비교
  // const hashedPassword = await crypto.pbkdf2Sync(password, process.env.SALT_KEY, 50, 100, "sha512").toString("base64");

  const user = await repository.login(email, password);
  if (!user) {
    res.status(401).json({
      result: "fail",
      message: "이메일 혹은 비밀번호를 확인해 주세요.",
    });
  } else {
    const token = await jwt({ id: user.id, name: user.name });
    res.status(200).json({
      result: "ok",
      access_token: token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
      },
    });
  }
};

//마이페이지
exports.show = (req, res) => {
  res.send("User show");
};

//회원정보 수정
exports.update = async (req, res) => {
  const { id, name, password } = req.body;
  // const user = req.user;

  //비밀번호 암호화
  // let hashedPassword = null;
  // if (password) {
  //   hashedPassword = crypto
  //     .pbkdf2Sync(password, process.env.SALT_KEY, 50, 100, "sha512")
  //     .toString("base64");
  // }

  //사용자 정보 수정
  const result = await repository.update(id, name, password);
  if (result.affectedRows > 0) {
    const updatedUser = await repository.findById(id);
    res.status(200).json({ result: "ok", data: updatedUser });
  } else {
    res
      .status(500)
      .json({ result: "fail", message: "사용자 정보 수정에 실패했습니다." });
  }
};

//회원탈퇴
exports.delete = async (req, res) => {
  const id = req.params.id;

  //사용자 삭제
  const result = await repository.delete(id);
  if (result.affectedRows > 0) {
    res
      .status(200)
      .json({ result: "ok", message: "회원탈퇴가 완료되었습니다." });
  } else {
    res
      .status(500)
      .json({ result: "fail", message: "회원탈퇴에 실패했습니다." });
  }
};
