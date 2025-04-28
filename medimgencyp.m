% Read the image
original_image = imread('Skull.jpg'); 

% Display the original image
figure;
subplot(2,3,1);
imshow(original_image);
title('Original Image');

% Get image size    
[m, n] = size(original_image);

% Define scrambling parameters
block_size = 64; % Size of blocks for scrambling
num_blocks_x = floor(m / block_size); % Number of blocks in x-direction
num_blocks_y = floor(n / block_size); % Number of blocks in y-direction

% Create a customised permutation vector for block indices

% Anti-clock spiral 
%perm_indices = [13 14 15 16 12 8 4 3 2 1 5 9 10 11 7 6];

% Reverse zigzag
perm_indices = [16 12 15 14 11 8 4 7 10 13 9 6 3 2 5 1];

% spiral zigzag
%perm_indices = [7 4 8 3 6 1 2 5 10 13 9 14 11 16 15 12];

%perm_indices = [1 2 5 9 6 3 4 7 10 13 14 11 8 12 15 16];

% Create a scrambled image
scrambled_image = zeros(m, n);

% Iterate through each block and shuffle
for k = 1:length(perm_indices)
    % Compute row and column indices for the current block
    i = floor((perm_indices(k) - 1) / num_blocks_y) * block_size + 1;
    j = mod(perm_indices(k) - 1, num_blocks_y) * block_size + 1;
    
    % Extract the current block
    block = original_image(i:i+block_size-1, j:j+block_size-1);
    
    % Determine the row and column indices for placing the block in the scrambled image
    i_scramble = floor((k - 1) / num_blocks_y) * block_size + 1;
    j_scramble = mod(k - 1, num_blocks_y) * block_size + 1;
    
    % Place the block in the scrambled image
    scrambled_image(i_scramble:i_scramble+block_size-1, j_scramble:j_scramble+block_size-1) = imrotate(block, 180);
end

% Display the scrambled image
subplot(2,3,2);
imshow(uint8(scrambled_image));
title('Scrambled Image');

% Encryption Key
encryption_key = randi([0, 255], size(scrambled_image));

% Convert encryption key to double
encryption_key = double(encryption_key);

% Perform bitXOR encryption
encrypted_image = bitxor(scrambled_image, encryption_key);

% Display the encrypted image
subplot(2,3,3);
imshow(uint8(encrypted_image)); % Convert back to uint8 for display
title('Encrypted Image');

% Save the encrypted image
imwrite(uint8(encrypted_image), 'encrypted_Skull.jpg');

% Decrypt the image using the encryption key
decrypted_image = bitxor(encrypted_image, encryption_key);

% Display the decrypted image
subplot(2,3,4);
imshow(uint8(decrypted_image));
title('Decrypted Image');

% Create a blank image for unscrambling
unscrambled_image = zeros(m, n);

% Iterate through each block and unshuffle
for k = 1:length(perm_indices)
    % Compute row and column indices for the current block
    i_scramble = floor((k - 1) / num_blocks_y) * block_size + 1;
    j_scramble = mod(k - 1, num_blocks_y) * block_size + 1;
    
    % Extract the current block from the decrypted image
    block = decrypted_image(i_scramble:i_scramble+block_size-1, j_scramble:j_scramble+block_size-1);
    
    % Determine the row and column indices for placing the block in the unscrambled image
    i = floor((perm_indices(k) - 1) / num_blocks_y) * block_size + 1;
    j = mod(perm_indices(k) - 1, num_blocks_y) * block_size + 1;
    
    % Place the block in the unscrambled image
    unscrambled_image(i:i+block_size-1, j:j+block_size-1) = imrotate(block, 180);
end

% Display the unscrambled image
subplot(2,3,5);
imshow(uint8(unscrambled_image));
title('Unscrambled Image');

%subplot(2,3,6);
%histogram(encrypted_image);
%title('Histogram of Encrypted Image');

% Read the original image (OI) and the encrypted image (EI)
OI = original_image;
EI = encrypted_image;

% Convert the images to double precision for calculations
OI = double(OI);
EI = double(EI);

% Get the dimensions of the images
[rows, cols] = size(OI);
[rows_enc, cols_enc] = size(EI);

% Check if the dimensions of the images match
if rows ~= rows_enc || cols ~= cols_enc
    error('The dimensions of the original and encrypted images do not match.');
end

% Calculate the squared difference between the original and encrypted images
diff_squared = zeros(rows, cols);
for i = 1:rows
    for j = 1:cols
        diff_squared(i, j) = (OI(i, j) - EI(i, j))^2;
    end
end

% Calculate the Mean Squared Error (MSE)
MSE = sum(diff_squared(:)) / (rows * cols);

% Calculate the Peak Signal-to-Noise Ratio (PSNR) in decibels (dB)
PSNR = 10 * log10((255^2) / MSE);

disp(['PSNR: ', num2str(PSNR), ' dB']);
disp(['MSE: ', num2str(MSE)]);

% Load the input grayscale image
%image = original_image; % Load your grayscale image

% Calculate the histogram of the original image
%HC = imhist(image);

% Calculate the total number of pixels in the original image (M x N)
%[M, N] = size(image);
%total_pixels = M * N;

% Calculate HCi for each pixel value (0 to 255)
%HCi = total_pixels / 256 * ones(1, 256);

% Calculate DH
%DH = sum(abs(HCi - HC)) / (M * N);

% Display histogram deviation value
%disp(['Histogram Deviation Value (DH): ', num2str(DH)]);
