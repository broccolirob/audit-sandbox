# Block Two

## `UniswapIncentive` overflow on pre-transfer hooks

Before a token transfer is performed, Fei performs some combination of mint/burn operations via `UniswapIncentive.incentivize`. Both `incentivizeBuy` and `incentivizeSell` calculate buy/sell incentives using overflow-prone math, then mint / burn from the target according to the results. This may have unintended consequences, like allowing a caller to mint tokens before transferring them, or burn tokens from their recipient.

- [Major Severity Finding](https://consensys.net/diligence/audits/2021/01/fei-protocol/#uniswapincentive-overflow-on-pre-transfer-hooks)
- Recommendation: Ensure casts in `getBuyIncentive` and `getSellPenalty` do not overflow.

### Code examples

```solidity
function incentivize(
  address sender,
  address receiver,
  address operator,
  uint256 amountIn
) external override onlyFei {
  updateOracle();

  if (isPair(sender)) {
    incentivizeBuy(receiver, amountIn);
  }

  if (isPair(receiver)) {
    require(
      isSellAllowlisted(sender) || isSellAllowlisted(operator),
      "UniswapIncentive: Blocked Fei sender or operator"
    );
    incentivizeSell(sender, amountIn);
  }
}

```

```solidity
function incentivizeBuy(address target, uint256 amountIn)
  internal
  ifMinterSelf
{
  if (isExemptAddress(target)) {
    return;
  }

  (
    uint256 incentive,
    uint32 weight,
    Decimal.D256 memory initialDeviation,
    Decimal.D256 memory finalDeviation
  ) = getBuyIncentive(amountIn);

  updateTimeWeight(initialDeviation, finalDeviation, weight);
  if (incentive != 0) {
    fei().mint(target, incentive);
  }
}

```

```solidity
function getBuyIncentive(uint amount) public view override returns(
    uint incentive,
    uint32 weight,
    Decimal.D256 memory initialDeviation,
    Decimal.D256 memory finalDeviation
) {
    (initialDeviation, finalDeviation) = getPriceDeviations(-1 * int256(amount));
```

## `BondingCurve` allows users to acquire FEI before launch

allocate can be called before genesis launch, as long as the contract holds some nonzero PCV. By force-sending the contract 1 wei, anyone can bypass the majority of checks and actions in allocate, and mint themselves FEI each time the timer expires.

- [Medium Severity Finding](https://consensys.net/diligence/audits/2021/01/fei-protocol/#bondingcurve-allows-users-to-acquire-fei-before-launch)
- Recommendation: Prevent `allocate` from being called before genesis launch.

```solidity
/// @notice if window has passed, reward caller and reset window
function _incentivize() internal virtual {
  if (isTimeEnded()) {
    _initTimed(); // reset window
    fei().mint(msg.sender, incentiveAmount);
  }
}

```

## `Timed.isTimeEnded` returns `true` if the timer has not been initialized

`Timed` initialization is a 2-step process: 1) `Timed.duration` is set in the constructor 2) `Timed.startTime` is set when the method `_initTimed` is called. Before this second method is called, `isTimeEnded()` calculates remaining time using a `startTime` of 0, resulting in the method returning `true` for most values, even though the timer has not technically been started.

- [Medium Severity Finding](https://consensys.net/diligence/audits/2021/01/fei-protocol/#timed-istimeended-returns-true-if-the-timer-has-not-been-initialized)
- Recommendation: If `Timed` has not been initialized, `isTimeEnded()` should return `false`, or `revert`

```solidity
/// @notice return true if time period has ended
function isTimeEnded() public view returns (bool) {
  return remainingTime() == 0;
}

/// @notice number of seconds remaining until time is up
/// @return remaining
function remainingTime() public view returns (uint256) {
  return SafeMathCopy.sub(duration, timeSinceStart());
}

/// @notice number of seconds since contract was initialized
/// @return timestamp
/// @dev will be less than or equal to duration
function timeSinceStart() public view returns (uint256) {
  uint256 _duration = duration;
  // solhint-disable-next-line not-rely-on-time
  uint256 timePassed = SafeMathCopy.sub(block.timestamp, startTime);
  return timePassed > _duration ? _duration : timePassed;
}

```

## Overflow/underflow protection

Having overflow/underflow vulnerabilities is very common for smart contracts. It is usually mitigated by using `SafeMath` or using solidity version ^0.8 (after solidity 0.8 arithmetical operations already have default overflow/underflow protection). In this code, many arithmetical operations are used without the ‘safe’ version. The reasoning behind it is that all the values are derived from the actual ETH values, so they can’t overflow.

- [Medium Severity Finding](https://consensys.net/diligence/audits/2021/01/fei-protocol/#overflow-underflow-protection)
- Recommendation: In our opinion, it is still safer to have these operations in a safe mode. So we recommend using `SafeMath` or solidity version ^0.8 compiler.
- This was partially addressed by using `SafeMath` for the specific example.

```solidity
uint totalGenesisTribe = tribeBalance() - totalCommittedTribe;
```

## Unchecked return value for `IWETH.transfer` call

In `EthUniswapPCVController`, there is a call to `IWETH.transfer` that does not check the return value. It is usually good to add a require-statement that checks the return value or to use something like `safeTransfer`; unless one is sure the given token reverts in case of a failure.

- [Medium Severity Finding](https://consensys.net/diligence/audits/2021/01/fei-protocol/#unchecked-return-value-for-iweth-transfer-call)
- Recommendation: Consider adding a require-statement or using `safeTransfer`.

```solidity
weth.transfer(address(pair), amount);
```

## `GenesisGroup.emergencyExit` remains functional after launch

`emergencyExit` is intended as an escape mechanism for users in the event the genesis `launch` method fails or is frozen. `emergencyExit` becomes callable 3 days after `launch` is callable. These two methods are intended to be mutually-exclusive, but are not: either method remains callable after a successful call to the other. This may result in accounting edge cases. In particular, `emergencyExit` fails to decrease `totalCommittedFGEN` by the exiting user’s commitment.

- [Medium Severity Finding](https://consensys.net/diligence/audits/2021/01/fei-protocol/#genesisgroup-emergencyexit-remains-functional-after-launch)
- Recommendation: 1) Ensure launch cannot be called if `emergencyExit` has been called 2) Ensure `emergencyExit` cannot be called if `launch` has been called 3) In `emergencyExit`, reduce `totalCommittedFGEN` by the existing user's committed amount.

```solidity
burnFrom(from, amountFGEN);
committedFGEN[from] = 0;

payable(to).transfer(total);
```

```solidity
uint amountFei = feiBalance() * totalCommittedFGEN / (totalSupply() + totalCommittedFGEN);
if (amountFei != 0) {
	totalCommittedTribe = ido.swapFei(amountFei);
}
```

## ERC20 tokens with no return value will fail to transfer

Although the ERC20 standard suggests that a transfer should return `true` on success, many tokens are non-compliant in this regard. In that case, the `.transfer()` call here will revert even if the transfer is successful, because solidity will check that the `RETURNDATASIZE` matches the ERC20 interface.

- [Major Severity Finding](https://consensys.net/diligence/audits/2020/11/bitbank/#erc20-tokens-with-no-return-value-will-fail-to-transfer)
- Recommendation: Consider using OpenZeppelin’s `SafeERC20`
- Resolution: This issue was addressed using OpenZeppelin's `SafeERC20`

```solidity
if (!instance.transfer(getSendAddress(), forwarderBalance)) {
    revert('Could not gather ERC20');
}
```

## Reentrancy vulnerability in `MetaSwap.swap()`

The adapters use this general process: 1) Collect the `from` token (or ether) from the user. 2) Execute the trade. 3) Transfer the contract’s balance of tokens (`from` and `to`) and ether to the user. If an attacker is able to reenter `swap()`, they can execute their own trade using the same tokens and get all the tokens for themselves. This is partially mitigated by the check against `amountTo` in `CommonAdapter`, but note that the `amountTo` typically allows for slippage, so it may still leave room for an attacker to siphon off some amount while still returning the required minimum to the user.

- [Major Severity Finding](https://consensys.net/diligence/audits/2020/08/metaswap/#reentrancy-vulnerability-in-metaswap-swap)
- Recommendation: Use a simple reentrancy guard, such as OpenZeppelin’s `ReentrancyGuard` to prevent reentrancy in `MetaSwap.swap()`. It might seem more obvious to put this check in `Spender.swap()`, but the `Spender` contract intentionally does not use any storage to avoid interference between different adapters.

### Code examples

```solidity
// Transfer remaining balance of tokenTo to sender
if (address(tokenTo) != Constants.ETH) {
    uint256 balance = tokenTo.balanceOf(address(this));
    require(balance >= amountTo, "INSUFFICIENT_AMOUNT");
    _transfer(tokenTo, balance, recipient);
} else {
```

## A new malicious adapter can access users` tokens

The purpose of the `MetaSwap` contract is to save users gas costs when dealing with a number of different aggregators. They can just `approve()` their tokens to be spent by `MetaSwap` (or in a later architecture, the `Spender` contract). They can then perform trades with all supported aggregators without having to reapprove anything. A downside to this design is that a malicious (or buggy) adapter has access to a large collection of valuable assets. Even a user who has diligently checked all existing adapter code before interacting with `MetaSwap` runs the risk of having their funds intercepted by a new malicious adapter that’s added later.

- [Medium Severity Finding](https://consensys.net/diligence/audits/2020/08/metaswap/#a-new-malicious-adapter-can-access-users-tokens)
- Recommendation: Make MetaSwap contract the only contract that receives token approval. It then moves tokens to the `Spender` contract before that contract `DELEGATECALL`'s to the appropriate adapter. In this model, newly added adapters shouldn’t be able to access users’ funds.

## Owner can front-run traders by updating adapters

MetaSwap owners can front-run users to swap an adapter implementation. This could be used by a malicious or compromised owner to steal from users. Because adapters are `DELEGATECALL`’ed, they can modify storage. This means any adapter can overwrite the logic of another adapter, regardless of what policies are put in place at the contract level. Users must fully trust every adapter because just one malicious adapter could change the logic of all other adapters.

- [Medium Severity Finding](https://consensys.net/diligence/audits/2020/08/metaswap/#owner-can-front-run-traders-by-updating-adapters)
- Recommendation: At a minimum, disallow modification of existing adapters. Instead, simply add new adapters and disable the old ones. A new malicious adapter could still overwrite the adapter mapping to modify existing adapters. To fully address this issue, the adapter registry should be in a separate contract. 1) `MetaSwap` contains the adapter registry. It calls into a new `Spender` contract. 2) The `Spender` contract has no storage at all and is just used to `DELEGATECALL` to the adapter contracts.
