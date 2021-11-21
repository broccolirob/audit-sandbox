# Summation

## Presenting proof-of-concept exploits

Exploits are incidents where vulnerabilities are triggered by malicious actors to misuse smart contracts resulting, for example, in stolen/frozen assets.

1. Presenting proof-of-concepts of such exploits either in code or written descriptions of hypothetical scenarios make audit findings more realistic and relatable by illustrating specific exploit paths and justifying severity of findings.
2. Codified exploits should always be on a testnet, kept private and responsibly disclosed to project teams without any risk of being actually executed on live systems resulting in real loss of funds or access.
3. Descriptive exploit scenarios should make realistic assumptions on roles/powers of actors, practical reasons for their actions and sequencing of events that trigger vulnerabilities and illustrate the paths to exploitation.

## Estimating the likelihood and impact

Likelihood indicates the probability of a vulnerability being discovered by malicious actors and triggered to successfully exploit the underlying weakness. Impact indicates the magnitude of implications on the technical and business aspects of the system if the vulnerability were to be exploited. Estimating if likelihood/impact are low/medium/high is non-trivial in many cases.

1. If the exploit can be triggered by a few transactions manually without requiring much resources/access (e.g. not admin) and without assuming many conditions to hold true then the likelihood is evaluated as High. Exploits that require deep knowledge of the system workings, privileged roles, large resources or multiple edge conditions to hold true are evaluated as Medium likelihood. Others that require even harder assumptions to hold true, miner collusion, chain forks or insider collusion for e.g., are considered as Low likelihood.
2. If there is any loss or locking up of funds then the impact is evaluated as High. Exploits that do not affect funds but disrupt the normal functioning of the system are typically evaluated as Medium. Anything else is of Low impact.
3. Many likelihood and impact evaluations are contentious and debatable between the audit and project teams, typically with security-conscious audit teams pressing for higher likelihood and impact and project teams downplaying the risks.

Estimating the severity: Severity, per OWASP, is a combination of likelihood and impact. With reasonable evaluations of those two, severity estimates from the OWASP matrix should be straightforward.

## Summary

Audits are a time, resource and expertise bound effort where trained experts evaluate smart contracts using a combination of automated and manual techniques to find as many vulnerabilities as possible. Audits can show the presence of vulnerabilities but not their absence.
