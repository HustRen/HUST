main()
% Function to extract features given an image
%feature = scale(feature, range)
% lens = length(bkinfo);
% bk = [];
% score = [];
% for i = 1 : lens
%     bk = [bk; bkinfo(i).feature];
%     score = [score; 100];
% end
% features = [bk; train.feature];
% label = [score; train.label];
% newtrain.feature = features;
% newtrain.label = label;
% save('D:\工作\研究生\激光干扰\NR_LaserQA\数据\数据准备\仿真结果\第一次仿真\newtrain.mat','newtrain');

function main()
   %savefeature('D:\工作\研究生\激光干扰\NR_LaserQA\数据\数据准备\仿真结果\第一次仿真\P1274__1__924___29760_1'); 
   %dataPreparation();
   %mytrain();
   %dellAll();
   %score = mytest()
   %getAllRange();
   %getbkfeature();
   %pacAnalysis();
   mytest()
   %mytrain();
end

function ansfeatures = findFeature(lower, upper, orifeatures, orilabels)
    ind = find(orilabels >= lower);
    labels = orilabels(ind);
    features = orifeatures(ind, :);
    ind2 = find(labels < upper);
    ansfeatures = features(ind2, :);
end

function pacAnalysis()
    laserTestData = load('D:\工作\研究生\激光干扰\NR_LaserQA\数据\数据准备\仿真结果\第一次仿真\test.mat');
    laserTrainData = load('D:\工作\研究生\激光干扰\NR_LaserQA\数据\数据准备\仿真结果\第一次仿真\train.mat');
    bkData = load('D:\工作\研究生\激光干扰\NR_LaserQA\数据\数据准备\仿真结果\第一次仿真\bkinfo.mat');
    rangeData = load('D:\工作\研究生\激光干扰\NR_LaserQA\数据\数据准备\仿真结果\第一次仿真\range.mat');
    laser = [laserTestData.test.feature;laserTrainData.train.feature];
    label = [laserTestData.test.label; laserTrainData.train.label];
    leve0 = findFeature(0, 20, laser, label);
    leve1 = findFeature(20, 40, laser, label);
    leve2 = findFeature(40, 60, laser, label);
    leve3 = findFeature(60, 80, laser, label);
    leve4 = findFeature(80, 100, laser, label);
    bkinfo = bkData.bkinfo;
    lens = length(bkinfo);
    bk = [];
    for i = 1 : lens
        bk = [bk; bkinfo(i).feature];
    end
    allData = [bk; leve0; leve1; leve2; leve3; leve4];
    allData = scaleMat(allData, rangeData.range); 
    figure
    [newData,T,meanValue] = pca_row(allData,0.9);
    plot(newData(1:lens, 1), newData(1:lens, 1),'o');hold on
    
    start = lens + 1; ends = start +length(leve0) - 1;
    plot(newData(start:ends, 1), newData(start:ends, 1),'+');hold on
    
    start = ends + 1; ends = start +length(leve1) - 1;
    plot(newData(start:ends, 1), newData(start:ends, 1),'*');hold on
    
    start = ends + 1; ends = start +length(leve2) - 1;
    plot(newData(start:ends, 1), newData(start:ends, 1),'^');hold on
    
    start = ends + 1; ends = start +length(leve3) - 1;
    plot(newData(start:ends, 1), newData(start:ends, 1),'s');hold on
    
    start = ends + 1; ends = start +length(leve4) - 1;
    plot(newData(start:ends, 1), newData(start:ends, 1),'p');hold on
%     scatter3(newbk(:,1), newbk(:,2), newbk(:,3)); hold on
%     [newlaser,laserT,lasermeanValue] = pca_row(laser,0.9);
%     scatter3(newlaser(:,1), newlaser(:,2), newlaser(:,3));
end

function getbkfeature()
    parentFloder = 'D:\工作\研究生\激光干扰\NR_LaserQA\数据\数据准备\仿真结果\第一次仿真';
    floders = getSubFloders(parentFloder);
    lens = length(floders);
    bkinfo = [];
    for i = 1 : lens
        path = [parentFloder '\' floders{i} '\背景图.png'];
        im = imread(path);
        feature = feature_extract(im);
        info = struct('name', floders{i}, 'feature', feature);
        bkinfo = [bkinfo info];
    end
    save('D:\工作\研究生\激光干扰\NR_LaserQA\数据\数据准备\仿真结果\第一次仿真\bkinfo.mat', 'bkinfo');
end

function getAllRange()
    trainData = load('D:\工作\研究生\激光干扰\NR_LaserQA\数据\数据准备\仿真结果\第一次仿真\train.mat');
    testData  = load('D:\工作\研究生\激光干扰\NR_LaserQA\数据\数据准备\仿真结果\第一次仿真\test.mat');
    features = [trainData.train.feature; testData.test.feature];
    [row, col] = size(features);
    range = [min(features); max(features)];
    save('D:\工作\研究生\激光干扰\NR_LaserQA\数据\数据准备\仿真结果\第一次仿真\rang.mat', 'range');
end

function featureMat = scaleMat(featureMat, range)
     [row, col] = size(featureMat);
     for i = 1 : row
         featureMat(i, :) = scale(featureMat(i, :), range);
     end
end

function sfeature = scale(feature, range)
    sfeature = feature;
    lower = -1;
    upper = 1;
    for i = 1 : 34
        MinValue = range(1, i);
        MaxValue  = range(2, i);
        sfeature(i) =  lower+ (upper-lower) * (feature(i)-MinValue)/(MaxValue-MinValue);
    end
end

function score = mytest()
    path = 'D:\LaserData\plane\patch1/level0.png';
    im = imread(path);
    rangeData = load('D:\工作\研究生\激光干扰\NR_LaserQA\数据\数据准备\仿真结果\第一次仿真\range.mat');
    f = feature_extract(im);
    load('D:\工作\研究生\激光干扰\NR_LaserQA\scaleModel.mat')
    f = scale(f, rangeData.range)
    %score = trainedModel.predictFcn(f)
    model = load('D:\工作\研究生\激光干扰\NR_LaserQA\数据\数据准备\仿真结果\第一次仿真\model.mat');
    %testData = load('D:\工作\研究生\激光干扰\NR_LaserQA\数据\数据准备\仿真结果\第一次仿真\test.mat');
    %rangeData = load('D:\工作\研究生\激光干扰\NR_LaserQA\数据\数据准备\仿真结果\第一次仿真\range.mat');
    %features = testData.test.feature;
    %labels   = testData.test.label;
    %features = scaleMat(features, rangeData.range);  
%    model = svmtrain(labels, features, '-s 3 -t 2 -c 2.2 -g 2.8 -p 0.01');
%    [score, acc, xx] = svmpredict(labels,features, model.model)
%     f = scaleMat(f, rangeData.range);  
     [score, acc, xx] = svmpredict(0,f, model.model);   
     score = f * model.w;
end

function mytrain()
    trainData = load('D:\工作\研究生\激光干扰\NR_LaserQA\数据\数据准备\仿真结果\第一次仿真\newtrain.mat');
    rangeData = load('D:\工作\研究生\激光干扰\NR_LaserQA\数据\数据准备\仿真结果\第一次仿真\range.mat');
    features = trainData.newtrain.feature;
    labels   = trainData.newtrain.label;
    features = scaleMat(features, rangeData.range);  
    model = svmtrain(labels, features, '-s 3 -t 1 -c 2.2 -g 2.8 -p 0.01');
    [score, acc, xx] = svmpredict(labels,features, model);
%     save('D:\工作\研究生\激光干扰\NR_LaserQA\数据\数据准备\仿真结果\第一次仿真\model.mat', 'model');
%     save('D:\工作\研究生\激光干扰\NR_LaserQA\数据\数据准备\仿真结果\第一次仿真\features.mat', 'features');
%     stepwise(features, labels)
%     [b,bint,r,rint,stats]=regress(labels,features);
    
end

function dellAll()
    parentFloder = 'D:\工作\研究生\激光干扰\NR_LaserQA\数据\数据准备\仿真结果\第一次仿真';
    floders = getSubFloders(parentFloder);
    lens = length(floders);
    for i = 1 : lens
       current = [parentFloder '\' floders{i}];
       info = strcat(current, sprintf('   %d / %d', i, lens));
       disp(info)
       savefeature(current);
    end
end

function dataPreparation()
    parentFloder = 'D:\工作\研究生\激光干扰\NR_LaserQA\数据\模型数据';
    floders = getSubFloders(parentFloder);
    lens = length(floders);
    train.feature = [];
    train.label = [];
    test.feature = [];
    test.label = [];
    for i = 1 : lens
       current = [parentFloder '\' floders{i}];
%        info = strcat(current, sprintf('   %d / %d', i, lens));
%        disp(info)
       matTemp = load([current '\features_M.mat']);
       featuresMat = matTemp.featuresMat;
       samples = length(featuresMat);
       if i < round(0.8 * lens)        
           for j = 1 : samples 
                if featuresMat(j).score >= 100
                    disp(current)
                    disp(featuresMat(j).name)
                end
                train.label = [train.label; featuresMat(j).score];
                train.feature = [train.feature; featuresMat(j).feature];
           end
       else
           for j = 1 : samples 
               if featuresMat(j).score >= 100
                    disp(featuresMat(j).name)
                end
                test.label = [test.label; featuresMat(j).score];
                test.feature = [test.feature; featuresMat(j).feature];
           end
       end
    end
    save([parentFloder '\train.mat'],'train');
    save([parentFloder '\test.mat'],'test');
end

% function train()
%     train
% end

function savefeature(fileFolder)
    fileNames = dir(fullfile(fileFolder,'*.png'));
    Annotation = readAnnotation([fileFolder  '\Annotation.xml']);
    featuresMat = [];
    for index = 1 : length(fileNames)
        if strcmp(fileNames(index).name, '背景图.png') == 0
            path = [fileFolder '\' fileNames(index).name];
            img = imread(path);
            if(size(img,3)~=1)
            %im = rgb2gray(im);
                img = rgb2gray(img);
            end
            feat = feature_extract(img);
            score = getAnnoScore(Annotation, fileNames(index).name, 'MFSIM');
            features = struct('name', fileNames(index).name, 'feature', feat, 'score', score);
            featuresMat = [featuresMat features];
        end
    end
    save([fileFolder '\features_M.mat'],'featuresMat');
end

function s = getAnnoScore(Annotation, name, score)
    lens = length(Annotation);
    s = 0.0;
    for i = 1 : lens  % 1 <= i <= lens 
        if strcmp(Annotation(i).name, name) == 1
            if strcmp(score, 'MFSIM')
                s = Annotation(i).MFSIM;
            else
                s = Annotation(i).WFSIM;
            end
        end
    end
end

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

function [N,edges] = MSCN_coefficient(im)
    structdis = getstructdis(im);
    [N,edges] = histcounts(structdis);
end

function M = Kordermoment(im, k)
    if(size(im,3)~=1)
        %im = rgb2gray(im);
        im = rgb2gray(im);
    end

    im = double(im);
    window = fspecial('gaussian',7,7/6);
    window = window/sum(sum(window));

    mu       = filter2(window, im, 'same');
    im       = (im - mu).^k;
     M       = mean2(im);
end

function [alpha, std] = GGD_parameter(im)
    structdis = getstructdis(im); 
    [alpha, std] = estimateggdparam(structdis(:));
end

function statistics()
    fileFolder = 'D:\工作\研究生\激光干扰\仿真图像\数据准备';
    fileNames = dir(fullfile(fileFolder,'*.png'));
    figure
    for index = 1 : length(fileNames)
        path = [fileFolder '\' fileNames(index).name];
        im = imread(path);
        [y, x] = MSCN_coefficient(im);
        y = y / max(y);
        plot(x(2:end), y);
        hold on
    end
    im = imread('D:\工作\研究生\激光干扰\仿真图像\原始背景图.png');
    [y, x] = MSCN_coefficient(im);
    y = y / max(y);
    plot(x(2:end), y, 'o');
    hold on
end

function [N,edges] = AGGD_coefficient(im)
    structdis = getstructdis(im); 
    shifts  = [0 1;1 0 ; 1 1; -1 1];
    shifted_structdis  = circshift(structdis,shifts(2,:));
    pair               = structdis(:).*shifted_structdis(:);
    [N,edges] = histcounts(pair);
end

function Annotation = readAnnotation(xmlpath)
    xmlDoc = xmlread(xmlpath);%?读取文件??test.xml??
%     %%?Extract?ID??
%     IDArray = xmlDoc.getElementsByTagName('ID');%?将所有ID节点放入数组IDArray??
%     for i = 0 : IDArray.getLength - 1 %?此例子中，?IDArray.getLength?等于?2??
%         nodeContent = char(IDArray.item(i).getFirstChild.getData)%?提取当前节点的内容??
%     end
    Annotation = [];
    Ann = struct('name','NULL','MFSIM', 0.0, 'WFSIM', 0.0);
    InterImArray = xmlDoc.getElementsByTagName('InterImage');    %???将所有FDs节点放入数组FDsArray??
    for i = 0 : InterImArray.getLength-1
        thisItem = InterImArray.item(i);
        childNode = thisItem.getFirstChild;
        while ~isempty(childNode)   %?遍历FDs的所有子节点，也就是遍历?("rows,?cols,?data")?节点??
            if childNode.getNodeType == childNode.ELEMENT_NODE  %?检查当前节点没有子节点，??childNode.ELEMENT_NODE?定义为没有子节点。??
                childNodeNm = char(childNode.getTagName);   %?当前节点的名字??
                childNodeData = char(childNode.getFirstChild.getData);  %?当前节点的内容
                if strcmp(childNodeNm, 'name') == 1
                    Ann.name = childNodeData;
                elseif strcmp(childNodeNm,'MFSIM') == 1
                    Ann.MFSIM = str2double(childNodeData);
                else 
                    Ann.WFSIM = str2double(childNodeData);   
                end
            end %?End?IF 
            childNode = childNode.getNextSibling; %?切换到下一个节点
        end %?End?WHILE??
        Annotation = [Annotation Ann];
    end
end