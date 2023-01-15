const { network, ethers } = require("hardhat")
const { developmentChains, networkConfig } = require("../helper-hardhat-config")
const { verify } = require("../utils/verify")
const { storeImages, storeTokenUriMetadata } = require("../utils/uploadToPinata")
const { handleTokenUris } = require("../utils/createTokenURIs")

module.exports = async function ({ getNamedAccounts, deployments }) {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    let tokenUris = [
        "ipfs://QmUq49a6AipYFKUnwspAUmCBhPk1kENmSTtbMgr8QNYRDA",
        "ipfs://QmW9Bks8SCeAWp7MTb4K5HsFy3n4mRq1oPmfmQo9pcKQVb",
    ]

    if (process.env.UPLOAD_TO_PINATA == "true") {
        tokenUris = await handleTokenUris()
    }

    const args = [tokenUris, networkConfig[chainId].mintFee]

    const contractEthereal = await deploy("EtherealNFTs", {
        from: deployer,
        args: args,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })

    if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
        log("Verifying the contract...")
        await verify(contractEthereal.address, args)
    }
    log("===========")
}

module.exports.tags = ["all", "etherealNFTs", "main"]
