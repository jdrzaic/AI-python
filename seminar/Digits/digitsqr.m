function [perc] = digitsqr(k) 
    % primjeri za ucenje
    load azip.mat
    A = azip;
    load dzip.mat
    D = dzip;

    % razdvajanje po znamenkama
    X = cell(10, 1);
    for i = 0:9
        X{i+1} = A(:,find(D == i));
    end

    % SVD
    QRs = cell(10, 3);
    for i = 1:10
        [QRs{i,:}] = qr(X{i});
    end

    % singularne vrijednosti
    %Sing = zeros(88, 10);
    %for i=1:10
    %Sing(:,i) = diag(QRs{i,2}(1:88,1:88));
    %end

    %Aprox = cell(10, 1);
    %for i = 1:10
    %    Aprox{i} = SVDs{i,1}(:,1:k) * SVDs{i,2}(1:k,1:k) * SVDs{i,3}(:,1:k)';
    %end

    % potprostori
    Us = cell(10, 1);
    for i=1:10
        Qs{i} = QRs{i,1}(:,1:k);
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
        Tmp = At - Qs{i} * (Qs{i}' * At);
        Dist(i,:) = diag(Tmp' * Tmp)';
    end

    [M, I] = min(Dist);
    sum((I - 1) == Dt) / s


