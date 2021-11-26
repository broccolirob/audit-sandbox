# Audit Findings 101

### Checklists

- [Block One: 1 - 20](./checklist/block-one.md)
- [Block Two: 21 - 40](./checklist/block-two.md)
- [Block Three: 41 - 60](./checklist/block-three.md)
- [Block Four: 61 - 80](./checklist/block-four.md)
- [Block Five: 81 - 101](./checklist/block-five.md)

### Subtopics

- [Access Controls]() - Related to authorization of users and assessment of rights
- [Auditing and Logging]() - Related to auditing of actions or logging of problems
- [Authentication]() - Related to the identification of users
- [Code Quality]()
- [Coding Bug]()
- [Configuration]() - Related to security configurations of servers, devices or software
- [Cryptography]() - Related to protecting the privacy or integrity of data
- [Data Exposure]() - Related to unintended exposure of sensitive information
- [Data Validation]() - Related to improper reliance on the structure or values of data
- [Denial of Service]() - Related to causing system failure
- [Documentation]()
- [Error Reporting]() - Related to the reporting of error conditions in a secure fashion
- [Logic Errors]()
- [Numerics]()
- [Patching]() - Related to keeping software up to date
- [Session Management]() - Related to the identification of authenticated users
- [Race-condition and Front-running]()
- [Reentrancy]()
- [Timing]() - Related to race conditions, locking or order of operations
- [Undefined Behavior]() - Related to undefined behavior triggered by the program

### Audited Protocols

- [Aave Protocol V2](https://consensys.net/diligence/audits/2020/09/aave-protocol-v2/)
  - 5.4 Unhandled return values of `transfer` and `transferFrom` - Medium
- [DeFi Saver](https://consensys.net/diligence/audits/2021/03/defi-saver/)
  - 5.1 Random task execution - Critical
  - 5.2 Tokens with more than 18 decimal points will cause issues - Major
  - 5.3 Error codes of Compound's `Comptroller.enterMarket`, `Comptroller.exitMarket` are not checked - Major
  - 5.4 Reversed order of parameters in `allowance` function call - Medium
- [DAOfi](https://consensys.net/diligence/audits/2021/02/daofi/)
  - 4.1 Token approvals can be stolen in `DAOfiV1Router01.addLiquidity()` - Critical
  - 4.4 The `swapExactTokensForETH` checks the wrong return value - Major
  - 4.5 `DAOfiV1Pair.deposit()` accepts deposits of zero, blocking the pool - Medium
- [Fei Protocol](https://consensys.net/diligence/audits/2021/01/fei-protocol/)
  - 3.1 `GenesisGroup.commit` overwrites previously-committed values - Critical
  - 3.2 Purchasing and committing still possible after launch - Critical
  - 3.3 `UniswapIncentive` overflow on pre-transfer hooks - Major
  - 3.4 `BondingCurve` allows users to acquire FEI before launch - Medium
  - 3.5 `Timed.isTimeEnded` returns `true` if the timer has not been initialized - Medium
  - 3.6 Overflow/underflow protection - Medium
  - 3.7 Unchecked return value for `IWETH.transfer` call - Medium
  - 3.8 `GenesisGroup.emergencyExit` remains functional after launch - Medium
- [bitbank](https://consensys.net/diligence/audits/2020/11/bitbank/)
  - 5.1 ERC20 tokens with no return value will fail to transfer - Major
- [Metaswap](https://consensys.net/diligence/audits/2020/08/metaswap/)
  - 4.1 Reentrancy vulnerability in `MetaSwap.swap()` - Major
  - 4.2 A new malicious adapter can access users' tokens - Medium
  - 4.3 Owner can front-run traders by updating adapters - Medium
- [mStable 1.1](https://consensys.net/diligence/audits/2020/07/mstable-1.1/)
- [Bancor V2 AMM](https://consensys.net/diligence/audits/2020/06/bancor-v2-amm-security-audit/)
- [Shell Protocol](https://consensys.net/diligence/audits/2020/06/shell-protocol/)
- [Lien Protocol](https://consensys.net/diligence/audits/2020/05/lien-protocol/)
- [The LAO](https://consensys.net/diligence/audits/2020/01/the-lao/)
- [Origin Dollar](https://github.com/trailofbits/publications/blob/master/reviews/OriginDollar.pdf)
- [Yield Protocol](https://github.com/trailofbits/publications/blob/master/reviews/YieldProtocol.pdf)
- [Hermez](https://github.com/trailofbits/publications/blob/master/reviews/hermez.pdf)
- [Uniswap V3](https://github.com/Uniswap/v3-core/blob/main/audits/tob/audit.pdf)
- [DFX Finance](https://github.com/dfx-finance/protocol/blob/main/audits/2021-05-03-Trail_of_Bits.pdf)
- [0x Protocol](https://github.com/trailofbits/publications/blob/master/reviews/0x-protocol.pdf)
- [Synthetix EtherCollateral](https://github.com/sigp/public-audits/blob/master/synthetix/ethercollateral/review.pdf)
- [InfiniGold](https://github.com/sigp/public-audits/blob/master/infinigold/review.pdf)
- [Synthetix Unipool](https://github.com/sigp/public-audits/blob/master/synthetix/unipool/review.pdf)
- [Chainlink](https://github.com/sigp/public-audits/blob/master/chainlink-1/review.pdf)
- [UMA Phase 4](https://blog.openzeppelin.com/uma-audit-phase-4/)
- [1inch Liquidity Protocol](https://blog.openzeppelin.com/1inch-liquidity-protocol-audit/)
- [Futureswap V2](https://blog.openzeppelin.com/futureswap-v2-audit/)
- [Notional Protocol](https://blog.openzeppelin.com/notional-audit/)
- [GEB Protocol](https://blog.openzeppelin.com/geb-protocol-audit/)
- [1inch Exchange Audit](https://blog.openzeppelin.com/1inch-exchange-audit/)
- [Opyn Gamma Protocol](https://blog.openzeppelin.com/opyn-gamma-protocol-audit/)
- [Endaoment](https://blog.openzeppelin.com/endaoment-audit/)
- [Audius](https://blog.openzeppelin.com/audius-contracts-audit/)
- [Primitive](https://blog.openzeppelin.com/primitive-audit/)
- [ACO Protocol](https://blog.openzeppelin.com/aco-protocol-audit/)
- [Compound Open Price Feed](https://blog.openzeppelin.com/compound-open-price-feed-uniswap-integration-audit/)
- [MCDEX Mai Protocol](https://blog.openzeppelin.com/mcdex-mai-protocol-audit/)
- [UMA Phase 1](https://blog.openzeppelin.com/uma-audit-phase-1/)
