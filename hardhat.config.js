require("@nomiclabs/hardhat-waffle");
require("dotenv").config();
require("@nomiclabs/hardhat-etherscan");
// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html

module.exports = {
  solidity: "0.8.10",
  networks: {
    mumbai: {
      url: process.env.TESTNET_RPC,
      accounts: [process.env.PRIVATE_KEY]
    },
  },
  etherscan: {
    apiKey: process.env.POLYGONSCAN_API_KEY
  }
};
