# Manual Review Process

## Manual review approaches

Auditors have different approaches to manual reviewing smart contract code for vulnerabilities.

1. Starting with access control
2. Starting with asset flow
3. Starting with control flow
4. Starting with data flow
5. Inferring constraints
6. Understanding dependencies
7. Evaluating assumptions
8. Evaluating security checklists

## Starting with access control

Access control is the most fundamental security primitive which addresses ‘who’ has authorized access to ‘what.’ (In a formal access control model, the ‘who’ refers to subjects, ’what’ refers to objects and an access control matrix indicates the permissions between subjects and objects.)

1. While the overall philosophy might be that smart contracts are permissionless, in reality, they do indeed have different permissions/roles for different actors who interact/use them.
2. The general classification is that of users and admin(s). For purposes of guarded launch or otherwise, many smart contracts have an admin role that is typically the address that deployed the contract. Admins typically have control over critical configuration and application parameters including (emergency) transfers/withdrawals of contract funds.
3. Starting with understanding the access control implemented by the smart contracts and checking if they have applied correctly, completely and consistently is a good approach to understanding access flow and detecting violations.

## Starting with asset flow

Assets are Ether or ERC20/ERC721/other tokens managed by smart contracts. Given that exploits target assets of value, it makes sense to start evaluating the flow of assets into/outside/within/across smart contracts and their dependencies.

1. Who: Assets should be withdrawn/deposited only by authorized/specified addresses as per application logic.
2. When: Assets should be withdrawn/deposited only in authorized/specified time windows or under authorized/specified conditions as per application logic (when).
3. Which: Assets, only those authorized/specified types, should be withdrawn/deposited as per application logic.
4. Why: Assets should be withdrawn/deposited only for authorized/specified reasons as per application logic.
5. Where: Assets should be withdrawn/deposited only to authorized/specified addresses as per application logic.
6. What type: Assets, only of authorized/specified types, should be withdrawn/deposited as per application logic.
7. How much: Assets, only in authorized/specified amounts, should be withdrawn/deposited as per application logic.

## Evaluating control flow

Control flow analyzes the transfer of control, i.e. execution order, across and within smart contracts.

1. Inter-procedural (procedure is just another name for a function) control flow is typically indicated by a call graph which shows which functions (callers) call which other functions (callees), across or within smart contracts.
2. Intra-procedural (i.e. within a function) control flow is dictated by conditionals (if/else), loops (for/while/do/continue/break) and return statements.
3. Both intra and inter-procedural control flow analysis help track the flow of execution and data in smart contracts.

## Evaluating data flow

Data flow analyzes the transfer of data across and within smart contracts.

1. Inter-procedural data flow is evaluated by analyzing the data (variables/constants) used as argument values for function parameters at call sites.
2. Intra-procedural data flow is evaluated by analyzing the assignment and use of (state/memory/calldata) variables/constants along the control flow paths within functions.
3. Both intra and inter-procedural data flow analysis help track the flow of global/local storage/memory changes in smart contracts.

## Inferring constraints

Program constraints are basically rules that should be followed by the program. Language-level and EVM-level security constraints are well-known because they are part of the language and EVM specification. However, application-level constraints are rules that are implicit to the business logic implemented and may not be explicitly described in the specification e.g. mint an ERC-721 token to the address when it makes a certain deposit of ERC-20 tokens to the smart contract and burn it when it withdraws the earlier deposit. Such constraints may have to be inferred by the auditors while manually analyzing the smart contract code.

1. One approach to inferring program constraints is to evaluate what is being done on most program paths related to a particular logic and treat it as a constraint. If such a constraint is missing on one or very few program paths then it could be an indicator of a vulnerability (assuming the constraint is security-related) or those program paths are exceptional conditions where the constraints do not need to hold.
2. Program constraints can also be verified using a symbolic checker which generates counter-examples or witnesses along execution paths where such constraints do not hold.

## Understanding dependencies

Dependencies exist when the correct compilation or functioning of program code relies on code/data from other smart contracts that were not necessarily developed by the project team.

1. Explicit program dependencies are captured in the import statements and the inheritance hierarchy. For e.g., many projects use the community-developed, audited and time-tested smart contracts from OpenZeppelin for tokens, access control, proxy, security etc.
2. Composability is expected and encouraged via smart contracts interfacing with other protocols and vice-versa, which results in emergent or implicit dependencies on the state/logic of external smart contracts via oracles for example.
3. This is especially of interest/concern in DeFi protocols that rely on other related protocols for stablecoins, yield generation, borrowing/lending, derivatives, oracles etc.

## Evaluating assumptions

Many security vulnerabilities result from faulty assumptions e.g. who can access what and when, under what conditions, for what reasons etc. Identifying the assumptions made by the program code and evaluating if they are indeed correct can be the source of many audit findings. Some common examples of faulty assumptions are:

1. Only admins can call these functions.
2. Initialization functions will only be called once by the contract deployer (e.g. for upgradeable contracts).
3. Functions will always be called in a certain order (as expected by the specification).
4. Parameters can only have non-zero values or values within a certain threshold e.g. addresses will never be zero valued.
5. Certain addresses or data values can never be attacker controlled. They can never reach program locations where they can be misused. (In program analysis literature, this is known as taint analysis)
6. Function calls will always be successful and so checking for return values is not required.

## Evaluating security checklists

Checklists are lists of itemized points that can be quickly and methodically followed (and referenced later by their list number) to make sure all listed items have been processed according to the domain of relevance.

1. This checklist-based approach was made popular in the book “The Checklist Manifesto. How to Get Things Right” by Atul Gawande who is a noted surgeon, writer and public health leader. In his review of this book, Malcolm Gladwell writes that: “Gawande begins by making a distinction between errors of ignorance (mistakes we make because we don’t know enough), and errors of ineptitude (mistakes we made because we don’t make proper use of what we know). Failure in the modern world, he writes, is really about the second of these errors, and he walks us through a series of examples from medicine showing how the routine tasks of surgeons have now become so incredibly complicated that mistakes of one kind or another are virtually inevitable: it’s just too easy for an otherwise competent doctor to miss a step, or forget to ask a key question or, in the stress and pressure of the moment, to fail to plan properly for every eventuality. Gawande then visits with pilots and the people who build skyscrapers and comes back with a solution. Experts need checklists–literally–written guides that walk them through the key steps in any complex procedure. In the last section of the book, Gawande shows how his research team has taken this idea, developed a safe surgery checklist, and applied it around the world, with staggering success.”
2. Given the mind-boggling complexities of the fast-evolving Ethereum infrastructure (new platforms, new languages, new tools and new protocols) and the risks associated with deploying smart contracts managing millions of dollars, there are so many things to get right with smart contracts that it is easy to miss a few checks, make incorrect assumptions or fail to consider potential situations. Smart contract experts therefore need checklists too.
3. Smart contract security checklists (such as the articles in this series) help in navigating the vast number of key aspects to be remembered and applied. They help in going over the itemized features, concepts, pitfalls, best-practices and examples in a methodical manner without missing any items. Checklists are known to increase retention and have a faster recall. They also help in referencing specific items of interest e.g. #42 in Security Pitfalls & Best Practices 101 or #98 in Audit Techniques & Tools 101.

## Presenting proof-of-concept exploits

Exploits are incidents where vulnerabilities are triggered by malicious actors to misuse smart contracts resulting, for example, in stolen/frozen assets.

1. Presenting proof-of-concepts of such exploits either in code or written descriptions of hypothetical scenarios make audit findings more realistic and relatable by illustrating specific exploit paths and justifying severity of findings.
2. Codified exploits should always be on a testnet, kept private and responsibly disclosed to project teams without any risk of being actually executed on live systems resulting in real loss of funds or access.
3. Descriptive exploit scenarios should make realistic assumptions on roles/powers of actors, practical reasons for their actions and sequencing of events that trigger vulnerabilities and illustrate the paths to exploitation.
