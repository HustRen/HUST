new_pro_analysis();

function new_pro_analysis()
    floder = 'D:\����\�о���\�������\NR_LaserQA\����\����׼��\������\��һ�η���\P1274__1__924___29760_1';
    scr = '����ͼ.png';
    laser = 'P1274__1__924___29760_1_level0_320_256.png';
    imscr = getImg([floder '\' scr]);
    imlaser = getImg([floder '\' laser]);
    
    [N,edges] = histcounts(imscr);
    [N1,edges1] = histcounts(imlaser);
    
end

function im = getImg(path)
    im = imread(path);
    if(size(im,3)~=1)
        im = rgb2gray(im);
    end
end