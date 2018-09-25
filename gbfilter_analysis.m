mian();

function mian()
    path  = 'D:\����\�о���\�������\NR_LaserQA\����\����׼��\������\��һ�η���\P1274__1__924___29760_1\';
    scr   =  '����ͼ.png';
    laser = 'P1274__1__924___29760_1_level6_320_256.png';
    imscr = imread([path scr]);
    imlaser = imread([path laser]);
    
    %scrG = getImpGorImg(imscr);
    laserG = getImpGorImg(imlaser);
    histogram(laserG);
end

function ansMag = getImpGorImg(im)
    if(size(im,3)~=1)
        %im = rgb2gray(im);
        im = rgb2gray(im);
    end
    wavelength = [3 5 7 9 11];
    orientation = [0 45 90 135]; %180 225 270 315
    ansMag = zeros(size(im));
    for i = 1 : length(wavelength)
        for j = 1 : length(orientation)
            [mag,phase] = imgaborfilt(im,wavelength(i),orientation(j));
            ansMag = ansMag + mag;
        end
    end
end