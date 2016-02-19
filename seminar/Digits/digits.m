function [perc] = digits(k) 
    % baza za ucenje
    load azip.mat
    A = azip;
    load dzip.mat
    D = dzip;

    % razdvajanje na znamenke
    X = cell(10, 1);
    for i = 0:9
        X{i+1} = A(:,find(D == i));
    end

    % SVD
    SVDs = cell(10, 3);
    for i = 1:10
        [SVDs{i,:}] = svd(X{i});
    end

    % singularne vrijednosti
    Sing = zeros(88, 10);
    for i=1:10
    Sing(:,i) = diag(SVDs{i,2}(1:88,1:88));
    end

    % potprostor
    Us = cell(10, 1);
    for i=1:10
        Us{i} = SVDs{i,1}(:,1:k);
    end

    % test primjeri
    load testzip.mat
    At = testzip;
    load dtest.mat
    Dt = dtest;

    [r, s] = size(At);
    Dist = zeros(10, s);

    % projekcije
    for i=1:10
        Tmp = At - Us{i} * (Us{i}' * At);
        Dist(i,:) = diag(Tmp' * Tmp)';
    end

    [M, I] = min(Dist);
    sum((I - 1) == Dt) / s


