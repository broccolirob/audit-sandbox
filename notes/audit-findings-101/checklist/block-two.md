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
