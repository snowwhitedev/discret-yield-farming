// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.

const hre = require('hardhat');
const { ethers } = require("hardhat");
const { getBigNumber } = require("./shared/utilities");

async function main() {
  const FACTORY_ADDRESS = "0x35C581b2B121086530e9E664617710c6d1d45CC8";
  const FEE_TOKEN_ADDRESS = '0xc20d9bd10Fe015C9d1a69B2A5739B248fab7f8e7';
  const factoryContract = await ethers.getContractAt('StakingRewardsFactory', FACTORY_ADDRESS);

  // Deploy new StakingRewards Arguments
  const stakingToken = "0xa37eb8fe910a00f973e0913024f631ed387ee512"; // DAI mock token
  const rewardAmount = getBigNumber(100000);
  const rewardsDuration = 15 * 24 * 3600; // 15 days

  console.log('Deploying new staking rewards');
  const deployTx = await factoryContract.deploy(stakingToken, rewardAmount, rewardsDuration);

  console.log('deployTx', deployTx.hash);

  const newAddress = (await deployTx.wait()).events[0].args.stakingRewards;
  console.log(`New StakingRewards was deployed at ${newAddress} on rinkeby testnet`);

  // console.log('Sleeping 10 seconds');
  // for(let ii =0; ii <10000000; ii++){}
  // // try verifying after 10 seconds
  // await hre.run('verify:verify', {
  //   address: newAddress,
  //   constructorArguments: [
  //     FACTORY_ADDRESS,
  //     FEE_TOKEN_ADDRESS,
  //     stakingToken
  //   ]
  // });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
