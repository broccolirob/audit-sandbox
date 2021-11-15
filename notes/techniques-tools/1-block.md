# Block One

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

## Audit Reports

Reports include details of the scope, goals, effort, timeline, approach, tools/techniques used, findings summary, vulnerability details, vulnerability classification, vulnerability severity/difficulty/likelihood, vulnerability exploit scenarios, vulnerability fixes and informational recommendations/suggestions on programming best-practices.

## Audit Findings Classification

The vulnerabilities found during the audit are typically classified into different categories which helps to understand the nature of the vulnerability, potential impact/severity, impacted project components/functionality and exploit scenarios. Trail of Bits, for example, uses the below classification:

1. Access Controls: Related to authorization of users and assessment of rights.
2. Auditing and Logging: Related to auditing of actions or logging of problems.
3. Authentication: Related to the identification of users.
4. Configuration: Related to security configurations of servers, devices or software.
5. Cryptography: Related to protecting the privacy or integrity of data.
6. Data Exposure: Related to unintended exposure of sensitive information.
7. Data Validation: Related to improper reliance on the structure or values of data.
8. Denial of Service: Related to causing system failure.
9. Error Reporting: Related to the reporting of error conditions in a secure fashion.
10. Patching: Related to keeping software up to date.
11. Session Management: Related to the identification of authenticated users.
12. Timing: Related to race conditions, locking or order of operations.
13. Undefined Behavior: Related to undefined behavior triggered by the program.

## Audit Findings Likelihood/Difficulty

Per [OWASP](https://owasp.org/www-community/OWASP_Risk_Rating_Methodology), likelihood or difficulty is a rough measure of how likely or difficult this particular vulnerability is to be uncovered and exploited by an attacker. OWASP proposes three Likelihood levels of Low, Medium and High. Trail of Bits, for example, classifies every finding into four difficulty levels:

1. Undetermined: The difficulty of exploit was not determined during this engagement.
2. Low: Commonly exploited, public tools exist or can be scripted that exploit this flaw.
3. Medium: Attackers must write an exploit, or need an in-depth knowledge of a complex system.
4. High: The attacker must have privileged insider access to the system, may need to know extremely complex technical details or must discover other weaknesses in order to exploit this issue.

## Audit Findings Impact

Per OWASP, this estimates the magnitude of the technical and business impact on the system if the vulnerability were to be exploited. OWASP proposes three Impact levels of Low, Medium and High.

## Audit Findings Severity

Per OWASP, the Likelihood estimate and the Impact estimate are put together to calculate an overall Severity for this risk. This is done by figuring out whether the Likelihood is Low, Medium, or High and then do the same for impact.

1. OWASP proposes a 3x3 Severity Matrix which combines the three Likelihood levels with the three Impact levels.
2. Severity Matrix (Likelihood-Impact = Severity): Low-Low = Note; Low-Medium = Low; Low-High = Medium; Medium-Low = Low; Medium-Medium = Medium; Medium-High = High; High-Low = Medium; High-Medium = High; High-High = Critical;
3. Trail of Bits uses:
   - Informational: The issue does not pose an immediate risk, but is relevant to security best practices or Defence in Depth.
   - Undetermined: The extent of the risk was not determined during this engagement.
   - Low: The risk is relatively small or is not a risk the customer has indicated is important.
   - Medium: Individual user’s information is at risk, exploitation would be bad for client’s reputation, moderate financial impact, possible legal implications for client.
   - High: Large numbers of users, very bad for client’s reputation, or serious legal or financial implications.
4. ConsenSys uses:
   - Minor: issues are subjective in nature. They are typically suggestions around best practices or readability. Code maintainers should use their own judgment as to whether to address such issues.
   - Medium: issues are objective in nature but are not security vulnerabilities. These should be addressed unless there is a clear reason not to.
   - Major: issues are security vulnerabilities that may not be directly exploitable or may require certain conditions in order to be exploited. All major issues should be addressed.
   - Critical: issues are directly exploitable security vulnerabilities that need to be fixed.

## Audit Checklist For Projects

[Trail of Bits recommendations](https://blog.trailofbits.com/2018/04/06/how-to-prepare-for-a-security-audit/)

1. Resolve the easy issues: 1) Enable and address every last compiler warning 2) Increase unit and feature test coverage 3) Remove dead code, stale branches, unused libraries, and other extraneous weight.
2. Document: 1) Describe what your product does, who uses it, why, and how it delivers. 2) Add comments about intended behavior in-line with the code. 3) Label and describe your tests and results, both positive and negative. 4) Include past reviews and bugs.
3. Deliver the code batteries included: 1) Document the steps to create a build environment from scratch on a computer that is fully disconnected from your internal network 2) Include external dependencies 3) Document the build process, including debugging and the test environment 4) Document the deployment process and environment, including all the specific versions of external tools and libraries for this process.

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
