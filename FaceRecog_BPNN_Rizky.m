close all, clear all, clc, format compact
%Program Face Recognition
%NPM: 1506729033
%Penentuan Variable:

%Hasil Variabel yang akan diinput setelah PCA:
    run('readFile_rizky.m');
    run('pca_rizky.m');

    %Inisialisasi Variable Dasar Neural Network
    input_layer = pca_Dim;
    hidden_layer = input('Masukkan Hidden Layer = ');
    output_layer = 10;

    %Inisialisasi Alpha dan Miu untuk Backpropagation
    prompt = 'Input Nilai Alpha: '; 
    alpha = input(prompt);
    prompt = 'Input Nilai Miu: ';
    miu = input(prompt);
    
    %Inisialisasi Bobot dan Bias
    prompt = 'Pilih Metode Inisialisasi:\n1.Rand;\n2.Nguyen Widrow\n input: ';
    switch(input(prompt));
        case 1
            %Inisialisasi Random
            vij = rand(input_layer,hidden_layer) - 0.5;
            voj = rand(1,hidden_layer) - 0.5;
            wjk = rand(hidden_layer,output_layer) - 0.5;
            wok = rand(1,output_layer) - 0.5;
            type = 'Random';
        case 2
            %Inisialisasi NguyenWidrow
            %Inisialisasi Input-Hidden Untuk Nguyen Widrow
            type = 'NguyenWidrow';
            beta = 0.7*(input_layer)^(1/hidden_layer);
            vij = rand(input_layer,hidden_layer) - 0.5;
            voj = zeros(1,hidden_layer);
            s = 0;
            for i=1:input_layer
                for j=1:hidden_layer
                    s = s + (vij(i,j)^2);
                end
                s = sqrt(s);
                for j=1:hidden_layer
                    vij(i,j) = (beta*vij(i,j))/s;  
                end
                s = 0;
            end
            for j=1:hidden_layer
               voj(j) = (beta-(-beta))*rand(1) + (-beta); 
            end

            %Inisialisasi Hidden-Output Untuk Nguyen Widrow
            beta = 0.7*(hidden_layer)^(1/output_layer);
            wjk = rand(hidden_layer,output_layer) - 0.5;
            wok = zeros(1,output_layer);
            s = 0;
            for i=1:hidden_layer
                for j=1:output_layer
                    s = s + (wjk(i,j)^2);
                end
                s = sqrt(s);
                for j=1:output_layer
                    wjk(i,j) = (beta*wjk(i,j))/s;  
                end
                s = 0;
            end
            for j=1:output_layer
               wok(j) = (beta-(-beta))*rand(1) + (-beta); 
            end
    end


    
    
%Pembagian Data Training dan Data 
    train_data = pca_Data(1:2:totalImage,:);
    train_target = target_all_foto(1:2:totalImage,:);
    test_data = pca_Data(2:2:totalImage,:);
    test_target = target_all_foto(2:2:totalImage,:);

%BackPropagation:
    %Membuat matriks untuk delta saat backward
    deltaij = zeros(input_layer,hidden_layer);
    deltajk = zeros(hidden_layer,output_layer);
    deltaoj = zeros(hidden_layer);
    deltaok = zeros(output_layer);
    %Setting Variabel Error
    %Epoch Target:
    
    target_epoch = input('Test berapa generasi = ');
        
    %BackPropagation:
    for epoch = 1:target_epoch
        error_train = zeros(totalImage/2,1);
        disp(epoch);
        for iter = 1:totalImage/2
           %Feed Forward: 
           x = train_data(iter,:);
           z_in = voj + (x * vij);

           %Menghitung nilai aktifasi Hidden Layer;
           for j = 1:hidden_layer
               z(j) = sigmoid(z_in(j));
           end
           
           y_in = wok + (z * wjk);
           for k = 1:output_layer
               y(k) = sigmoid(y_in(k));
           end

           %Menyimpan Nilai Error dengan fungsi error kuadratis
           for n = 1:output_layer
                error_train(iter) = error_train(iter) + (0.5 * (train_target(iter,n) - y(n))^2);
           end

           %Backpropagation dari Output ke Hidden
           %Menghitung Informasi Error
           for k = 1:output_layer
               dk(k) = (train_target(iter,k)-y(k)) * y(k) * (1 - y(k));
           end

           %Menghitung Besarnya Koreksi Bobot Unit Output:
           for j = 1:hidden_layer
                for k = 1:output_layer
                    deltajk(j,k) = alpha * dk(k) * z(j) + miu * deltajk(j,k);
                end
           end

           %Perhitungan koreksi bobot bias output
           for k = 1:output_layer
               deltaok(k) = alpha * dk(k) + miu * deltaok(k);
           end

           %Backprop Hidden ke Input
            %Menghitung informasi error
            for j = 1:hidden_layer
                din_j(j) = 0;
                for k = 1:output_layer
                    din_j(j) = din_j(j) + dk(k) * wjk(j,k);
                end
                dj(j) = din_j(j) * z(j) * (1 - z(j));
            end

            %Perhitungan koreksi bobot unit hidden
            for i = 1:input_layer
                for j = 1:hidden_layer
                    deltaij(i,j) = alpha * dj(j) * x(i) + miu * deltaij(i,j);
                end
            end

            %Perhitungan koreksi bobot bias hidden
            for j = 1:hidden_layer
                deltaoj(j) = alpha * dj(j) + miu * deltaoj(j);
            end

            %Update bobot unit output
            for j = 1:hidden_layer
                for k = 1:output_layer
                    wjk(j,k) = wjk(j,k) + deltajk(j,k);
                end
            end

            %Update bobot bias output
            for k = 1:output_layer
                wok(k) = wok(k) + deltaok(k);
            end

            %Update bobot unit hidden
            for i = 1:input_layer
                for j = 1:hidden_layer
                    vij(i,j) = vij(i,j) + deltaij(i,j);
                end
            end

            %Update bobot bias hidden
            for j = 1:hidden_layer
                voj(j) = voj(j) + deltaoj(j);
            end
        end
        err_avg(epoch) = mean(error_train);
    end
    
    l = 1:target_epoch;
    plot(l,err_avg);
    xlabel('Generation');
    ylabel('Error');
    
%Testing:
%testing backprop
%Mengreserve matrix untuk Berhasilnya Rekognisi
r = zeros(1,10);
recognition = zeros(totalImage/2,1);

%Proses Testing = FeedForward
for iter = 1:totalImage/2
    %Variabel untuk mengecek hasil testing benar atau salah
    benar = 0;
    salah = 0;
    %Mengirim Unit Input
    x(1:input_layer) = test_data(iter,1:input_layer);
    
    %Feedforward dari input ke hidden
    z_in = voj + (x * vij);
    
    %Menghitung nilai aktifasi Hidden Layer;
    for j = 1:hidden_layer
        z(j) = sigmoid(z_in(j));
    end
    
    %Feedforward dari hidden ke output
    y_in = wok + (z * wjk);
    
    %Menghitung Nilai Aktifasi Output Layer
    for k = 1:output_layer
        y(k) = sigmoid(y_in(k));
    end
    
    %Memisahkan supaya nilai Max dari output dijadikan 1 dan lainnya 0
    for k = 1:output_layer
        if y(k) == max(y)
            r(1,k) = 1;
        else
            r(1,k) = 0;
        end
    end
    
    %Mencocokan Variable dengan hasil yang diharapkan
    %apabila benar, counter benar bertambah hingga max 3
    for i = 1:output_layer
        %Apabila nilai output ke-i sama dengan target,
        %variabel benar bertambah 1
        if r(1,i) == test_target(iter,i)
            benar = benar + 1;
        %Apabila tidak, variabel salah bertambah 1
        else
            salah = salah + 1;
        end
    end
    
    %Jika Variabel Benar == 3, berarti sesuai dengan target
    %Variabel Recognition di set 1 pada sel generasi untuk menunjukan
    %berhasil
    if benar == 10
        recognition(iter) = 1;
    end
end

%Penghitungan recognition rate
rr = sum(recognition)/(totalImage/2);
txt = sprintf('Total Generasi = %d\nError: MAX = %.2f%%;MIN = %.2f%%\nTotal Berhasil = %d dari 100\nKeberhasilan = %f%%',epoch,max(err_avg)*100,min(err_avg)*100,sum(recognition),rr*100);
clc;
display(txt);
        
   

