%Self Organizing Map

close all, clear all, clc, format compact
tic;

n = 100 %jumlah input
%----------------PERSIAPAN DATA----------------------%
%Reading Data:
    data_all = zeros(160,1600);
    counter = 1;
    D = 'DatasetFR';
    J = dir(fullfile(D,'*.jpg')); % pattern to match filenames.
    for k = 1:numel(J)
        F = fullfile(D,J(k).name);
        I = imread(F);
        a = transpose(im2double(I));
        a = transpose(a(:));
        data_all(counter,:) = a;
        counter = counter+1;
    end

    P = dir(fullfile(D,'*.png')); % pattern to match filenames.
    for k = 1:numel(P)
        F = fullfile(D,P(k).name);
        I = imread(F);
        a = transpose(im2double(I));
        a = transpose(a(:));
        data_all(counter,:) = a;
        counter = counter+1;
    end
    
    
%Standarisasi Data
    dataIn_std = zscore(data_all);
    
%Mencari Data Covariance:
    cIn = cov(dataIn_std);

%Proses PCA:
    %Eigen Value Decomposition:
    [V, D] = eig(cIn);

    %Perubahan Letak Eigenvektor Berdasarkan EigenValue:
    D2=diag(sort(diag(D),'descend'));
    [c, ind]=sort(diag(D),'descend');
    V2=V(:,ind);
    
    %Hasil Variabel yang akan diinput setelah PCA:
    new_data = dataIn_std * V2(:, 1:n);
    
%Pemberian Nilai Benar untuk tiap Data:
    % output class: a=aaliyah, b=albert, c=fahmi, d=jan, e=johanes,
    % f=nadhif, g=tiwi,h=rizky
    temp(1:8,1:8) = 0;
    for i=1:1:8
        temp(i,i) = 1;
    end
    output = zeros(160,8);
    counter = 0;
    for i=1:8
        for j=1:20
            output(counter+j,:) = temp(i,:);
        end
        counter = counter+j;
    end
 
%----------------------- Pembelajaran LVQ ---------------------------% 
