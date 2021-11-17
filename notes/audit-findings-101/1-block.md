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
