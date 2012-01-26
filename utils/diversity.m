function diversity = diversity(patches)

normC = zeros(size(patches));
for col = 1:size(patches,2);
    newCol = patches(:,col);
    normC(:,col) = newCol/norm(newCol);
end
autocorrelation = normC'*normC;
autocorrelationangles = acos(autocorrelation);
diversity = norm(autocorrelationangles);
