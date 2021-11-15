# Block One

## Unhandled return values of `transfer` and `transferFrom`

ERC20 implementations are not always consistent. Some implementations of `transfer` and `transferFrom` could return ‘false’ on failure instead of reverting. It is safer to wrap such calls into `require()` statements to these failures.

- Recommendation: Check the return value and revert on `0`/`false` or use OpenZeppelin’s `SafeERC20` wrapper functions.
- Resolution: `safeTransferFrom` is now used instead of `transferFrom` in all locations.

### Code Examples

```solidity
IERC20(asset).transferFrom(receiverAddress, vars.aTokenAddress, vars.amountPlusPremium);
```

## Random task execution

In a scenario where a user takes a flash loan, `_parseFLAndExecute()` gives the flash loan wrapper contract (`FLAaveV2`, `FLDyDx`) the permission to execute functions on behalf of the user’s `DSProxy`. This execution permission is revoked only after the entire recipe execution is finished, which means that in case that any of the external calls along the recipe execution is malicious, it might call `executeAction()` back, i.e. Reentrancy Attack, and inject any task it wishes (e.g. take user’s funds out, drain approved tokens, etc).

- Recommendation: A reentrancy guard (mutex) should be used to prevent such attack.
- Resolution: Fixed by adding `ReentrancyGuard` to the `executeOperation` function.

### Code Examples

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

## Tokens with more than 18 decimal points will cause issues

It is assumed that the maximum number of decimals for each token is 18. However uncommon, it is possible to have tokens with more than 18 decimals, as an example YAMv2 has 24 decimals. This can result in broken code flow and unpredictable outcomes

- Recommendation: Make sure the code won’t fail in case the token’s decimals is more than 18.
- Resolution: Fixed by using `SafeMath.sub` to revert of tokens with Decimal > 18.

### Code Examples

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

## Error codes of Compound's `Comptroller.enterMarket`, `Comptroller.exitMarket` are not checked

Compound’s `enterMarket`/`exitMarket` functions return an error code instead of reverting in case of failure. DeFi Saver smart contracts never check for the error codes returned from Compound smart contracts.

- Recommendation: Caller contract should revert in case the error code is not 0.
- Resolution: Fixed by reverting in the case the return value is non zero.

### Code Examples

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

## Reversed order of parameters in `allowance` function call

The parameters that are used for the `allowance` function call are not in the same order that is used later in the call to `safeTransferFrom`.

- Recommendation: Reverse the order of parameters in `allowance` function call to fit the order that is in the `safeTransferFrom` function call.

## Token approvals can be stolen in `DAOfiV1Router01.addLiquidity()`

`DAOfiV1Router01.addLiquidity()` creates the desired pair contract if it does not already exist, then transfers tokens into the pair and calls `DAOfiV1Pair.deposit()`. There is no validation of the address to transfer tokens from, so an attacker could pass in any address with nonzero token approvals to `DAOfiV1Router`. This could be used to add liquidity to a pair contract for which the attacker is the `pairOwner`, allowing the stolen funds to be retrieved using `DAOfiV1Pair.withdraw()`.

- Recommendation: Transfer tokens from `msg.sender` instead of `lp.sender`

## `swapExactTokensForETH` checks the wrong return value

Instead of checking that the amount of tokens received from a swap is greater than the minimum amount expected from this swap, it calculates the difference between the initial receiver’s balance and the balance of the router.

- Recommendation: Check the intended values

## `DAOfiV1Pair.deposit()` accepts deposits of zero, blocking the pool

`DAOfiV1Pair.deposit()` is used to deposit liquidity into the pool. Only a single deposit can be made, so no liquidity can ever be added to a pool where `deposited == true`. The `deposit()` function does not check for a nonzero deposit amount in either token, so a malicious user that does not hold any of the `baseToken` or `quoteToke`n can lock the pool by calling `deposit()` without first transferring any funds to the pool.

- Recommendation: Require a minimum deposit amount with non-zero checks

## `GenesisGroup.commit` overwrites previously-committed values

The amount stored in the recipient’s `committedFGEN` balance overwrites any previously-committed value. Additionally, this also allows anyone to commit an amount of “0” to any account, deleting their commitment entirely.

- Recommendation: Ensure the committed amount is added to the existing commitment.

## Purchasing and committing still possible after launch

Even after `GenesisGroup.launch` has successfully been executed, it is still possible to invoke `GenesisGroup.purchase` and `GenesisGroup.commit`.

- Recommendation: Consider adding validation in `GenesisGroup.purchase` and `GenesisGroup.commit` to make sure that these functions cannot be called after the launch.
