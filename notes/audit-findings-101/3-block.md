# Block Three

## Users can collect interest from `SavingsContract` by only staking mTokens

The SAVE contract allows users to deposit mAssets in return for lending yield and swap fees. When depositing mAsset, users receive a “credit” tokens at the momentary credit/mAsset exchange rate which is updated at every deposit. However, the smart contract enforces a minimum timeframe of 30 minutes in which the interest rate will not be updated. A user who deposits shortly before the end of the timeframe will receive credits at the stale interest rate and can immediately trigger an update of the rate and withdraw at the updated (more favorable) rate after the 30 minutes window. As a result, it would be possible for users to benefit from interest payouts by only staking mAssets momentarily and using them for other purposes the rest of the time.

- [Major Severity Finding](https://consensys.net/diligence/audits/2020/07/mstable-1.1/#users-can-collect-interest-from-savingscontract-by-only-staking-mtokens-momentarily)
- Recommendation: Remove the 30 minutes window such that every deposit also updates the exchange rate between credits and tokens.
- Resolution: The blocker on collecting interest more than once in 30 minute period. A new APY bounds check has been added to verify that supply isn’t inflated by more than 0.1% within a 30 minutes window.

### Code examples

```solidity
// 1. Only collect interest if it has been 30 mins
uint256 timeSinceLastCollection = now.sub(previousCollection);
if(timeSinceLastCollection > THIRTY_MINUTES) {
```

## Oracle updates can be manipulated to perform atomic front-running attack

It is possible to atomically arbitrage rate changes in a risk-free way by “sandwiching” the Oracle update between two transactions. The attacker would send the following 2 transactions at the moment the Oracle update appears in the mempool: 1) The first transaction, which is sent with a higher gas price than the Oracle update transaction, converts a very small amount. This “locks in” the conversion weights for the block since `handleExternalRateChange()` only updates weights once per block. By doing this, the arbitrageur ensures that the stale Oracle price is initially used when doing the first conversion in the following transaction. The second transaction, which is sent at a slightly lower gas price than the transaction that updates the Oracle, performs a large conversion at the old weight, adds a small amount of Liquidity to trigger rebalancing and converts back at the new rate. The attacker can obtain liquidity for step 2 using a flash loan. The attack will deplete the reserves of the pool.

- [Critical Severity Finding](https://consensys.net/diligence/audits/2020/06/bancor-v2-amm-security-audit/#oracle-updates-can-be-manipulated-to-perform-atomic-front-running-attack)
- Recommendation: Do not allow users to trade at a stale Oracle rate and trigger an Oracle price update in the same transaction.
- Resolution: The issue was mitigated by updating the Oracle price only once per block and consistently only using the old value throughout the block instead of querying the Oracle when adding or removing liquidity. Arbitrageurs can now no longer do the profitable trade within a single transaction which also precludes the possibility of using flash loans to amplify the attack.

## Certain functions lack input validation routines

The functions should first check if the passed arguments are valid first. These checks should include, but not be limited to: 1) `uint` should be larger than `0` when `0` is considered invalid 2) `uint` should be within constraints 3) `int` should be positive in some cases 4) length of arrays should match if more arrays are sent as arguments 5) addresses should not be `0x0`.

- [Major Severity Finding](https://consensys.net/diligence/audits/2020/06/shell-protocol/#certain-functions-lack-input-validation-routines)
- Recommendation: Add tests that check if all of the arguments have been validated. Consider checking arguments as an important part of writing code and developing the system.

### Code examples

The function `includeAsset` does not do any checks before changing the contract state. The internal function called by the public method includeAsset again doesn’t check any of the data.

```solidity
function includeAsset(
  address _numeraire,
  address _nAssim,
  address _reserve,
  address _rAssim,
  uint256 _weight
) public onlyOwner {
  shell.includeAsset(_numeraire, _nAssim, _reserve, _rAssim, _weight);
}

function includeAsset(
  Shells.Shell storage shell,
  address _numeraire,
  address _numeraireAssim,
  address _reserve,
  address _reserveAssim,
  uint256 _weight
) internal {
  Assimilators.Assimilator storage _numeraireAssimilator = shell.assimilators[
    _numeraire
  ];
  _numeraireAssimilator.addr = _numeraireAssim;
  _numeraireAssimilator.ix = uint8(shell.numeraires.length);
  shell.numeraires.push(_numeraireAssimilator);
  Assimilators.Assimilator storage _reserveAssimilator = shell.assimilators[
    _reserve
  ];
  _reserveAssimilator.addr = _reserveAssim;
  _reserveAssimilator.ix = uint8(shell.reserves.length);
  shell.reserves.push(_reserveAssimilator);
  shell.weights.push(_weight.divu(1e18).add(uint256(1).divu(1e18)));
}

```

```solidity
function includeAssimilator(
  address _numeraire,
  address _derivative,
  address _assimilator
) public onlyOwner {
  shell.includeAssimilator(_numeraire, _derivative, _assimilator);
}

function includeAssimilator(
  Shells.Shell storage shell,
  address _numeraire,
  address _derivative,
  address _assimilator
) internal {
  Assimilators.Assimilator storage _numeraireAssim = shell.assimilators[
    _numeraire
  ];
  shell.assimilators[_derivative] = Assimilators.Assimilator(
    _assimilator,
    _numeraireAssim.ix
  );
  // shell.assimilators[_derivative] = Assimilators.Assimilator(_assimilator, _numeraireAssim.ix, 0, 0);
}

```

## Remove `Loihi` methods that can be used as backdoors by the administrator

There are several functions in `Loihi` that give extreme powers to the shell administrator. The most dangerous set of those is the ones granting the capability to add assimilators. Since assimilators are essentially a proxy architecture to delegate code to several different implementations of the same interface, the administrator could, intentionally or unintentionally, deploy malicious or faulty code in the implementation of an assimilator. This means that the administrator is essentially totally trusted to not run code that, for example, drains the whole pool or locks up the users’ and LPs’ tokens. In addition to these, the function `safeApprove` allows the administrator to move any of the tokens the contract holds to any address regardless of the balances any of the users have. This can also be used by the owner as a backdoor to completely drain the contract.

- [Major Severity Finding](https://consensys.net/diligence/audits/2020/06/shell-protocol/#remove-loihi-methods-that-can-be-used-as-backdoors-by-the-administrator)
- Recommendation: Remove the `safeApprove` function and, instead, use a trustless escape-hatch mechanism. For the assimilator addition functions, our recommendation is that they are made completely internal, only callable in the constructor, at deploy time. Even though this is not a big structural change (in fact, it reduces the attack surface), it is, indeed, a feature loss. However, this is the only way to make each shell a time-invariant system. This would not only increase Shell’s security but also would greatly improve the trust the users have in the protocol since, after deployment, the code is now static and auditable.

### Code examples

```solidity
function safeApprove(
  address _token,
  address _spender,
  uint256 _value
) public onlyOwner {
  (bool success, bytes memory returndata) = _token.call(
    abi.encodeWithSignature("approve(address,uint256)", _spender, _value)
  );
  require(success, "SafeERC20: low-level call failed");
}

```

## A reverting fallback function will lock up all payouts

In `BoxExchange.sol`, the internal function `_transferEth()` reverts if the transfer does not succeed. The `_payment()` function processes a list of transfers to settle the transactions in an `ExchangeBox`. If any of the recipients of an ETH transfer is a smart contract that reverts, then the entire payout will fail and will be unrecoverable.

- [Critical Severity Finding](https://consensys.net/diligence/audits/2020/05/lien-protocol/#a-reverting-fallback-function-will-lock-up-all-payouts)
- Recommendation: 1) Implement a queuing mechanism to allow buyers/sellers to initiate the withdrawal on their own using a ‘pull-over-push pattern.’ 2) Ignore a failed transfer and leave the responsibility up to users to receive them properly.
- Resolution: Replace the push method to pull pattern. 1) Remove transfer of ETH in the process of execution, and store ETH amount to `mapping(address => uint256) ethBalance`. 2) Add function `withdrawETH` to send `ethBalance[msg.sender]`

### Code examples

```solidity
function _transferETH(address _recipient, uint256 _amount) private {
  (bool success, ) = _recipient.call{ value: _amount }(
    abi.encodeWithSignature("")
  );
  require(success, "Transfer Failed");
}

```

## `safeRagequit` makes you lose funds

`safeRagequit` and `ragequit` functions are used for withdrawing funds from the LAO. The difference between them is that `ragequit` function tries to withdraw all the allowed tokens and `safeRagequit` function withdraws only some subset of these tokens, defined by the user. It’s needed in case the user or GuildBank is blacklisted in some of the tokens and the transfer reverts. The problem is that even though you can quit in that case, you’ll lose the tokens that you exclude from the list. To be precise, the tokens are not completely lost, they will belong to the LAO and can still potentially be transferred to the user who quit. But that requires a lot of trust, coordination, time and anyone can steal some part of these tokens.

- [Critical Severity Finding](https://consensys.net/diligence/audits/2020/01/the-lao/#saferagequit-makes-you-lose-funds)
- Recommendation: Implementing pull pattern for token withdrawals should solve the issue. Users will be able to quit the LAO and burn their shares but still keep their tokens in the LAO’s contract for some time if they can’t withdraw them right now.
- Resolution: `safeRagequit` no longer exists in the Pull Pattern update. `ragequit` is considered safe as there are no longer any ERC20 transfers in its code flow.

## Creating proposal is not trustless

Usually, if someone submits a proposal and transfers some amount of tribute tokens, these tokens are transferred back if the proposal is rejected. But if the proposal is not processed before the emergency processing, these tokens will not be transferred back to the proposer. This might happen if a tribute token or a deposit token transfers are blocked. Tokens are not completely lost in that case, they now belong to the LAO shareholders and they might try to return that money back. But that requires a lot of coordination and time and everyone who ragequits during that time will take a part of that tokens with them.

- [Critical Severity Finding](https://consensys.net/diligence/audits/2020/01/the-lao/#creating-proposal-is-not-trustless)
- Recommendation: Pull pattern for token transfers would solve the issue.
- Resolution: This issue no longer exists in the Pull Pattern update, due to the fact that emergency processing and in function ERC20 transfers are removed.

### Code examples

```solidity
if (!emergencyProcessing) {
    require(
        proposal.tributeToken.transfer(proposal.proposer, proposal.tributeOffered),
        "failing vote token transfer failed"
    );
```

## Emergency processing can be blocked

The main reason for the emergency processing mechanism is that there is a chance that some token transfers might be blocked. For example, a sender or a receiver is in the USDC blacklist. Emergency processing saves from this problem by not transferring tribute token back to the user (if there is some) and rejecting the proposal. The problem is that there is still a deposit transfer back to the sponsor and it could be potentially blocked too. If that happens, proposal can’t be processed and the LAO is blocked.

- [Critical Severity Finding](https://consensys.net/diligence/audits/2020/01/the-lao/#emergency-processing-can-be-blocked)
- Recommendation: Pull pattern for token transfers would solve the issue. The alternative solution would be to also keep the deposit tokens in the LAO, but that makes sponsoring the proposal more risky for the sponsor.
- Resolution: Emergency Processing no longer exists in the Pull Pattern update.

### Code examples

```solidity
if (!emergencyProcessing) {
    require(
        proposal.tributeToken.transfer(proposal.proposer, proposal.tributeOffered),
        "failing vote token transfer failed"
    );
```

## Token Overflow might result in system halt or loss of funds

If a token overflows, some functionality such as `processProposal`, `cancelProposal` will break due to SafeMath reverts. The overflow could happen because the supply of the token was artificially inflated to oblivion.

- [Major Severity Finding](https://consensys.net/diligence/audits/2020/01/the-lao/#token-overflow-might-result-in-system-halt-or-loss-of-funds)
- Recommendation: We recommend to allow overflow for broken or malicious tokens. This is to prevent system halt or loss of funds. It should be noted that in case an overflow occurs, the balance of the token will be incorrect for all token holders in the system. `rageKick`, `rageQuit` were fixed by not using safeMath within the function code, however this fix is risky and not recommended, as there are other overflows in other functions that might still result in system halt or loss of funds. One suggestion is having a function named `unsafeInternalTransfer()` which does not use safeMath for the cases that overflow should be allowed. This mainly adds better readability to the code.

### Code examples

```solidity
function max(uint256 x, uint256 y) internal pure returns (uint256) {
  return x >= y ? x : y;
}

```

## Whitelisted tokens limit

`_ragequit` function is iterating over all whitelisted tokens. If the number of tokens is too big, a transaction can run out of gas and all funds will be blocked forever. Ballpark estimation of this number is around 300 tokens based on the current OpCode gas costs and the block gas limit.

- [Major Severity Finding](https://consensys.net/diligence/audits/2020/01/the-lao/#whitelisted-tokens-limit)
- Recommendation: A simple solution would be just limiting the number of whitelisted tokens. If the intention is to invest in many new tokens over time, and it’s not an option to limit the number of whitelisted tokens, it’s possible to add a function that removes tokens from the whitelist. For example, it’s possible to add a new type of proposal that is used to vote on token removal if the balance of this token is zero. Before voting for that, shareholders should sell all the balance of that token.
- Resolution: Mitigated by having separate limits for number of whitelisted tokens (for non-zero balance and for zero balance). That’s helpful because it’s much cheaper to process tokens with zero balance in the guild bank and you can have much more whitelisted tokens overall. `solidity uint256 constant MAX_TOKEN_WHITELIST_COUNT = 400; // maximum number of whitelisted tokens uint256 constant MAX_TOKEN_GUILDBANK_COUNT = 200; // maximum number of tokens with non-zero balance in guildbank uint256 public totalGuildBankTokens = 0; // total tokens with non-zero balance in guild bank` It should be noted that this is an estimated limit based on the manual calculations and current OP code gas costs. DAO members should consider splitting the DAO into two if more than 100 tokens with non-zero balance are used in the DAO to be safe.

### Code examples

```solidity
for (uint256 i = 0; i < tokens.length; i++) {
    uint256 amountToRagequit = fairShare(userTokenBalances[GUILD][tokens[i]], sharesAndLootToBurn, initialTotalSharesAndLoot);
    // deliberately not using safemath here to keep overflows from preventing the function execution (which would break ragekicks)
    // if a token overflows, it is because the supply was artificially inflated to oblivion, so we probably don't care about it anyways
    userTokenBalances[GUILD][tokens[i]] -= amountToRagequit;
    userTokenBalances[memberAddress][tokens[i]] += amountToRagequit;
}
```
