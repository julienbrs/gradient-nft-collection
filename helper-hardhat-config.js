const { ethers } = require("hardhat")

const networkConfig = {
    5: {
        name: "goerli",
        mintFee: "5000000000000000", // = 0.005 ETH
        waitConfirmations: "3",
    },
    31337: {
        name: "localhost",
        mintFee: "10000000000000000", // = 0.01 ETH
    },
    1337: {
        name: "hardhat",
        mintFee: "10000000000000000", // = 0.01 ETH
    },
}

const developmentChains = ["hardhat", "localhost"]

module.exports = {
    networkConfig,
    developmentChains,
}
