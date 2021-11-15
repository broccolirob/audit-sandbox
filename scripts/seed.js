const hre = require("hardhat");

async function main() {
  const greeter = await hre.ethers.getContract("Greeter");
  console.log("Currently set greeting:", await greeter.greet());

  await greeter.setGreeting("Seeded with a new greeting");

  console.log("Changed greeting to:", await greeter.greet());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
