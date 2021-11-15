module.exports = task(
  "accounts",
  "Prints the list of accounts",
  async (taskArgs, { ethers }) => {
    (await ethers.getSigners()).forEach(({ address }) => console.log(address));
  }
);
