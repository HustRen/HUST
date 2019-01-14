function disIm = getstructdis(im)
    if(size(im,3)~=1)
        %im = rgb2gray(im);
        im = rgb2gray(im);
    end

    im = double(im);
    window = fspecial('gaussian',7,7/6);
    window = window/sum(sum(window));

    mu        = filter2(window, im, 'same');
    mu_sq     = mu.*mu;
    sigma     = sqrt(abs(filter2(window, im.*im, 'same') - mu_sq));
    disIm     = (im-mu)./(sigma+1);
end

