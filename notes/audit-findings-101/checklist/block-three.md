# Block Three: 41 - 60

## 41. OUSD total supply can be arbitrary, even smaller than user balances

[High Risk - Origin Dollar](https://github.com/trailofbits/publications/blob/master/reviews/OriginDollar.pdf)

The OUSD token contract allows users to opt out of rebasing effects. At that point, their exchange rate is “fixed”, and further rebases will not have an impact on token balances (until the user opts in).

### Recommendation

Short term, we would advise making clear all common invariant violations for users and other stakeholders. Long term, we would recommend designing the system in such a way to preserve as many commonplace invariants as possible.

## 42. Flash minting can be used to redeem `fyDAI`

[Medium Risk - Yield Protocol](https://github.com/trailofbits/publications/blob/master/reviews/YieldProtocol.pdf)

The flash-minting feature from the `fyDAI` token can be used to redeem an arbitrary amount of funds from a mature token.

### Recommendation

Short term, disallow calls to `redeem` in the `YDai` and `Unwind` contracts during flash minting. Long term, do not include operations that allow any user to manipulate an arbitrary amount of funds, even if it is in a single transaction. This will prevent attackers from gaining leverage to manipulate the market and break internal invariants.

## 43. Lack of `chainID` validation allows signatures to be re-used across forks

[High Risk - Yield Protocol](https://github.com/trailofbits/publications/blob/master/reviews/YieldProtocol.pdf)

`yDai` implements the draft ERC 2612 via the `ERC20Permit` contract it inherits from. This allows a third party to transmit a signature from a token holder that modifies the ERC20 allowance for a particular user. These signatures used in calls to `permit` in `ERC20Permit` do not account for chain splits. The `chainID` is included in the domain separator. However, it is not updatable and not included in the signed data as part of the `permit` call. As a result, if the chain forks after deployment, the signed message may be considered valid on both forks.

### Recommendation

Short term, include the `chainID` opcode in the `permit` schema. This will make replay attacks impossible in the event of a post-deployment hard fork. Long term, document and carefully review any signature schemas, including their robustness to replay on different wallets, contracts, and blockchains. Make sure users are aware of signing best practices and the danger of signing messages from untrusted sources.

## 44. Lack of a contract existence check allows token theft

[High Risk - Hermez](https://github.com/trailofbits/publications/blob/master/reviews/hermez.pdf)

Since there’s no existence check for contracts that interact with external tokens, an attacker can steal funds by registering a token that’s not yet deployed. `_safeTransferFrom` will return success even if the token is not yet deployed, or was self-destructed. An attacker that knows the address of a future token can register the token in Hermez, and deposit any amount prior to the token deployment. Once the contract is deployed and tokens have been deposited in Hermez, the attacker can steal the funds. The address of a contract to be deployed can be determined by knowing the address of its deployer.

### Recommendation

Short term, check for contract existence in `_safeTransferFrom`. Add a similar check for any low-level calls, including in `WithdrawalDelayer`. This will prevent an attacker from listing and depositing tokens in a contract that is not yet deployed. Long term, carefully review the Solidity documentation, especially the Warnings section. The Solidity documentation warns: The low-level `call`, `delegatecall` and `callcode` will return success if the called account is non-existent, as part of the design of EVM. Existence must be checked prior to calling if desired.

## 45. No incentive for bidders to vote early

[Medium Risk - Hermez](https://github.com/trailofbits/publications/blob/master/reviews/hermez.pdf)

Hermez relies on a voting system that allows anyone to vote with any weight at the last minute. As a result, anyone with a large fund can manipulate the vote. Hermez’s voting mechanism relies on bidding. There is no incentive for users to bid tokens well before the voting ends. Users can bid a large amount of tokens just before voting ends, and anyone with a large fund can decide the outcome of the vote. As all the votes are public, users bidding earlier will be penalized, because their bids will be known by the other participants. An attacker can know exactly how much currency will be necessary to change the outcome of the voting just before it ends.

### Recommendation

Short term, explore ways to incentivize users to vote earlier. Consider a weighted bid, with a weight decreasing over time. While it won’t prevent users with unlimited resources from manipulating the vote at the last minute, it will make the attack more expensive and reduce the chance of vote manipulation. Long term, stay up to date with the latest research on blockchain-based online voting and bidding. Blockchain-based online voting is a known challenge. No perfect solution has been found yet.

## 46. Lack of access control separation is risky

[High Risk - Hermez](https://github.com/trailofbits/publications/blob/master/reviews/hermez.pdf)

The system uses the same account to change both frequently updated parameters and those that require less frequent updates. This architecture is error-prone and increases the severity of any privileged account compromises.

### Recommendation

Short term, use a separate account to handle updating the tokens/USD ratio. Using the same account for the critical operations and update the tokens/USD ratio increases underlying risks. Long term, document the access controls and set up a proper authorization architecture. Consider the risks associated with each access point and their frequency of usage to evaluate the proper design.

## 47. Lack of two-step procedure for critical operations leaves them error-prone

[High Risk - Hermez](https://github.com/trailofbits/publications/blob/master/reviews/hermez.pdf)

Several critical operations are done in one function call. This schema is error-prone and can lead to irrevocable mistakes. For example, the setter for the whitehack group address sets the address to the provided argument. If the address is incorrect, the new address will take on the functionality of the new role immediately. However, a two-step process is similar to the `approve-transferFrom` functionality: The contract approves the new address for a new role, and the new address acquires the role by calling the contract.

### Recommendation

Short term, use a two-step procedure for all non-recoverable critical operations to prevent irrecoverable mistakes. Long term, identify and document all possible actions and their associated risks for privileged accounts. Identifying the risks will assist codebase review and prevent future mistakes.

## 48. Initialization functions can be front-run

[High Risk - Hermez](https://github.com/trailofbits/publications/blob/master/reviews/hermez.pdf)

`Hermez`, `HermezAuctionProtocol`, and `WithdrawalDelayer` have initialization functions that can be front-run, allowing an attacker to incorrectly initialize the contracts. Due to the use of the `delegatecall` proxy pattern, `Hermez`, `HermezAuctionProtocol`, and `WithdrawalDelayer` cannot be initialized with a constructor, and have initializer functions. All these functions can be front-run by an attacker, allowing them to initialize the contracts with malicious values.

### Recommendation

Short term, either: 1) Use a factory pattern that will prevent front-running of the initialization, or 2) Ensure the deployment scripts are robust in case of a front-running attack. Carefully review the Solidity documentation, especially the Warnings section. Carefully review the pitfalls of using `delegatecall` proxy pattern.

## 49. Missing validation of `_owner` argument could indefinitely lock owner role

[Medium Risk - Uniswap V3](https://github.com/Uniswap/v3-core/blob/main/audits/tob/audit.pdf)

A lack of input validation of the `_owner` argument in both the `constructor` and `setOwner` functions could permanently lock the owner role, requiring a costly redeploy. To resolve an incorrect owner issue, Uniswap would need to redeploy the factory contract and re-add pairs and liquidity. Users might not be happy to learn of these actions, which could lead to reputational damage. Certain users could also decide to continue using the original factory and pair contracts, in which owner functions cannot be called. This could lead to the concurrent use of two versions of Uniswap, one with the original factory contract and no valid owner and another in which the owner was set correctly. Trail of Bits identified four distinct cases in which an incorrect owner is set: 1) Passing `address(0)` to the `constructor` 2) Passing `address(0)` to the `setOwner` function 3) Passing an incorrect address to the `constructor` 4) Passing an incorrect address to the `setOwner` function.

### Recommendation

Several improvements could prevent the four above mentioned cases: 1) Designate `msg.sender` as the initial owner, and transfer ownership to the chosen owner after deployment. 2) Implement a two-step ownership-change process through which the new owner needs to accept ownership. 3) If it needs to be possible to set the owner to `address(0)`, implement a `renounceOwnership` function.

## 50. Incorrect comparison enables swapping and token draining at no cost

[High Risk - Uniswap V3](https://github.com/Uniswap/v3-core/blob/main/audits/tob/audit.pdf)

An incorrect comparison in the `swap` function allows the swap to succeed even if no tokens are paid. This issue could be used to drain any pool of all of its tokens at no cost. The `swap` function calculates how many tokens the initiator (`msg.sender`) needs to pay (`amountIn`) to receive the requested amount of tokens (`amountOut`). It then calls the `uniswapV3SwapCallback` function on the initiator’s account, passing in the amount of tokens to be paid. The callback function should then transfer at least the requested amount of tokens to the pool contract. Afterward, a `require` inside the `swap` function verifies that the correct amount of tokens (`amountIn`) has been transferred to the pool. However, the check inside the require is incorrect. The operand used is >= instead of <=.

### Recommendation

Replace >= with <= in the `require` statement in the `swap` function.

## 51. Unbound loop enables denial of service

[Medium Risk - Uniswap V3](https://github.com/Uniswap/v3-core/blob/main/audits/tob/audit.pdf)

The `swap` function relies on an unbounded loop. An attacker could disrupt swap operations by forcing the loop to go through too many operations, potentially trapping the swap due to a lack of gas.

### Recommendation

Bound the loops and document the bounds.

## 52. Front-running pool’s initialization can lead to draining of liquidity provider’s initial deposits

[Medium Risk - Uniswap V3](https://github.com/Uniswap/v3-core/blob/main/audits/tob/audit.pdf)

A front-run on `UniswapV3Pool.initialize` allows an attacker to set an unfair price and to drain assets from the first deposits. There are no access controls on the initialize function, so anyone could call it on a deployed pool. Initializing a pool with an incorrect price allows an attacker to generate profits from the initial liquidity provider’s deposits.

### Recommendation

Short term, consider 1) moving the price operations from initialize to the constructor, 2) adding access controls to initialize, or 3) ensuring that the documentation clearly warns users about incorrect initialization.

## 53. Swapping on zero liquidity allows for control of the pool's price

[Medium Risk - Uniswap V3](https://github.com/Uniswap/v3-core/blob/main/audits/tob/audit.pdf)

Swapping on a tick with zero liquidity enables a user to adjust the price of 1 wei of tokens in any direction. As a result, an attacker could set an arbitrary price at the pool’s initialization or if the liquidity providers withdraw all of the liquidity for a short time.

### Recommendation

No straightforward way to prevent the issue. Ensure pools don’t end up in unexpected states. Warn users of potential risks.

## 54. Failed transfer may be overlooked due to lack of contract existence check

[High Risk - Uniswap V3](https://github.com/Uniswap/v3-core/blob/main/audits/tob/audit.pdf)

Because the pool fails to check that a contract exists, the pool may assume that failed transactions involving destructed tokens are successful. `TransferHelper.safeTransfer` performs a transfer with a low-level call without confirming the contract’s existence. As a result, if the tokens have not yet been deployed or have been destroyed, `safeTransfer` will return success even though no transfer was executed.

### Recommendation

Short term, check the contract’s existence prior to the low-level call in `TransferHelper.safeTransfer`. Long term, avoid low-level calls.

## 55. Use of undefined behavior in equality check

[High Risk - DFX Finance](https://github.com/dfx-finance/protocol/blob/main/audits/2021-05-03-Trail_of_Bits.pdf)

On the left-hand side of the equality check, there is an assignment of the variable `outputAmt_`. The right-hand side uses the same variable. The Solidity 0.7.3. documentation states that “The evaluation order of expressions is not specified (more formally, the order in which the children of one node in the expression tree are evaluated is not specified, but they are of course evaluated before the node itself). It is only guaranteed that statements are executed in order and short-circuiting for boolean expressions is done” which means that this check constitutes an instance of undefined behavior. As such, the behavior of this code is not specified and could change in a future release of Solidity.

### Recommendation

Short term, rewrite the if statement such that it does not use and assign the same variable in an equality check. Long term, ensure that the codebase does not contain undefined Solidity or EVM behavior.

## 56. Assimilators' balance functions return raw values

[High Risk - DFX Finance](https://github.com/dfx-finance/protocol/blob/main/audits/2021-05-03-Trail_of_Bits.pdf)

The system converts raw values to numeraire values for its internal arithmetic. However, in one instance it uses raw values alongside numeraire values. Interchanging raw and numeraire values will produce unwanted results and may result in loss of funds for liquidity provider.

### Recommendation

Short term, change the semantics of the three functions listed above in the CADC, XSGD, and EURS assimilators to return the numeraire balance. Long term, use unit tests and fuzzing to ensure that all calculations return the expected values. Additionally, ensure that changes to the Shell Protocol do not introduce bugs such as this one.

## 57. System always assumes USDC is equivalent to USD

[Medium Risk - DFX Finance](https://github.com/dfx-finance/protocol/blob/main/audits/2021-05-03-Trail_of_Bits.pdf)

Throughout the system, assimilators are used to facilitate the processing of various stablecoins. However, the `UsdcToUsdAssimilator`’s implementation of the `getRate` method does not use the USDC-USD oracle provided by Chainlink; instead, it assumes 1 USDC is always worth 1 USD. A deviation in the exchange rate of 1 USDC = 1 USD could result in exchange errors.

### Recommendation

Short term, replace the hard-coded integer literal in the `UsdcToUsdAssimilator`’s `getRate` method with a call to the relevant Chainlink oracle, as is done in other assimilator contracts. Long term, ensure that the system is robust against a decrease in the price of any stablecoin.

## 58. Assimilators use a deprecated Chainlink API

[Undetermined Risk - DFX Finance](https://github.com/dfx-finance/protocol/blob/main/audits/2021-05-03-Trail_of_Bits.pdf)

The old version of the Chainlink price feed API (`AggregatorInterface`) is used throughout the contracts and tests. For example, the deprecated function `latestAnswer` is used. This function is not present in the latest API reference (`AggregatorInterfaceV3`). However, it is present in the deprecated API reference. In the worst-case scenario, the deprecated contract could cease to report the latest values, which would very likely cause liquidity providers to incur losses.

### Recommendation

Use the latest stable versions of any external libraries or contracts leveraged by the codebase.

## 59. `cancelOrdersUpTo` can be used to permanently block future orders

[High Risk - 0x Protocol](https://github.com/trailofbits/publications/blob/master/reviews/0x-protocol.pdf)

Users can cancel an arbitrary number of future orders, and this operation is not reversible. The `cancelOrdersUpTo` function (Figure 3.1) can cancel an arbitrary number of orders in a single, fixed-size transaction. This function uses a parameter to discard any order with salt less than the input value. However, `cancelOrdersUpTo` can cancel future orders if it is called with a very large value (e.g., `MAX_UINT256 - 1`). This operation will cancel future orders, except for the one with salt equal to `MAX_UINT256`.

### Recommendation

Properly document this behavior to warn users about the permanent effects of `cancelOrderUpTo` on future orders. Alternatively, disallow the cancelation of future orders.

## 60. Specification-Code mismatch for `AssetProxyOwner` timelock period

[High Risk - 0x Protocol](https://github.com/trailofbits/publications/blob/master/reviews/0x-protocol.pdf)

The specification for `AssetProxyOwner` says: "The `AssetProxyOwner` is a time-locked multi-signature wallet that has permission to perform administrative functions within the protocol. Submitted transactions must pass a 2 week timelock before they are executed." The `MultiSigWalletWithTimeLock.sol` and `AssetProxyOwner.sol` contracts' timelock-period implementation/usage does not enforce the two-week period, but is instead configurable by the wallet owner without any range checks. Either the specification is outdated (most likely), or this is a serious flaw.

### Recommendation

Short term, implement the necessary range checks to enforce the timelock described in the specification. Otherwise correct the specification to match the intended behavior. Long term, make sure implementation and specification are in sync. Use Echidna or Manticore to test that your code properly implements the specification.
