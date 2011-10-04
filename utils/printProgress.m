function printProgress(iCurrent, nTotal, printEvery)
% printProgress(iCurrent, nTotal, printEvery)
% prints the progress of a long loop

notNumPrint = (mod(iCurrent, printEvery) ~= 0);
notFinal = (iCurrent ~= nTotal);

if notNumPrint && notFinal
    fprintf('.');
else
    fprintf('%d\n', iCurrent);
end