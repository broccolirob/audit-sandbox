# Block Two: 21 - 40

## 31. Summoner can steal funds using `bailout` [Major]

There are two reasons to use the `bailout` function: 1) To kick someone out of the LAO. 2) "Lost private my key" problem. The `bailout` function allows anyone to transfer kicked user’s funds to the summoner if the user does not call `safeRagequit` (which forces the user to lose some funds) and their `bailoutWait` time has passed. Kicked users can block `ragekick` by bricking `withdraw` token transfer. The intention is for the summoner to transfer these funds to the kicked member afterwards. The issue here is that it delegates a lot of trust to the summoner, and extends time frame to kick the member out of the LAO.

### Code Examples

Bailout transfers kicked member's shares to the summoner.

```solidity
function bailout(address memberToBail) public nonReentrant {
  Member storage member = members[memberToBail];

  require(member.jailed != 0, "member must be in jail");
  require(member.loot > 0, "member must have some loot"); // note - should be impossible for jailed member to have shares
  require(canBailout(memberToBail), "cannot bailout yet");

  members[summoner].loot = members[summoner].loot.add(member.loot);
  member.loot = 0;
}

```

`_ragequit` calls `withdraw` on the `guildBank` contract.

```solidity
function withdraw(
  address receiver,
  uint256 shares,
  uint256 totalShares,
  IERC20[] memory approvedTokens
) public onlyOwner returns (bool) {
  for (uint256 i = 0; i < approvedTokens.length; i++) {
    uint256 amount = fairShare(
      approvedTokens[i].balanceOf(address(this)),
      shares,
      totalShares
    );
    emit Withdrawal(receiver, address(approvedTokens[i]), amount);
    require(approvedTokens[i].transfer(receiver, amount));
  }
  return true;
}

```

### Recommendation

By implementing a pull pattern for token transfers, kicked member won’t be able to block the `ragekick` and the LAO members would be able to kick anyone much quicker. There is no need to keep the `bailout` for this intention.

## Sponsorship front-running [Major]

```

```
