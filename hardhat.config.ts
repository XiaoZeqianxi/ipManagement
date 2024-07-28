import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomiclabs/hardhat-ethers";
import 'dotenv/config';

// const { SEPOLIA_URL, PRIVATE_KEY } = process.env;

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  networks: {
    sepolia: {
      url: "https://sepolia.infura.io/v3/a434ed4450b84df5a77dea6c087e4b43",
      accounts: ['0xd3701f0e7a3ad66b7b9c540b587033262710e79a341dca6cca2c5402b09edcd8']
    }
  }
};

export default config;
