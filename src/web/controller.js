exports.home = (req, res) => {
  res.send("애플리케이션 소개");
};

exports.page = (req, res) => {
  const route = req.params.route;

  if (route == "policy") {
    res.send("Policy page");
  }
  if (route == "term") {
    res.send("Term page");
  }
};
