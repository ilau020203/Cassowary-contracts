const Cassowary = artifacts.require("Cassowary");

module.exports = function(deployer) {
  deployer.deploy(Cassowary);
};
