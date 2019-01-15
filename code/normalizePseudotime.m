function X = normalizePseudotime(X)
maxPT = 0;
for i = 1:length(X)
    maxPT = max(maxPT,X{i}(2,end));
end
for i = 1:length(X)
    X{i}(2,:) = X{i}(2,:)/maxPT*100;
end