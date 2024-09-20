const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  const SafeMath = await ethers.getContractFactory("SafeMath");
  await SafeMath.deploy();

  const DataTypes = await ethers.getContractFactory("DataTypes");
  await DataTypes.deploy();

  const Roles = await ethers.getContractFactory("Roles");
  await Roles.deploy();

  const MultiSigWallet = await ethers.getContractFactory("MultiSigWallet");
  await MultiSigWallet.deploy();

  const ZKVerifier = await ethers.getContractFactory("ZKVerifier");
  const zkVerifier = await ZKVerifier.deploy();
  console.log("ZKVerifier deployed to:", zkVerifier.address);

  const PriceOracle = await ethers.getContractFactory("PriceOracle");
  const priceOracle = await PriceOracle.deploy();
  console.log("PriceOracle deployed to:", priceOracle.address);

  const OffChainDataVerifier = await ethers.getContractFactory("OffChainDataVerifier");
  const offChainDataVerifier = await OffChainDataVerifier.deploy();
  console.log("OffChainDataVerifier deployed to:", offChainDataVerifier.address);

  const Token = await ethers.getContractFactory("Token");
  const token = await Token.deploy(ethers.utils.parseEther("1000000")); // 1 million tokens
  console.log("Token deployed to:", token.address);

  const Membership = await ethers.getContractFactory("Membership");
  const membership = await Membership.deploy();
  console.log("Membership deployed to:", membership.address);

  const AITracker = await ethers.getContractFactory("AITracker");
  const aiTracker = await AITracker.deploy(zkVerifier.address);
  console.log("AITracker deployed to:", aiTracker.address);

  const FundingContract = await ethers.getContractFactory("FundingContract");
  const fundingContract = await FundingContract.deploy(
    token.address, 
    membership.address, 
    priceOracle.address, 
    aiTracker.address, 
    offChainDataVerifier.address
  );
  console.log("FundingContract deployed to:", fundingContract.address);

  const Governance = await ethers.getContractFactory("Governance");
  const governance = await Governance.deploy(token.address, membership.address);
  console.log("Governance deployed to:", governance.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
