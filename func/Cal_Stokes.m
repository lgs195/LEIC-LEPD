function [S0, S1, S2, DoLP, AoLP] = Cal_Stokes(img)

%% define filter
    f_S0 = [1, 2, 1; 2, 4, 2; 1, 2, 1];
    f_S0 = f_S0 / 8;

    f_S1 = [-1, -2, -1; -2, 12, -2; -1, -2, -1];
    f_S1 = f_S1 / 8;

    f_S2 = [0, -1, 0; 1,0, 1; 0, -1, 0];
    f_S2 = f_S2 / 2;

%% Calculate Stokes
    % S0
    S0 = imfilter(img, f_S0, 'symmetric');
    [m,n] = size(S0);

    % S1
    S1_0 = imfilter(img, f_S1, 'symmetric');
    S1_45 = imfilter(img, f_S2, 'symmetric');
    S1_90 = imfilter(img, -f_S1, 'symmetric');
    S1_135 = imfilter(img, -f_S2, 'symmetric');

    S1 = zeros(m,n);
    S1(1:2:m,1:2:n) = S1_0(1:2:m,1:2:n);
    S1(1:2:m,2:2:n) = S1_45(1:2:m,2:2:n);
    S1(2:2:m,2:2:n) = S1_90(2:2:m,2:2:n);
    S1(2:2:m,1:2:n) = S1_135(2:2:m,1:2:n);

    % S2
    S2_0 = imfilter(img, f_S2, 'symmetric');
    S2_45 = imfilter(img, f_S1, 'symmetric');
    S2_90 = imfilter(img, -f_S2, 'symmetric');
    S2_135 = imfilter(img, -f_S1, 'symmetric');

    S2 = zeros(m,n);
    S2(1:2:m,1:2:n) = S2_0(1:2:m,1:2:n);
    S2(1:2:m,2:2:n) = S2_45(1:2:m,2:2:n);
    S2(2:2:m,2:2:n) = S2_90(2:2:m,2:2:n);
    S2(2:2:m,1:2:n) = S2_135(2:2:m,1:2:n);

%% Cal DoLP AoP
    a = S1.^2;
    b = S2.^2;
    DoLP_2 = sqrt(a+b);
    DoLP = DoLP_2 ./ (S0);
    AoLP = 0.5*atan2(S2,S1);