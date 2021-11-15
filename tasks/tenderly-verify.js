module.exports = task(
  "tenderly-verify",
  "Verifies and uploads contracts to Tenderly",
  async (_, { network, tenderly, deployments }) => {
    if (["hardhat", "localhost"].includes(network.name)) {
      throw Error("Tenderly verification is not available on local networks.");
    }
    const deps = await deployments.all();
    const contractNames = Object.keys(deps);
    const contracts = contractNames.map((name) => ({
      name,
      network: network.name,
      address: deps[name].address,
    }));
    console.log("Verifying and pushing the following contracts:", contracts);
    await tenderly.verify(...contracts);
    await tenderly.push(...contracts);
  }
);
