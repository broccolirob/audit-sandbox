# Block One

## Unhandled return values of `transfer` and `transferFrom`

ERC20 implementations are not always consistent. Some implementations of `transfer` and `transferFrom` could return ‘false’ on failure instead of reverting. It is safer to wrap such calls into `require()` statements to these failures.

- [Medium Severity Finding](https://consensys.net/diligence/audits/2020/09/aave-protocol-v2/#unhandled-return-values-of-transfer-and-transferfrom)
- Recommendation: Check the return value and revert on `0`/`false` or use OpenZeppelin’s `SafeERC20` wrapper functions.
- Resolution: `safeTransferFrom` is now used instead of `transferFrom` in all locations.

### Code examples

```solidity
IERC20(asset).transferFrom(receiverAddress, vars.aTokenAddress, vars.amountPlusPremium);
```

### Notes references

- [ERC20 `transfer` does not return boolean](https://github.com/broccolirob/security-sandbox/blob/master/notes/security-101/money.md#erc20-transfer-does-not-return-boolean)
- [ERC20 `transfer` and `transferFrom`](https://github.com/broccolirob/security-sandbox/blob/master/notes/security-201/tokens-specific.md#erc20-transfer-and-transferfrom)
- [Token handling](https://github.com/broccolirob/security-sandbox/blob/master/notes/security-201/economic-functions.md#token-handling)
- [Error reporting issues](https://github.com/broccolirob/security-sandbox/blob/master/notes/security-201/issues.md#error-reporting-issues)

## Random task execution

In a scenario where a user takes a flash loan, `_parseFLAndExecute()` gives the flash loan wrapper contract (`FLAaveV2`, `FLDyDx`) the permission to execute functions on behalf of the user’s `DSProxy`. This execution permission is revoked only after the entire recipe execution is finished, which means that in case that any of the external calls along the recipe execution is malicious, it might call `executeAction()` back, i.e. Reentrancy Attack, and inject any task it wishes (e.g. take user’s funds out, drain approved tokens, etc).

- [Critical Severity Finding](https://consensys.net/diligence/audits/2021/03/defi-saver/#random-task-execution)
- Recommendation: A reentrancy guard (mutex) should be used to prevent such attack.
- Resolution: Fixed by adding `ReentrancyGuard` to the `executeOperation` function.

### Code examples

```solidity
function executeOperation(
  address[] memory _assets,
  uint256[] memory _amounts,
  uint256[] memory _fees,
  address _initiator,
  bytes memory _params
) public returns (bool) {
  require(msg.sender == AAVE_LENDING_POOL, ERR_ONLY_AAVE_CALLER);
  require(_initiator == address(this), ERR_SAME_CALLER);

  (Task memory currTask, address proxy) = abi.decode(_params, (Task, address));

  // Send FL amounts to user proxy
  for (uint256 i = 0; i < _assets.length; ++i) {
    _assets[i].withdrawTokens(proxy, _amounts[i]);
  }

  address payable taskExecutor = payable(registry.getAddr(TASK_EXECUTOR_ID));

  // call Action execution
  IDSProxy(proxy).execute{ value: address(this).balance }(
    taskExecutor,
    abi.encodeWithSelector(
      CALLBACK_SELECTOR,
      currTask,
      bytes32(_amounts[0] + _fees[0])
    )
  );

  // return FL
  for (uint256 i = 0; i < _assets.length; i++) {
    _assets[i].approveToken(address(AAVE_LENDING_POOL), _amounts[i] + _fees[i]);
  }

  return true;
}

```

### Notes references

- [Reentrancy vulnerabilities](https://github.com/broccolirob/audit-sandbox/blob/master/notes/audit-findings-101/1-block.md#random-task-execution)
- [Controlled `delegatecall`](https://github.com/broccolirob/security-sandbox/blob/master/notes/security-101/calls.md#controlled-delegatecall)
- [Trust issues](https://github.com/broccolirob/security-sandbox/blob/master/notes/security-201/issues.md#trust-issues)

## Tokens with more than 18 decimal points will cause issues

It is assumed that the maximum number of decimals for each token is 18. However uncommon, it is possible to have tokens with more than 18 decimals, as an example YAMv2 has 24 decimals. This can result in broken code flow and unpredictable outcomes

- [Major Severity Finding](https://consensys.net/diligence/audits/2021/03/defi-saver/#tokens-with-more-than-18-decimal-points-will-cause-issues)
- Recommendation: Make sure the code won’t fail in case the token’s decimals is more than 18.
- Resolution: Fixed by using `SafeMath.sub` to revert of tokens with Decimal > 18.

### Code examples

```solidity
function getSellRate(
  address _srcAddr,
  address _destAddr,
  uint256 _srcAmount,
  bytes memory
) public view override returns (uint256 rate) {
  (rate, ) = KyberNetworkProxyInterface(KYBER_INTERFACE).getExpectedRate(
    IERC20(_srcAddr),
    IERC20(_destAddr),
    _srcAmount
  );

  // multiply with decimal difference in src token
  rate = rate * (10**(18 - getDecimals(_srcAddr)));
  // divide with decimal difference in dest token
  rate = rate / (10**(18 - getDecimals(_destAddr)));
}

```

### Notes references

- [Token handling](https://github.com/broccolirob/security-sandbox/blob/master/notes/security-201/economic-functions.md#token-handling)
- [Numerical issues](https://github.com/broccolirob/security-sandbox/blob/master/notes/security-201/issues.md#numerical-issues)

## Error codes of Compound's `Comptroller.enterMarket`, `Comptroller.exitMarket` are not checked

Compound’s `enterMarket`/`exitMarket` functions return an error code instead of reverting in case of failure. DeFi Saver smart contracts never check for the error codes returned from Compound smart contracts.

- [Major Severity Finding](https://consensys.net/diligence/audits/2021/03/defi-saver/#error-codes-of-compound-s-comptroller-entermarket-comptroller-exitmarket-are-not-checked)
- Recommendation: Caller contract should revert in case the error code is not 0.
- Resolution: Fixed by reverting in the case the return value is non zero.

### Code examples

```solidity
function enterMarket(address _cTokenAddr) public {
  address[] memory markets = new address[](1);
  markets[0] = _cTokenAddr;

  IComptroller(COMPTROLLER_ADDR).enterMarkets(markets);
}

/// @notice Exits the Compound market
/// @param _cTokenAddr CToken address of the token
function exitMarket(address _cTokenAddr) public {
  IComptroller(COMPTROLLER_ADDR).exitMarket(_cTokenAddr);
}

```

### Notes references

- [Error-reporting issues](https://github.com/broccolirob/security-sandbox/blob/master/notes/security-201/issues.md#error-reporting-issues)
- [Function return values](https://github.com/broccolirob/security-sandbox/blob/master/notes/security-201/code-quality.md#function-return-values)

## Reversed order of parameters in `allowance` function call

The parameters that are used for the `allowance` function call are not in the same order that is used later in the call to `safeTransferFrom`.

- [Medium Severity Finding](https://consensys.net/diligence/audits/2021/03/defi-saver/#reversed-order-of-parameters-in-allowance-function-call)
- Recommendation: Reverse the order of parameters in `allowance` function call to fit the order that is in the `safeTransferFrom` function call.
- Resolution: Fixed by swapping the order of function call parameters.

### Code examples

```solidity
function pullTokens(
  address _token,
  address _from,
  uint256 _amount
) internal returns (uint256) {
  // handle max uint amount
  if (_amount == type(uint256).max) {
    uint256 allowance = IERC20(_token).allowance(address(this), _from);
    uint256 balance = getBalance(_token, _from);

    _amount = (balance > allowance) ? allowance : balance;
  }

  if (
    _from != address(0) &&
    _from != address(this) &&
    _token != ETH_ADDR &&
    _amount != 0
  ) {
    IERC20(_token).safeTransferFrom(_from, address(this), _amount);
  }

  return _amount;
}

```

### Notes references

- [Function arguments](https://github.com/broccolirob/security-sandbox/blob/master/notes/security-201/code-quality.md#function-arguments)

## Token approvals can be stolen in `DAOfiV1Router01.addLiquidity()`

`DAOfiV1Router01.addLiquidity()` creates the desired pair contract if it does not already exist, then transfers tokens into the pair and calls `DAOfiV1Pair.deposit()`. There is no validation of the address to transfer tokens from, so an attacker could pass in any address with nonzero token approvals to `DAOfiV1Router`. This could be used to add liquidity to a pair contract for which the attacker is the `pairOwner`, allowing the stolen funds to be retrieved using `DAOfiV1Pair.withdraw()`.

- [Critical Severity Finding](https://consensys.net/diligence/audits/2021/02/daofi/#token-approvals-can-be-stolen-in-daofiv1router01-addliquidity)
- Recommendation: Transfer tokens from `msg.sender` instead of `lp.sender`.

### Code examples

```solidity
function addLiquidity(LiquidityParams calldata lp, uint256 deadline)
  external
  override
  ensure(deadline)
  returns (uint256 amountBase)
{
  if (
    IDAOfiV1Factory(factory).getPair(
      lp.tokenBase,
      lp.tokenQuote,
      lp.slopeNumerator,
      lp.n,
      lp.fee
    ) == address(0)
  ) {
    IDAOfiV1Factory(factory).createPair(
      address(this),
      lp.tokenBase,
      lp.tokenQuote,
      msg.sender,
      lp.slopeNumerator,
      lp.n,
      lp.fee
    );
  }
  address pair = DAOfiV1Library.pairFor(
    factory,
    lp.tokenBase,
    lp.tokenQuote,
    lp.slopeNumerator,
    lp.n,
    lp.fee
  );

  TransferHelper.safeTransferFrom(lp.tokenBase, lp.sender, pair, lp.amountBase);
  TransferHelper.safeTransferFrom(
    lp.tokenQuote,
    lp.sender,
    pair,
    lp.amountQuote
  );
  amountBase = IDAOfiV1Pair(pair).deposit(lp.to);
}

```

### Notes references

- [Function parameters](https://github.com/broccolirob/audit-sandbox/blob/master/notes/audit-findings-101/1-block.md#token-approvals-can-be-stolen-in-daofiv1router01addliquidity)
- [Access control issues](https://github.com/broccolirob/security-sandbox/blob/master/notes/security-201/issues.md#access-control-issues)

## `swapExactTokensForETH` checks the wrong return value

Instead of checking that the amount of tokens received from a swap is greater than the minimum amount expected from this swap (`sp.amountOut`), it calculates the difference between the initial receiver’s balance and the balance of the router.

- [Major Severity Finding](https://consensys.net/diligence/audits/2021/02/daofi/#the-swapexacttokensforeth-checks-the-wrong-return-value)
- Recommendation: Check the intended values.

### Code examples

```solidity
uint amountOut = IWETH10(WETH).balanceOf(address(this));
require(
    IWETH10(sp.tokenOut).balanceOf(address(this)).sub(balanceBefore) >= sp.amountOut,
    'DAOfiV1Router: INSUFFICIENT_OUTPUT_AMOUNT'
);
```

### Notes references

- [Function arguments](https://github.com/broccolirob/security-sandbox/blob/master/notes/security-201/code-quality.md#function-arguments)
- [Accounting issues](https://github.com/broccolirob/security-sandbox/blob/master/notes/security-201/issues.md#accounting-issues)

## `DAOfiV1Pair.deposit()` accepts deposits of zero, blocking the pool

`DAOfiV1Pair.deposit()` is used to deposit liquidity into the pool. Only a single deposit can be made, so no liquidity can ever be added to a pool where `deposited == true`. The `deposit()` function does not check for a nonzero deposit amount in either token, so a malicious user that does not hold any of the `baseToken` or `quoteToken` can lock the pool by calling `deposit()` without first transferring any funds to the pool.

- [Medium Severity Finding](https://consensys.net/diligence/audits/2021/02/daofi/#daofiv1pair-deposit-accepts-deposits-of-zero-blocking-the-pool)
- Recommendation: Require a minimum deposit amount (`baseToken` & `quoteToken`) with non-zero checks.

### Code examples

```solidity
function deposit(address to)
  external
  override
  lock
  returns (uint256 amountBaseOut)
{
  require(msg.sender == router, "DAOfiV1: FORBIDDEN_DEPOSIT");
  require(deposited == false, "DAOfiV1: DOUBLE_DEPOSIT");
  reserveBase = IERC20(baseToken).balanceOf(address(this));
  reserveQuote = IERC20(quoteToken).balanceOf(address(this));
  // this function is locked and the contract can not reset reserves
  deposited = true;
  if (reserveQuote > 0) {
    // set initial supply from reserveQuote
    supply = amountBaseOut = getBaseOut(reserveQuote);
    if (amountBaseOut > 0) {
      _safeTransfer(baseToken, to, amountBaseOut);
      reserveBase = reserveBase.sub(amountBaseOut);
    }
  }
  emit Deposit(msg.sender, reserveBase, reserveQuote, amountBaseOut, to);
}

```

### Notes references

- [Token handling](https://github.com/broccolirob/security-sandbox/blob/master/notes/security-201/economic-functions.md#token-handling)
- [Data validation issues](https://github.com/broccolirob/security-sandbox/blob/master/notes/security-201/issues.md#data-validation-issues)

## `GenesisGroup.commit` overwrites previously-committed values

The amount stored in the recipient’s `committedFGEN` balance overwrites any previously-committed value. Additionally, this also allows anyone to commit an amount of “0” to any account, deleting their commitment entirely.

- [Critical Severity Finding](https://consensys.net/diligence/audits/2021/01/fei-protocol/#genesisgroup-commit-overwrites-previously-committed-values)
- Recommendation: Ensure the committed amount is added to the existing commitment.

### Code examples

```solidity
function commit(
  address from,
  address to,
  uint256 amount
) external override onlyGenesisPeriod {
  burnFrom(from, amount);

  committedFGEN[to] = amount;
  totalCommittedFGEN += amount;

  emit Commit(from, to, amount);
}

```

### Notes references

- [Data processing issues](https://github.com/broccolirob/security-sandbox/blob/master/notes/security-201/issues.md#data-processing-issues)

## Purchasing and committing still possible after launch

Even after `GenesisGroup.launch` has successfully been executed, it is still possible to invoke `GenesisGroup.purchase` and `GenesisGroup.commit`.

- [Critical Severity Finding](https://consensys.net/diligence/audits/2021/01/fei-protocol/#purchasing-and-committing-still-possible-after-launch)
- Recommendation: Consider adding validation in `GenesisGroup.purchase` and `GenesisGroup.commit` to make sure that these functions cannot be called after the launch.

### Code examples

```solidity
modifier onlyGenesisPeriod() {
  require(!isTimeEnded(), "GenesisGroup: Not in Genesis Period");
  // require(!isTimeEnded() && !core().hasGenesisGroupCompleted(), "GenesisGroup: Not in Genesis Period");
}
```

### Notes references

- [Accounting issues](https://github.com/broccolirob/security-sandbox/blob/master/notes/security-201/issues.md#accounting-issues)

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
- Resolution: Mitigated by having separate limits for number of whitelisted tokens (for non-zero balance and for zero balance). That’s helpful because it’s much cheaper to process tokens with zero balance in the guild bank and you can have much more whitelisted tokens overall.
  ```solidity
  uint256 constant MAX_TOKEN_WHITELIST_COUNT = 400; // maximum number of whitelisted tokens
  uint256 constant MAX_TOKEN_GUILDBANK_COUNT = 200; // maximum number of tokens with non-zero balance in guildbank
  uint256 public totalGuildBankTokens = 0; // total tokens with non-zero balance in guild bank
  ```
  It should be noted that this is an estimated limit based on the manual calculations and current OP code gas costs. DAO members should consider splitting the DAO into two if more than 100 tokens with non-zero balance are used in the DAO to be safe.

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
