# Audit Reports

## Audit reports

Reports include details of the scope, goals, effort, timeline, approach, tools/techniques used, findings summary, vulnerability details, vulnerability classification, vulnerability severity/difficulty/likelihood, vulnerability exploit scenarios, vulnerability fixes and informational recommendations/suggestions on programming best-practices.

## Findings classification

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

## Findings likelihood/difficulty

Per [OWASP](https://owasp.org/www-community/OWASP_Risk_Rating_Methodology), likelihood or difficulty is a rough measure of how likely or difficult this particular vulnerability is to be uncovered and exploited by an attacker. OWASP proposes three Likelihood levels of Low, Medium and High. Trail of Bits, for example, classifies every finding into four difficulty levels:

1. Undetermined: The difficulty of exploit was not determined during this engagement.
2. Low: Commonly exploited, public tools exist or can be scripted that exploit this flaw.
3. Medium: Attackers must write an exploit, or need an in-depth knowledge of a complex system.
4. High: The attacker must have privileged insider access to the system, may need to know extremely complex technical details or must discover other weaknesses in order to exploit this issue.

## Findings impact

Per OWASP, this estimates the magnitude of the technical and business impact on the system if the vulnerability were to be exploited. OWASP proposes three Impact levels of Low, Medium and High.

## Findings severity

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
