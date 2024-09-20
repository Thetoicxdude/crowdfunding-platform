const FundingContract = artifacts.require("FundingContract");
const Governance = artifacts.require("Governance");
const Token = artifacts.require("Token");
const AITracker = artifacts.require("AITracker");
const ZKVerifier = artifacts.require("ZKVerifier");
const Membership = artifacts.require("Membership");
const PriceOracle = artifacts.require("PriceOracle");
const OffChainDataVerifier = artifacts.require("OffChainDataVerifier");

module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(SafeMath);
  await deployer.deploy(DataTypes);
  await deployer.deploy(Roles);
  await deployer.deploy(MultiSigWallet);

  const zkVerifier = await deployer.deploy(ZKVerifier);
  const priceOracle = await deployer.deploy(PriceOracle);
  const offChainDataVerifier = await deployer.deploy(OffChainDataVerifier);

  const token = await deployer.deploy(Token, "1000000000000000000000000"); // 1 million tokens

  const membership = await deployer.deploy(Membership);

  const aiTracker = await deployer.deploy(AITracker, zkVerifier.address);

  const fundingContract = await deployer.deploy(
    FundingContract, 
    token.address, 
    membership.address, 
    priceOracle.address, 
    aiTracker.address, 
    offChainDataVerifier.address
  );

  const governance = await deployer.deploy(Governance, token.address, membership.address);

  console.log({
    FundingContract: fundingContract.address,
    Governance: governance.address,
    Token: token.address,
    AITracker: aiTracker.address,
    ZKVerifier: zkVerifier.address,
    Membership: membership.address,
    PriceOracle: priceOracle.address,
    OffChainDataVerifier: offChainDataVerifier.address
  });
};
