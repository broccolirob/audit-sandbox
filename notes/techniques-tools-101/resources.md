# Auditing Resources

## False positives

False positives are findings which indicate the presence of vulnerabilities but which in fact are not vulnerabilities. Such false positives could be due to incorrect assumptions or simplifications in analysis which do not correctly consider all the factors required for the actual presence of vulnerabilities.

1. False positives require further manual analysis on findings to investigate if they are indeed false or true positives.
2. High number of false positives increases manual effort in verification and lowers the confidence in the accuracy of the earlier automated/manual analysis.
3. True positives might sometimes be classified as false positives which leads to vulnerabilities being exploited instead of being fixed.

## False negatives

False negatives are missed findings that should have indicated the presence of vulnerabilities but which are in fact are not reported at all. Such false negatives could be due to incorrect assumptions or inaccuracies in analysis which do not correctly consider the minimum factors required for the actual presence of vulnerabilities.

1. False negatives, per definition, are not reported or even realized unless a different analysis reveals their presence or the vulnerabilities are exploited.
2. High number of false negatives lowers the confidence in the effectiveness of the earlier manual/automated analysis.

## Auditing Firms

Audit Firms (representative; not exhaustive): ABDK, Arcadia, Beosin, Blockchain Consilium, BlockSec, CertiK, ChainSafe, ChainSecurity, Chainsulting, CoinFabrik, ConsenSys Diligence, Dedaub, G0, Hacken, Haechi, Halborn, HashEx, Iosiro, Least Authority, MixBytes, NCC, NewAlchemy, OpenZeppelin, PeckShield, Pessimistic, PepperSec, Pickle, Quantstamp, QuillHash, Runtime Verification, Sigma Prime, SlowMist, SmartDec, Solidified, Somish, Trail of Bits and Zokyo.

## Smart contract security tools

Tools are critical in assisting smart contract developers and auditors with showcasing (potentially) exploitable vulnerabilities, highlighting dangerous programming styles or surfacing common patterns of misuse. None of these however replace the need for manual review/validation to evaluate contract-specific business logic and other complex control-flow, data-flow & value-flow aspects.

## Security tool categories

tools for testing, test coverage, linting, disassembling, visualization, static analysis, dynamic analysis and formal verification of smart contracts.

## Security tool summation

Smart contract security tools are useful in assisting auditors while reviewing smart contracts. They automate many of the tasks that can be codified into rules with different levels of coverage, correctness and precision. They are fast, cheap, scalable and deterministic compared to manual analysis. But they are also susceptible to false positives. They are especially well-suited currently to detect common security pitfalls and best-practices at the Solidity and EVM level. With varying degrees of manual assistance, they can also be programmed to check for application-level, business-logic constraints.
