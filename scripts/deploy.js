const hre = require("hardhat");

async function main() {
  const voting = await hre.ethers.deployContract("Voting");
  await voting.waitForDeployment();
  console.log(`Contract deployed to ${voting.target} `)
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});