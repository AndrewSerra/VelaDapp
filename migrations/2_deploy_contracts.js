const Store = artifacts.require("Store");
const TimeWiz = artifacts.require("TimeWiz");

module.exports = function (deployer) {
  deployer.deploy(Store, "Vela", "A test store for Vela Dapp");
  deployer.deploy(TimeWiz);
};