import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const networkCommon = {
  url: 'http://127.0.0.1:8545',
  accounts: {
    mnemonic: 'fox sight canyon orphan hotel grow hedgehog build bless august weather swarm',
    path: 'm/44\'/60\'/0\'/0',
  },
};

const config: HardhatUserConfig = {
  solidity: "0.8.22",
  networks: {
    mandala: {
      ...networkCommon,
      chainId: 595,
    },
    mandalaPub: {
      ...networkCommon,
      url: 'https://eth-rpc-tc9.aca-staging.network',
      chainId: 595,
    },
    karura: {
      ...networkCommon,
      chainId: 686,
    },
    acala: {
      ...networkCommon,
      chainId: 787,
    },
  },
};

export default config;
