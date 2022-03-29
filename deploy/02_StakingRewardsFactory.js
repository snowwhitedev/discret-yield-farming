// Defining bytecode and abi from original contract on mainnet to ensure bytecode matches and it produces the same pair code hash

module.exports = async function ({ ethers, getNamedAccounts, deployments, getChainId }) {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  
  const stakingRewardsGenesis = 10000;
  const rewardToken = await deployments.get('FeeToken');
  await deploy('StakingRewardsFactory', {
    from: deployer,
    log: true,
    args: [rewardToken.address, stakingRewardsGenesis],
    deterministicDeployment: false
  });
};

module.exports.tags = ['StakingRewardsFactory'];
module.exports.dependencies = ["FeeToken"];
