# Audit Techniques

## Audit Techniques

Techniques involve a combination of different methods that are applied to the project codebase with accompanying specification and documentation. Many are automated analyses performed with tools and some require manual assistance.

1. Specification analysis (manual)
2. Documentation analysis (manual)
3. Testing (automated)
4. Static analysis (automated)
5. Fuzzing (automated)
6. Symbolic checking (automated)
7. Formal verification (automated)
8. Manual analysis (manual)

One may also think of these as manual/semi-automated/fully-automated, where the distinction between semi-automated and fully-automated is the difference between a tool that requires a user to define properties versus a tool that requires (almost) no user configuration except to triage results. Fully-automated tools tend to be straightforward to use, while semi-automated tools require some human assistance and are therefore more resource-expensive.

## Specification analysis

Specification describes in detail what (and sometimes why) the project and its various components are supposed to do functionally as part of their design and architecture.

1. From a security perspective, it specifies what the assets are, where they are held, who are the actors, privileges of actors, who is allowed to access what and when, trust relationships, threat model, potential attack vectors, scenarios and mitigations.
2. Analyzing the specification of a project provides auditors with the above details and lets them evaluate the assumptions made and indicate any shortcomings.
3. Very few smart contract projects have detailed specifications at their first audit stage. At best, they have some documentation about what is implemented. Auditors spend a lot of time inferring specification from documentation/implementation which leaves them with less time for vulnerability assessment.

## Documentation analysis

Documentation is a description of what has been implemented based on the design and architectural requirements.

1. Documentation answers ‘how’ something has been designed/architected/implemented without necessarily addressing the ‘why’ and the design/requirement goals.
2. Documentation is typically in the form of Readme files in the Github repository describing individual contract functionality combined with functional NatSpec and individual code comments.
3. Documentation in many cases serves as a substitute for specification and provides critical insights into the assumptions, requirements and goals of the project team.
4. Understanding the documentation before looking at the code helps auditors save time in inferring the architecture of the project, contract interactions, program constraints, asset flow, actors, threat model and risk mitigation measures.
5. Mismatches between the documentation and the code could indicate stale/poor documentation, software defects or security vulnerabilities.
6. Auditors are expected to encourage the project team to document thoroughly so that they do not need to waste their time inferring this by reading code.

## Testing

Software testing or validation is a well-known fundamental software engineering primitive to determine if software produces expected outputs when executed with different chosen inputs.

1. Smart contract testing has a similar motivation but is arguably more complicated despite their relatively smaller sizes (in lines of code) compared to Web2 software.
2. Smart contract development platforms (Truffle, Embark, Brownie, Waffle, Hardhat etc.) are relatively new with different levels of support for testing.
3. Projects, in general, have very little testing done at the audit stage. Testing integrations and composability with mainnet contracts and state is non-trivial.
4. Test coverage and test cases give a good indication of project maturity and also provide valuable insights to auditors into assumptions/edge-cases for vulnerability assessments.
5. Auditors should expect a high-level of testing and test coverage because this is a must-have software-engineering discipline, especially when smart contracts that are by-design exposed to everyone on the blockchain end up holding assets worth tens of millions of dollars.
6. "Program testing can be used to show the presence of bugs, but never to show their absence!” - E.W. Dijkstra

## Static analysis

Static analysis is a technique of analyzing program properties without actually executing the program.

1. This is in contrast to software testing where programs are actually executed/run with different inputs.
2. For smart contracts, static analysis can be performed on the Solidity code or on the EVM bytecode. [Slither](https://github.com/crytic/slither) performs static analysis at the Solidity level while [Mythril](https://github.com/ConsenSys/mythril) analyzes EVM bytecode.
3. Static analysis typically is a combination of control flow and data flow analyses.

## Fuzzing

[Fuzz testing](https://en.wikipedia.org/wiki/Fuzzing) is an automated software testing technique that involves providing invalid, unexpected, or random data as inputs to a computer program. The program is then monitored for exceptions such as crashes, failing built-in code assertions, or potential memory leaks.

1. Fuzzing is especially relevant to smart contracts because anyone can interact with them on the blockchain with random inputs without necessarily having a valid reason or expectation (arbitrary byzantine behavior)
2. [Echidna](https://github.com/crytic/echidna) and [Harvey](https://mariachris.github.io/Pubs/FSE-2020-Harvey.pdf) are two popular tools for smart contract fuzzing.

## Symbolic checking

[Symbolic checking](https://en.wikipedia.org/wiki/Model_checking#Symbolic_model_checking) is a technique of checking for program correctness, i.e. proving/verifying, by using symbolic inputs to represent set of states and transitions instead of enumerating individual states/transitions separately.

1. Model checking or property checking is a method for checking whether a finite-state model of a system meets a given specification (also known as correctness).
2. In order to solve such a problem algorithmically, both the model of the system and its specification are formulated in some precise mathematical language. To this end, the problem is formulated as a task in logic, namely to check whether a structure satisfies a given logical formula.
3. A simple model-checking problem consists of verifying whether a formula in the propositional logic is satisfied by a given structure.
4. Instead of enumerating reachable states one at a time, the state space can sometimes be traversed more efficiently by considering large numbers of states at a single step. When such state space traversal is based on representations of a set of states and transition relations as logical formulas, binary decision diagrams (BDD) or other related data structures, the model-checking method is symbolic.
5. Model-checking tools face a combinatorial blow up of the state-space, commonly known as the state explosion problem, that must be addressed to solve most real-world problems.
6. Symbolic algorithms avoid explicitly constructing the graph for the finite state machines (FSM); instead, they represent the graph implicitly using a formula in quantified propositional logic.

## Formal verification

[Formal verification](https://en.wikipedia.org/wiki/Formal_verification) is the act of proving or disproving the correctness of intended algorithms underlying a system with respect to a certain formal specification or property, using formal methods of mathematics.

1. Formal verification is effective at detecting complex bugs which are hard to detect manually or using simpler automated tools.
2. Formal verification needs a specification of the program being verified and techniques to translate/compare the specification with the actual implementation.
3. [Certora’s](https://www.certora.com/) Prover and ChainSecurity’s VerX are examples of formal verification tools for smart contracts. KEVM from Runtime Verification Inc is a formal verification framework that models EVM semantics.

## Manual analysis

Manual analysis is complimentary to automated analysis using tools and serves a critical need in smart contract audits.

1. Automated analysis using tools is cheap (typically open-source free software), fast, deterministic and scalable (varies depending on the tool being semi-/fully-automated) but however is only as good as the properties it is made aware of, which is typically limited to Solidity and EVM related constraints.
2. Manual analysis with humans, in contrast, is expensive, slow, non-deterministic and not scalable because human expertise in smart contact security is a rare/expensive skill set today and we are slower, prone to error and inconsistent.
3. Manual analysis is however the only way today to infer and evaluate business logic and application-level constraints which is where a majority of the serious vulnerabilities are being found.
