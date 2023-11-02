import { ethers } from "hardhat";

const ERC20_ADDR = '0x0000000000000000000100000000000000000000';

async function main() {
  const MD = await ethers.getContractFactory("MerkleDistribute");
  const md = await MD.deploy(ERC20_ADDR);

  await md.deployed()
  const receipt = await md.deployTransaction.wait();

  console.log(`deployed to ${md.address}`);
  console.log(receipt)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
