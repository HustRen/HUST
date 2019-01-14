%[myX, myY] = fittingAnalysis('D:\LaserData\background\1024X1024\sim\P1374__1__4620___4620\60_286_386.png');
statistics()





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

function [alpha,leftstd, rightstd] = AGGD_parameter(im)
    structdis = getstructdis(im); 
    [alpha, leftstd, rightstd] = estimateaggdparam(structdis(:));
end

function [myx,myy] = fittingAnalysis( imgPath )
%FITTINGANALYSIS 此处显示有关此函数的摘要
%   此处显示详细说明
    im = imread(imgPath);
         
    [N,edges] = MSCN_coefficient(im);
    [alpha,leftstd, rightstd] = AGGD_parameter(im)
    x = edges(2:end);
%     [alpha, std] = estimateggdparam(N/sum(N));
%     leftstd = std;
%     rightstd = std; 
%     x = -3:0.01:3;
    y = AGGD(x,alpha, leftstd, rightstd);
    figure
    plot(x, y);
    hold on
    N = N / sum(N);
    plot(edges(2:end),N)
    hold on
    myx = x;
    myy = N;
end

function statistics()    
    floders = getSubFloders('D:\LaserData\background\1024X1024\sim');
    lens = length(floders);
    figure
    for i = 1:lens
       bk = floders{i};
        fileFolder = ['D:\LaserData\background\1024X1024\sim\' bk];
        fileNames = dir(fullfile(fileFolder,'*.png'));
        for index = 1 : length(fileNames)
            path = [fileFolder '\' fileNames(index).name];
            im = imread(path);
            [alpha,leftstd, rightstd] = AGGD_parameter(im);
            plot3(log10(alpha),log10(leftstd*leftstd), log10(rightstd*rightstd), 'ro','MarkerSize',8, 'MarkerFaceColor',[0.9,0.2,0.2]);
            hold on
        end
        im = imread(['D:\LaserData\background\1024X1024\resize\' bk '.png']);
        [alpha,leftstd, rightstd] = AGGD_parameter(im);
        h = plot3(log(alpha),log(leftstd*leftstd), log(rightstd*rightstd), 'bo','MarkerSize',8, 'MarkerFaceColor',[0.2,0.2,0.9]); %'MarkerFaceColor',[0.7,0.5,0.5]
        hold on
    end
    title('AGGD-parameter')
    xlabel('log(alpha)')
    ylabel('og(leftstd*leftstd)')
    zlabel('log(rightstd*log)')
    %close(gcf);
    hold on
    saveas(h, ['D:\LaserData\background\1024X1024\trainData\plot\' 'AGGD-parameter' '.jpg']);
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