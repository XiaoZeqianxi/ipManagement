// scripts/deploy.ts
import { ethers } from "hardhat";

async function main() {
  const ipManage = await ethers.getContractFactory("ipManage");
  const ipManagement = await ipManage.deploy();

  console.log("Deploying contract...");
  await ipManagement.deployed();
  console.log("Contract deployed to address:", ipManagement.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
