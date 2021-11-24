# Block Two: 21 - 40

## 31. Summoner can steal funds using `bailout`

[Major Severity - The LAO](https://consensys.net/diligence/audits/2020/01/the-lao/#summoner-can-steal-funds-using-bailout)

The `bailout` function allows anyone to transfer kicked user’s funds to the summoner if the user does not call `safeRagequit` (which forces the user to lose some funds). The intention is for the summoner to transfer these funds to the kicked member afterwards. The issue here is that it requires a lot of trust to the summoner on the one hand, and requires more time to kick the member out of the LAO.

### Recommendation

By implementing pull pattern for token transfers, kicked member won’t be able to block the `ragekick` and the LAO members would be able to kick anyone much quicker. There is no need to keep the `bailout` function.

## 32. Sponsorship front-running

[Major Severity - The LAO](https://consensys.net/diligence/audits/2020/01/the-lao/#sponsorship-front-running)

If proposal submission and sponsorship are done in 2 different transactions, it’s possible to front-run the `sponsorProposal` function by any member. The incentive to do that is to be able to block the proposal afterwards.

### Recommendation

Pull pattern for token transfers will solve the issue. Front-running will still be possible but it doesn’t affect anything.

## 33. Delegate assignment front-running

[Medium Severity - The LAO](https://consensys.net/diligence/audits/2020/01/the-lao/#delegate-assignment-front-running)

Any member can front-run another member’s `delegateKey` assignment. If you try to submit an address as your `delegateKey`, someone else can try to assign your delegate address to themselves. While incentive of this action is unclear, it’s possible to block some address from being a delegate forever.

### Recommendation

Make it possible for a `delegateKey` to approve `delegateKey` assignment or cancel the current delegation. Commit-reveal methods can also be used to mitigate this attack.

## 34. Queued transactions cannot be canceled

[High Risk - Origin Dollar](https://github.com/trailofbits/publications/blob/master/reviews/OriginDollar.pdf)

The `Governor` contract contains special functions to set it as the admin of the `Timelock`. Only the `admin` can call `Timelock.cancelTransaction`. There are no functions in `Governor` that call `Timelock.cancelTransaction`. This makes it impossible for `Timelock.cancelTransaction` to ever be called.

### Recommendation

Short term, add a function to the `Governor` that calls `Timelock.cancelTransaction`. It is unclear who should be able to call it, and what other restrictions there should be around cancelling a transaction. Long term, consider letting `Governor` inherit from `Timelock`. This would allow a lot of functions and code to be removed and significantly lower the complexity of these two contracts.

## 35. Proposal transactions can be executed separately and block `Proposal.execute` call

[High Risk - Origin Dollar](https://github.com/trailofbits/publications/blob/master/reviews/OriginDollar.pdf)

Missing access controls in the `Timelock.executeTransaction` function allow `Proposal` transactions to be executed separately, circumventing the `Governor.execute` function. This means that even though `Proposal.executed` field says `false`, some or all of the containing transactions might have already been executed.

### Recommendation

Short term, only allow the `admin` to call `Timelock.executeTransaction`. Long term, use property-based testing using Echidna to ensure the contract behaves as expected. Consider letting `Governor` inherit from `Timelock`. This would allow a lot of functions and code to be removed and significantly lower the complexity of these two contracts.

## 36. Proposals could allow `Timelock.admin` takeover

[High Risk - Origin Dollar](https://github.com/trailofbits/publications/blob/master/reviews/OriginDollar.pdf)

The `Governor` contract contains special functions to let the `guardian` queue a transaction to change the `Timelock.admin`. However, a regular `Proposal` is also allowed to contain a transaction to change the `Timelock.admin`. This poses an unnecessary risk in that an attacker could create a `Proposal` to change the `Timelock.admin`.

### Recommendation

Short term, add a check that prevents `setPendingAdmin` to be included in a `Proposal`. Long term, consider letting `Governor` inherit from `Timelock`. This would allow a lot of functions and code to be removed and significantly lower the complexity of these two contracts.

## 37. Reentrancy and untrusted contract call in `mintMultiple`

[High Risk - Origin Dollar](https://github.com/trailofbits/publications/blob/master/reviews/OriginDollar.pdf)

Missing checks and no reentrancy prevention allow untrusted contracts to be called from `mintMultiple`. This could be used by an attacker to drain the contracts.

### Recommendation

Short term, add checks that cause `mintMultiple` to revert if the amount is zero or the asset is not supported. Add a reentrancy guard to the `mint`, `mintMultiple`, `redeem`, and `redeemAll` functions. Long term, make use of Slither which will flag the reentrancy. Or even better, use Crytic and incorporate static analysis checks into your CI/CD pipeline. Add reentrancy guards to all non-view functions callable by anyone. Make sure to always revert a transaction if an input is incorrect. Disallow calling untrusted contracts.

## 38. Lack of return value checks can lead to unexpected results

[High Risk - Origin Dollar](https://github.com/trailofbits/publications/blob/master/reviews/OriginDollar.pdf)

Several function calls do not check the return value. Without a return value check, the code is error-prone, which may lead to unexpected results.

### Recommendation

Short term, check the return value of all calls mentioned above. Long term, integrate static analysis into development process to catch these kinds of bugs.

## 39. External calls in loop can lead to denial of service

[High Risk - Origin Dollar](https://github.com/trailofbits/publications/blob/master/reviews/OriginDollar.pdf)

Several function calls are made in unbounded loops. This pattern is error-prone as it can trap the contracts due to the gas limitations or failed transactions.

### Recommendation

Short term, review all the loops mentioned above and either: 1) allow iteration over part of the loop, or 2) remove elements. Long term, integrate static analysis into development process to catch these kinds of bugs.

## 40. OUSD allows users to transfer more tokens than expected

[High Risk - Origin Dollar](https://github.com/trailofbits/publications/blob/master/reviews/OriginDollar.pdf)

Under certain circumstances, the OUSD contract allows users to transfer more tokens than the ones they have in their balance. This issue seems to be caused by a rounding issue when the creditsDeducted is calculated and subtracted.

### Recommendation

Short term, make sure the balance is correctly checked before performing all the arithmetic operations. This will make sure it does not allow to transfer more than expected. Long term, use Echidna to write properties that ensure ERC20 transfers are transferring the expected amount.
