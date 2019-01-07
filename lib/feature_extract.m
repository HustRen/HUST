function feat = feature_extract(path)
% Function to extract features given an image
%% Constant
    im = imread(path);
    if(size(im,3)~=1)
        %im = rgb2gray(im);
        im = rgb2gray(im);
    end
    figim(:,:,1) = im;
    figim(:,:,2) = im;
    figim(:,:,3) = im;
    dim = double(im);
    window = fspecial('gaussian',7,7/6);
    window = window/sum(sum(window));

    feat = [];
    mu            = filter2(window, dim, 'same');
    mu_sq         = mu.*mu;
    sigma         = sqrt(abs(filter2(window, dim.*dim, 'same') - mu_sq));
    structdis     = (dim-mu)./(sigma+1);  %mscn

    [alpha, overallstd]       = estimateggdparam(structdis(:));
    feat                     = [feat alpha overallstd^2];   %f1 f2 Shape and variance Fit GGD [32] to MSCN coefficients

    shifts                   = [ 0 1;1 0 ; 1 1; -1 1]; %[row col]

    for itr_shift =1:4  %Fit AGGD pairwise products  H V D1 D2
        shifted_structdis        = circshift(structdis,shifts(itr_shift,:));
        pair                     = structdis(:).*shifted_structdis(:);
        [alpha, leftstd, rightstd] = estimateaggdparam(pair);
        const                    =(sqrt(gamma(1/alpha))/sqrt(gamma(3/alpha)));
        meanparam                =(rightstd-leftstd)*(gamma(2/alpha)/gamma(1/alpha))*const;
        feat                     =[feat alpha meanparam leftstd^2 rightstd^2]; %Shape, mean, left variance, right variance
    end

    [pd1, pd2, pd3, pd4, pd5, pd6, pd7] = paired_pd(structdis);
    [shape, var] = estimateggdparam(pd1(:));
    feat         = [feat shape var^2];
    [shape, var] = estimateggdparam(pd2(:));
    feat         = [feat shape var^2];
    [shape, var] = estimateggdparam(pd3(:));
    feat         = [feat shape var^2];
    [shape, var] = estimateggdparam(pd4(:));
    feat         = [feat shape var^2];
    [shape, var] = estimateggdparam(pd5(:));
    feat         = [feat shape var^2];
    [shape, var] = estimateggdparam(pd6(:));
    feat         = [feat shape var^2];
    [shape, var] = estimateggdparam(pd7(:));
    feat         = [feat shape var^2];

    spot = getSpotInformation(im, 250);
    feat = [feat spot.entropy];
    
    em = py.featureEstimate.getEstimateFeature(path);
    cem = cell(em);
    len = length(cem);
    for i = 1 : len
        feat = [feat cem{i}];
    end
%     ansimg = drawRect(figim, spot.box.inBox, 1, [0, 255, 0]);
%     figim = drawRect(ansimg, spot.box.outBox,1, [0, 0, 255]);
%     figure
%     imshow(figim)
%     hold on
end

function [pd1, pd2, pd3, pd4, pd5, pd6, pd7] = paired_pd(im)
    J = log10(abs(im) + 0.1);
    shifts = [1 1;  1 0;  1 -1; ...
              0 1;        0 -1; ...
             -1 1; -1 0; -1 -1];
    Jss = circshift(J,shifts(1,:)); %[row col]
    Jsm = circshift(J,shifts(2,:));
    Jsl = circshift(J,shifts(3,:));
    Jms = circshift(J,shifts(4,:));
    Jml = circshift(J,shifts(5,:));
    Jls = circshift(J,shifts(6,:));
    Jlm = circshift(J,shifts(7,:));
    Jll = circshift(J,shifts(8,:));

    pd1 = Jml - J;
    pd2 = Jlm - J;
    pd3 = Jll - J;
    pd4 = Jls - J;
    pd5 = (Jsm - Jlm) - (Jms + Jml);
    pd6 = (J   + Jll) - (Jml + Jlm);
    pd7 = (Jss + Jll) - (Jsl + Jls);
end    
