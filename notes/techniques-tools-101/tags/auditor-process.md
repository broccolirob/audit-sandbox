# Auditor Process

## Process overview

1. Read specification/documentation of the project to understand the requirements, design and architecture
2. Run fast automated tools such as linters or static analyzers to investigate common Solidity pitfalls or missing smart contract best-practices
3. Manual code analysis to understand business logic and detect vulnerabilities in it
4. Run slower but more deeper automated tools such as symbolic checkers, fuzzers or formal verification analyzers which typically require formulation of properties/constraints beforehand, hand holding during the analyses and some post-run evaluation of their results
5. Discuss (with other auditors) the findings from above to identify any false positives or missing analyses
6. Convey status to project team for clarifying questions on business logic or threat model
7. Iterate the above for the duration of the audit leaving some time for report writing
8. Write report summarizing the above with details on findings and recommendations
9. Deliver the report to the project team and discuss findings, severity and potential fixes
10. Evaluate fixes from the project team and verify that they indeed remove the vulnerabilities identified in findings.

## Reading specification/documentation

For projects that have a specification of the design and architecture of their smart contracts, this is the recommended starting point. Very few new projects have a specification at the audit stage. Some of them have documentation in parts. Some key points:

1. Specification starts with the project’s technical and business goals and requirements. It describes how the project’s design and architecture help achieve those goals.
2. The actual implementation of smart contracts is a functional manifestation of the goals, requirements, specification, design and architecture, understanding of which is critical in evaluating if the implementation indeed meets the goals and requirements
3. Documentation is a description of what has been implemented based on the design and architectural requirements.
4. Specification answers ‘why’ something needs to be designed/architected/implemented the way it has been done. Documentation answers ‘how’ something has been designed/architected/implemented without necessarily addressing the ‘why’ and leaves it up to the auditors to speculate on the reasons.
5. Documentation is typically in the form of Readme files describing individual contract functionality combined with functional NatSpec and individual code comments. Encouraging projects to provide a detailed specification and documentation saves a lot of time and effort for the auditors in understanding the project goals/structure and prevents them from making the same assumptions as the implementation which is a leading cause of vulnerabilities.
6. In the absence of both specification and documentation, auditors are forced to infer goals, requirements, design and architecture from reading code and using tools such as Surya and Slither printers. This takes up a lot of time leaving less time for deeper/complex security analyses.

## Running static analyzers

Automated tools such as linters or static analyzers help investigate common Solidity pitfalls or missing smart contract best-practices

1. Tools such as Slither and MythX perform control-flow and data-flow analyses on the smart contracts in the context of their detectors which encode common security pitfalls and best-practices.
2. Evaluating their findings, which are usually available in seconds/minutes, is a good starting point to detect common vulnerabilities based on well-known constraints/properties of Solidity language, EVM or Ethereum blockchain.
3. False positives are possible among some of the detector findings and need to be verified manually if they are true/false positives

## Manual code review

Manual code review is required to understand business logic and detect vulnerabilities in it.

1. Automated analyzers do not understand application-level logic and their constraints. They are limited to constraints/properties of Solidity language, EVM or Ethereum blockchain.
2. Manual analysis of the code is required to detect security-relevant deviations in implementation vis-a-vis the specification or documentation.
3. Auditors may need to infer business logic and their implied constraints directly from the code or from discussions with the project team and thereafter evaluate if those constraints/properties hold in all parts of the codebase.

## Running deeper automated tools

Running deeper automated tools such as fuzzers e.g. Echidna, symbolic checkers such as Manticore, tool suite such as MythX and formally verifying custom properties with Scribble or Certora Prover takes more setup and preparation time but helps run deeper analyses to discover edge-cases in application-level properties and mathematical errors, among other things.

1. Given these require understanding of the project’s application logic, they are recommended to be used at least after an initial manual code review or sometimes after deeper discussion about the specification/implementation with the project team.
2. Analyzing the output of these tools requires significant expertise with the tools themselves, their domain-specific language and sometimes even their inner workings
3. Evaluating false-positives is sometimes challenging with these tools but the true positives they discover are significant and extreme corner cases missed even by the best manual analyses

## Brainstorming with other auditors

[Linus' law](https://en.wikipedia.org/wiki/Linus's_law): "Given enough eyeballs, all bugs are shallow” might apply with auditors too if they brainstorm on the smart contract implementation, assumptions, findings and vulnerabilities.

1. While some audit firms encourage active/passive discussion, there are others whose approach is to let auditors separately perform the assessment to encourage independent thinking instead of group thinking. The premise is that group thinking might bias the audit team to focus on certain aspects while missing some vulnerabilities.
2. A hybrid approach might be interesting where the audit team initially brainstorms to discuss the project’s goals, specification/documentation and implementation but later firewall themselves to independently pursue the assessments and finally come together to compile their findings.

## Discussion with project team

A hybrid approach might be interesting where the audit team initially brainstorms to discuss the project’s goals, specification/documentation and implementation but later firewall themselves to independently pursue the assessments and finally come together to compile their findings.

1. Findings may also be shared with the project team immediately on a private repository to discuss impact, fixes and other implications.
2. If the audit spans multiple weeks, it may help to have a weekly sync up call. A counterpoint to this is to independently perform the entire assessment so as to not get biased by the project team’s inputs and opinions.

## Report writing

The audit report is a final compilation of the entire assessment and presents all aspects of the audit including the audit scope/coverage, timeline, team/effort, summaries, tools/techniques, findings, exploit scenarios, suggested fixes, short-/long-term recommendations and any appendices with further details on tools and rationale.

1. An executive summary typically gives an overview of the audit report with highlights/lowlights illustrating the number/type/severity of vulnerabilities found and an overall assessment of risk. It may also include a description of the smart contracts, (inferred) actors, assets, roles, permissions, access control, interactions, threat model and existing risk mitigation measures.
2. The bulk of the report focuses on the findings from the audit, their type/category, likelihood/impact, severity, justifications for these ratings, potential exploit scenarios, affected parts of smart contracts and potential remediations
3. It may also address subjective aspects of code quality, readability/auditability and other software-engineering best practices related to documentation, code structure, function/variable naming conventions, test coverage etc. that do not pose an imminent security risk but are indicators of anti-patterns and processes influencing the introduction and persistence of security vulnerabilities

## Report delivery

The delivery of the report to the project team is a critical deliverable and milestone. Unless interim findings/status is shared, this will be the first time the project team will have access to the assessment details.

1. The delivery typically happens via a shared online document and is accompanied with a readout where the auditors present the report highlights to the project team for discussion and any debate on findings and their severity ratings.
2. The project team typically takes some time to review the audit report and respond back with any counterpoints on findings, severities or suggested fixes.
3. Depending on the prior agreement, the project team and audit firm might release the audit report publicly (after all required fixes have been made) or the project may decide to keep it private for some reason.

## Evaluating fixes

Post audit, the project team may work on any required fixes for reported findings and request the audit firm for reviewing their responses.

1. Fixes may be applied for a majority of the findings and the review may need to confirm that applied fixes (could be different from audit’s recommended fixes) indeed mitigate the risk reported by the findings.
2. Findings may be contested as not being relevant, outside the project’s threat model or simply acknowledged as being within the project’s acceptable risk model.
3. Audit firms may evaluate the specific fixes applied and confirm/deny their risk mitigation. Unless it is a fix/retainer type audit, this phase typically takes not more than a day because it would usually be outside the agreed upon duration of the audit.
