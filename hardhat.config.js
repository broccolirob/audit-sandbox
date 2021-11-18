require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-waffle");
require("@tenderly/hardhat-tenderly");
require("hardhat-gas-reporter");
require("hardhat-deploy");
require("solidity-coverage");
require("hardhat-docgen");
require("./tasks/accounts");
require("./tasks/balance");
require("./tasks/block-number");
require("./tasks/tenderly-verify");

require("dotenv").config();

const {
  INFURA_ID,
  MNEMONIC,
  ALCHEMY_MAINNET_FORK,
  ETHERSCAN_KEY,
  REPORT_GAS,
  TENDERLY_PROJECT,
  TENDERLY_USERNAME,
  NETWORK,
  COINMARKETCAP_KEY,
} = process.env;

module.exports = {
  solidity: {
    compilers: [{ version: "0.6.6" }],
  },
  defaultNetwork: NETWORK,
  networks: {
    hardhat: {
      forking: {
        url: `https://eth-mainnet.alchemyapi.io/v2/${ALCHEMY_MAINNET_FORK}`,
      },
    },
    localhost: {
      url: "http://localhost:8545",
    },
    mainnet: {
      url: `https://mainnet.infura.io/v3/${INFURA_ID}`,
      accounts: {
        mnemonic: MNEMONIC,
      },
      chainId: 1,
    },
    ropsten: {
      url: `https://ropsten.infura.io/v3/${INFURA_ID}`,
      accounts: {
        mnemonic: MNEMONIC,
      },
      chainId: 3,
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${INFURA_ID}`,
      accounts: {
        mnemonic: MNEMONIC,
      },
      chainId: 4,
    },
    goerli: {
      url: `https://goerli.infura.io/v3/${INFURA_ID}`,
      accounts: {
        mnemonic: MNEMONIC,
      },
      chainId: 5,
    },
    kovan: {
      url: `https://kovan.infura.io/v3/${INFURA_ID}`,
      accounts: {
        mnemonic: MNEMONIC,
      },
      chainId: 42,
    },
    polygonMainnet: {
      url: `https://polygon-mainnet.infura.io/v3/${INFURA_ID}`,
      accounts: {
        mnemonic: MNEMONIC,
      },
      chainId: 137,
    },
    polygonMumbai: {
      url: `https://polygon-mumbai.infura.io/v3/${INFURA_ID}`,
      accounts: {
        mnemonic: MNEMONIC,
      },
      chainId: 80001,
    },
    arbitrumMainnet: {
      url: `https://arbitrum-mainnet.infura.io/v3/${INFURA_ID}`,
      accounts: {
        mnemonic: MNEMONIC,
      },
      chainId: 42161,
    },
    arbitrumRinkeby: {
      url: `https://arbitrum-rinkeby.infura.io/v3/${INFURA_ID}`,
      accounts: {
        mnemonic: MNEMONIC,
      },
      chainId: 421611,
    },
    optimismMainnet: {
      url: `https://optimism-mainnet.infura.io/v3/${INFURA_ID}`,
      accounts: {
        mnemonic: MNEMONIC,
      },
      chainId: 10,
    },
    optimismKovan: {
      url: `https://optimism-kovan.infura.io/v3/${INFURA_ID}`,
      accounts: {
        mnemonic: MNEMONIC,
      },
      chainId: 69,
    },
  },
  namedAccounts: {
    deployer: {
      default: 0,
    },
    bob: {
      default: 1, // generic participant 'a'
    },
    alice: {
      default: 2, // generic participant 'b'
    },
    chad: {
      default: 3, // generic participant 'c'
    },
    frank: {
      default: 4, // generic participant 'd'
    },
    eve: {
      default: 5, // passive attacker
    },
    mallory: {
      default: 6, // malicious attacker
    },
    olivia: {
      default: 7, // oracle
    },
  },
  gasReporter: {
    enabled: REPORT_GAS !== undefined,
    coinmarketcap: COINMARKETCAP_KEY,
    currency: "USD",
  },
  etherscan: {
    apiKey: ETHERSCAN_KEY,
  },
  tenderly: {
    project: TENDERLY_PROJECT,
    username: TENDERLY_USERNAME,
  },
  docgen: {
    path: "./docs",
    clear: true,
    except: [],
  },
  mocha: {
    timeout: 100000,
  },
  paths: {
    sources: "./contracts/fei-protocol",
  },
};
