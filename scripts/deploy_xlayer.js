// scripts/deploy_xlayer.js
// One-click deployment script for OKX Onchain OS (X Layer)
const hre = require("hardhat");

async function main() {
  console.log("Initiating deployment to OKX X Layer...");
  
  const LobsterEscrow = await hre.ethers.getContractFactory("LobsterEscrow");
  const escrow = await LobsterEscrow.deploy();

  await escrow.deployed();

  console.log(`✅ [SUCCESS] LobsterEscrow deployed to X Layer Mainnet!`);
  console.log(`🔗 Contract Address: ${escrow.address}`);
  console.log(`🛡️  zk-Claw Oracle assigned to deployer: ${await escrow.arbiterEngine()}`);
  console.log(`Explore on OKX: https://www.okx.com/web3/explorer/xlayer/address/${escrow.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
