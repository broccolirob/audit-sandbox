# Trail of Bits Security Tools

## Slither

[Slither](https://github.com/crytic/slither) is a Solidity static analysis framework written in Python 3. It runs a suite of vulnerability detectors, prints visual information about contract details, and provides an API to easily write custom analyses. Slither enables developers to find vulnerabilities, enhance their code comprehension, and quickly prototype custom analyses. It implements [74 detectors](https://github.com/crytic/slither#detectors) in the publicly available free version (with [trophies](https://github.com/crytic/slither/blob/master/trophies.md) that showcase Slither findings in real-world contracts).

## Slither features

1. Detects vulnerable Solidity code with low false positives.
2. Identifies where the error condition occurs in the source code.
3. Easily integrates into continuous integration and Truffle builds.
4. Built-in 'printers' quickly report crucial contract information.
5. Detector API to write custom analyses in Python.
6. Ability to analyze contracts written with Solidity >= 0.4.
7. Intermediate representation (SlithIR) enables simple, high-precision analyses.
8. Correctly parses 99.9% of all public Solidity code.
9. Average execution time of less than 1 second per contract.

## Slither detectors

Slither bugs and optimizations detection can run on a Truffle/Embark/Dapp/Etherlime/Hardhat application or on a single Solidity file:

1. Slither runs all its detectors by default. To run only selected detectors, use `--detect detector1,detector2`. To exclude detectors, use `--exclude detector1,detector2`.
2. To exclude detectors with an informational or low severity, use `--exclude-informational` or `--exclude-low`.
3. `--list-detectors` lists available detectors.

## Slither printers

Slither printers allow printing contract information with `--print` and following options (with contract-summary, human-summary, and inheritance-graph for quick review, and others such as call-graph, cfg, function-summary and vars-and-auth for in-depth review):

1. call-graph: Export the call-graph of the contracts to a dot file.
2. cfg: Export the CFG of each functions.
3. constructor-calls: Print the constructors executed.
4. contract-summary: Print a summary of the contracts.
5. data-dependency: Print the data dependencies of the variables.
6. echidna: Export Echidna guiding information.
7. evm: Print the evm instructions of nodes in functions.
8. function-id: Print the keccack256 signature of the functions.
9. function-summary: Print a summary of the functions.
10. human-summary: Print a human-readable summary of the contracts.
11. inheritance: Print the inheritance relations between contracts.
12. inheritance-graph: Export the inheritance graph of each contract to a dot file.
13. modifiers: Print the modifiers called by each function.
14. require: Print the require and assert calls of each function.
15. slithir: Print the slithIR representation of the functions.
16. slithir-ssa: Print the slithIR representation of the functions.
17. variable-order: Print the storage order of the state variables.
18. vars-and-auth: Print the state variables written and the authorization of the functions.

## Slither upgradeability

Slither upgradeability checks helps review contracts that use the delegatecall proxy pattern using `slither-check-upgradeability` tool with following options:

1. became-constant: Variables that should not be constant.
2. function-id-collision: Functions ids collision.
3. function-shadowing: Functions shadowing.
4. missing-calls: Missing calls to init functions.
5. missing-init-modifier: initializer() is not called.
6. multiple-calls: Init functions called multiple times.
7. order-vars-contracts: Incorrect vars order with the v2.
8. order-vars-proxy: Incorrect vars order with the proxy.
9. variables-initialized: State variables with an initial value.
10. were-constant: Variables that should be constant.
11. extra-vars-proxy: Extra vars in the proxy.
12. missing-variables: Variable missing in the v2.
13. extra-vars-v2: Extra vars in the v2.
14. init-inherited: Initializable is not inherited.
15. init-missing: Initializable is missing.
16. initialize-target: Initialize function that must be called.
17. initializer-missing: initializer() is missing.

## Slither code similarity

Slither [code similarity detector](https://blog.trailofbits.com/2020/10/23/efficient-audits-with-machine-learning-and-slither-simil/) (a research-oriented tool) uses state-of-the-art machine learning to detect similar (vulnerable) Solidity functions

1. It uses a pre-trained model from etherscan_verified_contracts with 60,000 contracts and more than 850,000 functions.
2. It uses FastText, a vector embedding technique, to generate compact numerical representations of every function.
3. It has four modes: (1) `test` - finds similar functions to your own in a dataset of contracts (2) `plot` - provide a visual representation of similarity of multiple sampled functions (3) `train` - builds new models of large datasets of contracts (4) `info` - inspects the internal information of the pre-trained model or the assessed code.

## Slither flat

Slither contract flattening tool `slither-flat` produces a flattened version of the codebase with the following features:

1. Supports three strategies: 1) MostDerived: Export all the most derived contracts (every file is standalone) 2) OneFile: Export all the contracts in one standalone file 3) LocalImport: Export every contract in one separate file, and include import ".." in their preludes.
2. Supports circular dependency.
3. Supports all the compilation platforms (Truffle, embark, hardhat, etherlime, ...).

## Slither format

Slither format tool `slither-format` generates automatically patches. The patches are compatible with git. Patches should be carefully reviewed before applying. Detectors supported with this tool are:

1. unused-state
2. solc-version
3. pragma
4. naming-convention
5. external-function
6. constable-states
7. constant-function

## Slither check ERC

## Slither prop

## Slither custom detectors

## Manticore

## Echidna

## Echidna features

## Echidna usage

## Eth security toolbox

## Ethersplay

## Pyevmasm

## Rattle

## EVM cfg builder

## Crytic compile

## Solc select

## Etheno
