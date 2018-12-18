%Script untuk menjalankan PCA
%Rizky Ramadian Wijaya
%NPM: 1506729033

%Inisialisasi batas persentase eigen value
    pcaEigenPercent = 0.98;
    pcaEigenTotal = 0;

%Proses PCA:
%Standarisasi Data
    dataInput_std = zscore(data_all_foto);
    
%Mencari Data Covariance:
    cIn = cov(dataInput_std);
    
%Eigen Value Decomposition:
    [eigenVectors, eigenValues] = eig(cIn);
 
%Pencarian EigenValue terbesar
    %Eigen Value dikumpulkan dalam satu array
    eigenValues = diag(eigenValues);

    %Mencari nilai absolut tiap elemen dari array
    eigenValues = abs(eigenValues);
    
    %Mengurutkan EigenValue dari besar ke kecil dan mengambil nilai index
    %sebagai relasi ke eigenVector
    [eigenValues, index] = sortrows(eigenValues,-1);
    
    %Pengambilan eigenVector untuk PCA (feature vector) berdasarkan
    %eigenValue tertinggi
    for i = 1:data_dim
        %Menghitung hingga mendapatkan persentase eigen lebih besar dari
        %yang ditentukan.
        pcaEigenTotal = pcaEigenTotal + eigenValues(i);
        if pcaEigenTotal/sum(eigenValues) <= pcaEigenPercent
            pcaEigenVectors(:,i) = eigenVectors(:,uint16(index(i)));
        else
            break;
        end
    end
    
    %Menghasilkan data PCA dari feature vector
    pca_Data = (pcaEigenVectors.' * dataInput_std.').';

    %Pengambilan total dimensi PCA
    [totalImage, pca_Dim] = size(pca_Data);

    %Penghapusan variable yang tidak dibutuhkan
    clear i index pcaEigenTotal pcaEigenPercent pcaEigenVectors cIn
    %plot(pca_Data(:,1),pca_Data(:,pca_Dim),'o');
    
    