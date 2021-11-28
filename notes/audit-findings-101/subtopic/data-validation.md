# Data Validation

## Proposals could allow `Timelock.admin` takeover

## Reentrancy and untrusted contract call in `mintMultiple`

## OUSD allows users to transfer more tokens than expected

## OUSD total supply can be arbitrary, even smaller than user balances

## Lack of a contract existence check allows token theft

## Lack of two-step procedure for critical operations leaves them error-prone

## Missing validation of `_owner` argument could indefinitely lock owner role

## Incorrect comparison enables swapping and token draining at no cost

## Unbound loop enables denial of service

## Front-running pool’s initialization can lead to draining of liquidity provider’s initial deposits

## Swapping on zero liquidity allows for control of the pool's price

## Failed transfer may be overlooked due to lack of contract existence check

## Assimilators' balance functions return raw values

## System always assumes USDC is equivalent to USD

## `cancelOrdersUpTo` can be used to permanently block future orders

## Unclear documentation on how order filling can fail

## Zero fee orders are possible if a user performs transactions with a zero gas price

## Calls to `setParams` may set invalid values and produce unexpected behavior in the staking contracts
