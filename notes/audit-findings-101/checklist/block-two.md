# Block Two: 21 - 40

## 31. Summoner can steal funds using `bailout`

[Major Severity - The LAO](https://consensys.net/diligence/audits/2020/01/the-lao/#summoner-can-steal-funds-using-bailout)

The `bailout` function allows anyone to transfer kicked user’s funds to the summoner if the user does not call `safeRagequit` (which forces the user to lose some funds). The intention is for the summoner to transfer these funds to the kicked member afterwards. The issue here is that it requires a lot of trust to the summoner on the one hand, and requires more time to kick the member out of the LAO.

### Recommendation

By implementing pull pattern for token transfers, kicked member won’t be able to block the `ragekick` and the LAO members would be able to kick anyone much quicker. There is no need to keep the `bailout` function.

### Resolution

`bailout` no longer exists in the Pull Pattern update.

## 32. Sponsorship front-running

[Major Severity - The LAO](https://consensys.net/diligence/audits/2020/01/the-lao/#sponsorship-front-running)

If proposal submission and sponsorship are done in 2 different transactions, it’s possible to front-run the `sponsorProposal` function by any member. The incentive to do that is to be able to block the proposal afterwards.

### Recommendation

Pull pattern for token transfers will solve the issue. Front-running will still be possible but it doesn’t affect anything.

### Resolution

This issue no longer exists in the Pull Pattern update (with Major severity, anyway), as mentioned in the recommendation, the front-running vector is still open but no rationale exist for such a behavior.

## 33. Delegate assignment front-running

[Medium Severity - The LAO](https://consensys.net/diligence/audits/2020/01/the-lao/#delegate-assignment-front-running)

Any member can front-run another member’s `delegateKey` assignment. If you try to submit an address as your `delegateKey`, someone else can try to assign your delegate address to themselves. While incentive of this action is unclear, it’s possible to block some address from being a delegate forever.

### Recommendation

Make it possible for a `delegateKey` to approve `delegateKey` assignment or cancel the current delegation. Commit-reveal methods can also be used to mitigate this attack.

### Resolution

Team won't fix this issue.
