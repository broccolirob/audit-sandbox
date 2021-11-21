# Reporting Mistakes

## False positives

False positives are findings which indicate the presence of vulnerabilities but which in fact are not vulnerabilities. Such false positives could be due to incorrect assumptions or simplifications in analysis which do not correctly consider all the factors required for the actual presence of vulnerabilities.

1. False positives require further manual analysis on findings to investigate if they are indeed false or true positives.
2. High number of false positives increases manual effort in verification and lowers the confidence in the accuracy of the earlier automated/manual analysis.
3. True positives might sometimes be classified as false positives which leads to vulnerabilities being exploited instead of being fixed.

## False negatives

False negatives are missed findings that should have indicated the presence of vulnerabilities but which are in fact are not reported at all. Such false negatives could be due to incorrect assumptions or inaccuracies in analysis which do not correctly consider the minimum factors required for the actual presence of vulnerabilities.

1. False negatives, per definition, are not reported or even realized unless a different analysis reveals their presence or the vulnerabilities are exploited.
2. High number of false negatives lowers the confidence in the effectiveness of the earlier manual/automated analysis.
