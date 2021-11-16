# Auditing

## Audit

An audit is an external security assessment of a project codebase, typically requested and paid-for by the project team.

1. It detects and describes (in a report) security issues with underlying vulnerabilities, severity/difficulty, potential exploit scenarios and recommended fixes.
2. It also provides subjective insights into code quality, documentation and testing.
3. The scope/depth/format of audit reports varies across auditing teams but they generally cover similar aspects.

## Audit Scope

For Ethereum-based smart-contract projects, the scope is typically the on-chain smart contract code and sometimes includes the off-chain components that interact with the smart contracts.

## Audit Goal

The goal of audits is to assess project code (with any associated specification, documentation) and alert project team, typically before launch, of potential security-related issues that need to be addressed to improve security posture, decrease attack surface and mitigate risk.

## Audit Non-goal

Audit is **not** a security guarantee of “bug-free” code by any stretch of imagination but a best-effort endeavor by trained security experts operating within reasonable constraints of time, understanding, expertise and of course, decidability.

## Audit Target

Security companies execute audits for clients who pay for their services. Engagements are therefore geared towards priorities of project owners and not project users/investors. Audits are not intended to alert potential project users of any inherent risk. That is not their business/technical goal.

## Audit Need

Smart contract based projects do not have sufficient in-house Ethereum smart contract security expertise and/or time to perform internal security assessments and therefore rely on external experts who have domain expertise in those areas. Even if projects have some expertise in-house, they would still benefit from an unbiased external team with supplementary/complementary skill sets that can review the assumptions, design, specification and implementation of the project codebase.

## Audit Types

The types depend on the scope/nature/status of projects but generally fall into the following categories:

1. New audit: for a new project that is being launched.
2. Repeat audit: for a new version of an existing project being revised with new/fixed features.
3. Fix audit: for reviewing the fixes made to the findings from a current/prior audit.
4. Retainer audit: for constantly reviewing project updates.
5. Incident audit: for reviewing an exploit incident, root causing the incident, identifying the underlying vulnerabilities and proposing fixes.

## Audit Timeline

The Timeline depends on the scope/nature/status of the project to be assessed and the type of audit. This may vary from a few days for a fix/retainer audit to several weeks for a new/repeat/incident audit.

## Audit Effort

Effort typically involves more than one auditor simultaneously for getting independent, redundant or supplementary/complementary assessment expertise on the project.

## Audit Costs

depends on the type/scope of audit but typically costs upwards of USD $10K/week depending on the complexity of the project, market demand/supply for audits and the strength/reputation of the auditing firm.

## Audit Prerequisites

1. Clear definition of the scope of the project to be assessed typically in the form of a specific commit hash of project files/folders on a github repository.
2. Public/private repository.
3. Public/anonymous team.
4. Specification of the project’s design and architecture.
5. Documentation of the project’s implementation and business logic.
6. Threat models and specific areas of concern.
7. Prior testing, tools used, other audits.
8. Timeline, effort and costs/payments.
9. Engagement dynamics/channels for questions/clarifications, findings communication and reports.
10. Points of contact on both sides.

## Audit Limitations

Audits are necessary (for now at least) but not sufficient:

1. There is risk reduction but residual risk exists because of several factors such as limited amount of audit time/effort, limited insights into project specification/implementation, limited security expertise in the new and fast evolving technologies, limited audit scope, significant project complexity and limitations of automated/manual analysis.
2. Not all audits are equal — it greatly depends on the expertise/experience of auditors, effort invested vis-a-vis project complexity/quality and tools/processes used.
3. Audits provide a project’s security snapshot over a brief (typically few weeks) period. However, smart contracts need to evolve over time to add new features, fix bugs or optimize. Relying on external audits after every change is impractical.

## Auditing Firms

Audit Firms (representative; not exhaustive): ABDK, Arcadia, Beosin, Blockchain Consilium, BlockSec, CertiK, ChainSafe, ChainSecurity, Chainsulting, CoinFabrik, ConsenSys Diligence, Dedaub, G0, Hacken, Haechi, Halborn, HashEx, Iosiro, Least Authority, MixBytes, NCC, NewAlchemy, OpenZeppelin, PeckShield, Pessimistic, PepperSec, Pickle, Quantstamp, QuillHash, Runtime Verification, Sigma Prime, SlowMist, SmartDec, Solidified, Somish, Trail of Bits and Zokyo.
