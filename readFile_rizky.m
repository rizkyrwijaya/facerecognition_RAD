%Script untuk Menjalankan pembacaan file dan menjadikan array
%Rizky Ramadian Wijaya
%NPM: 1506729033

%Setting Variabel buat file:
    data_all_foto = zeros(200,1600);
    target_all_foto = zeros(200,10);

%Membaca semua file foto yang ada di folder
    disp('datasetIR = 1, datasetTekkom = 2');
    pilDataset = input('Pilih Dataset = ');
    switch(pilDataset)
        case 1
            dataset = 'dataset_IR';
            %Setting Variabel buat file:
                data_all_foto = zeros(200,1200);
                [data_size, data_dim] = size(data_all_foto);
                target_all_foto = zeros(200,10);
        case 2
            dataset = 'dataset_tekkom2018';
            %Setting Variabel buat file:
                data_all_foto = zeros(200,1600);
                [data_size, data_dim] = size(data_all_foto);
                target_all_foto = zeros(200,10);
        otherwise
            dataset = 'dataset_IR';
    end
    fprintf('Using dataset %s\n',dataset);
    file = dir(dataset);
    counter = 1;
    for i = 3:numel(file)
        temp_foto = dir(fullfile(dataset,file(i).name,'*.png'));
        if numel(temp_foto) == 0
        temp_foto = dir(fullfile(dataset,file(i).name,'*.jpg'));
        end
        for j = 1:numel(temp_foto)
            imgFile = fullfile(dataset,file(i).name,temp_foto(j).name);
            img = imread(imgFile);
            img_double = im2double(img(:,:,1));
            img_double_t = transpose(img_double);
            img_final = transpose(img_double_t(:));
            data_all_foto(counter,:) = img_final;
            counter = counter + 1;
        end
    end
    
%Membuat file target untuk semua foto:
    targetI = eye(numel(file)-2);
    [sizex, sizey] = size(targetI);
    counter = 0;
    for i=1:10
        for j=1:20
            target_all_foto(counter+j,:) = targetI(i,:);
        end
        counter = counter+j;
    end
%Selesai read semua file
%Clearing Variable yang tidak digunakan:
clear imgFile img img_double img_double_t img_final targetI sizex sizey temp_foto file pilDataset i j counter
       