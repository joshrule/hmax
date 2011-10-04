function fi = fisher(target, distractor)

fi = (mean(target)-mean(distractor))^2 / (var(target) + var(distractor));