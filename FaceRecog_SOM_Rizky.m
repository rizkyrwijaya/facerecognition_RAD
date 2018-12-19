close all, clear all, clc, format compact
%Program Face Recognition
%NPM: 1506729033
%Penentuan Variable:

%Hasil Variabel yang akan diinput setelah PCA:
    run('readFile_rizky.m');
    run('pca_rizky.m');

%Inisialisasi Variabel untuk SOM
    feature = pca_Dim;
    cluster = 10;
   
    total_train = 0.5*totalImage;
    total_test = 0.5*totalImage;
    
    %inisialisasi alpha, decaying rate, dan alpha rate
    alpha = 0.5; 
    decay_rate = 0.5;
    alpha_target = 0.01;

    %Pembagian Data Training dan Data 
    train_data = pca_Data(1:2:totalImage,:);
    test_data = pca_Data(2:2:totalImage,:);
    test_target = target_all_foto(2:2:totalImage,:);
    
%SOM Proses
    %Inisialisasi Bobot vektor dengan mengambil perwakilan:
    W = zeros(cluster,feature);
    for m = 1:cluster
        W(m,:) = train_data(randi(cluster-1)+(cluster*(m-1)),:);
    end
    
    %Inisialisasi Variabel
    epoch = 0;
    
    %SOM Training
    while true
        %penambahan epoch tiap training:
        epoch = epoch + 1;
        
        %train sebanyak data dalam epoch
        for n=1:total_train
            
            %Perhitiungan Euclidean distance antara vektor input dengan
            %tiap bobot
            d = zeros(cluster,1);
            for m=1:cluster
                for k=1:feature
                    d(m) = d(m) + (W(m,k) - train_data(n,k))^2;
                end
                d(m) = d(m)^0.5;
            end
            
            %Mencari Index Minimum:
            [d_min, d_min_index] = min(d);
            
            %Update Bobot:
            W(d_min_index,:) = W(d_min_index,:) + (alpha*(train_data(n,:) - W(d_min_index,:)));
        end
        
        %Modifikasi Laju Pembelajaran
        alpha = decay_rate*alpha;
        if alpha <= alpha_target
            break;
        end
    end
    
    %SOM Testing:
    RR = 0;
    for n=1:total_test
        %Menghitung Euclidean Antara Vektor
         d = zeros(cluster,1);
        for m=1:cluster
            for k=1:feature
                d(m) = d(m) + (W(m,k) - train_data(n,k))^2;
            end
            d(m) = d(m)^0.5;
        end
        
        %Mencari Index Minimum
        [d_min, d_min_index] = min(d);
        
        %Pengecekan dengan data target
        if test_target(n,d_min_index) == 1
            RR = RR + 1;
        end
    end
    RRpersen = RR/100;
    fprintf('RR = %d/100\nRate = %.2f%%\nTotal Epoch = %d\n',RR,RRpersen*100,epoch)
    
  
    
    