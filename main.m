%test();
% features = load('D:/LaserData/background/1024X1024/trainData/model2/features.mat');
% model = load('D:/LaserData/background/1024X1024/trainData/trainedModel.mat');
% svmModel = model.trainedModel;
% data = features.features;
% for i = 1:24
%     name = data((i-1)*24 + 1).name;
%     a = [];
%     b = [];
%     for j = 1:24
%         feature = data((i - 1)*24 + j).feature;
%         score = data((i - 1)*24 + j).score;
%         spredict = svmModel.predictFcn(feature);
%         a = [a score];
%         b = [b spredict];
%     end
%     [a,index] = sort(a);
%     b = b(index);
%     figure
%     title(name)
%     plot(a, '*');
%     hold on
%     h = plot(b, 'o');
%     hold on
%     saveas(h, ['D:\LaserData\background\1024X1024\trainData\plot\' name]);
%     close(gcf);
% end
%prepareTrainData();
draw();

function draw()
    bkpath = 'D:/LaserData/background/1024X1024/scr/airplane/';
    simpath = 'D:/LaserData/background/1024X1024/batch2/';
    name = 'airplane_298';
    fileNames = dir(fullfile([simpath name],'*.png'));
    bkImg = imread([bkpath name '.jpg']);
    levels = cell(1,6);
    for i = 1:6
        im = imread([simpath name '/' fileNames(1 + 4*(i - 1)).name]);
        disp([simpath name '/' fileNames(1 + 4*(i - 1)).name]);
        levels(i) = {im};
    end
    figure
    bkCoff = getstructdis(bkImg);
    index = 5;
    [pd1, pd2, pd3, pd4, pd5, pd6, pd7] = paired_pd(bkCoff);
    pd = {pd1, pd2, pd3, pd4, pd5, pd6, pd7};
    [Nbk,edgesbk] = histcounts(pd{index});
    Nbk = Nbk/max(Nbk);
    plot(edgesbk(2:end),Nbk, '-o', 'LineWidth', 1);
    hold on
    linetype = ['-+';'-*';'-s';'-d';'-^';'-v'];
    for i = 1:6
        levelcoff = getstructdis(levels{i});
        [pd1, pd2, pd3, pd4, pd5, pd6, pd7] = paired_pd(levelcoff);
        pdlevels = {pd1, pd2, pd3, pd4, pd5, pd6, pd7};
        [Nlevel,edgeslevel] = histcounts(pdlevels{index});
        Nlevel = Nlevel/max(Nlevel);
        plot(edgeslevel(2:end),Nlevel, linetype(i,:),'LineWidth', 1);
        hold on
    end
    ylabel('Number of coefficients (normalized)');
    xlabel('Paired log-derivative coefficients');
    legend({'Pristine','Distortion level1', 'Distortion level2',...
        'Distortion level3', 'Distortion level4', 'Distortion level5', 'Distortion level6'}, 'FontSize', 10);
end


function test()
    testSortFeatures = load('D:/LaserData/background/1024X1024/trainData/testFeature.mat');
    model = load('D:/LaserData/background/1024X1024/trainData/trainedModel.mat');
    svmModel = model.trainedModel;
    data = testSortFeatures.testFeature;
    len = length(data);
    reference = [];
    predict = [];
    for i = 1 : len
        feature = data(i).feature;
        reference = [reference data(i).score];
        score = svmModel.predictFcn(feature);
        predict = [predict score];
    end
    figure
    for i = 1 : len
        if predict(i) > 120
           plot(data(i).feature, 'bo')
           disp(data(i).name);
        else
           plot(data(i).feature, 'r*')
        end
        hold on
    end  
end

function TrainAndTestData()
    data = load('D:/LaserData/background/1024X1024/trainData/features.mat');
    features = data.features;
    len = length(features);
    trainLen = round(len * 0.8);
    trainFeature = features(1:trainLen);
    testFeature = features(1 + trainLen:len);
%    trainLabel = [];
%     for i = 1 : trainLen
%         trainLabel = [trainLabel; features(i).score];
%         trainFeature = [trainFeature; features(i).feature];
%     end
%     testFeature = [];
%     testLabel = [];
%     for i = trainLen + 1 : len
%         testLabel = [testLabel; features(i).score];
%         testFeature = [testFeature; features(i).feature];
%     end
%     TrainData = struct('label', trainLabel, 'feature', trainFeature);
%     TestData = struct('label', testLabel, 'feature', testFeature);
    save('D:/LaserData/background/1024X1024/trainData/trainFeature.mat', 'trainFeature');
    save('D:/LaserData/background/1024X1024/trainData/testFeature.mat', 'testFeature');
end

function prepareTrainData()
    global gam;
    gam = 0.2:0.001:10;
    global ggd_r_gam;
    ggd_r_gam  = (gamma(1./gam).*gamma(3./gam))./((gamma(2./gam)).^2);
    global aggd_r_gam;
    aggd_r_gam = ((gamma(2./gam)).^2)./(gamma(1./gam).*gamma(3./gam));
    
    ansPath = 'D:/LaserData/background/1024X1024/trainData';
    scrPath = 'D:/LaserData/background/1024X1024/scr/airplane';
    simPath = 'D:/LaserData/background/1024X1024/batch2';
    floders = getSubFloders(simPath);
    features = [];
    lens = length(floders);
    for index = 1:lens
       currentFolder = [simPath '/' floders{index}];
       fileNames = dir(fullfile(currentFolder,'*.png')); 
       scrImPath = [scrPath '/' floders{index} '.jpg'];
       for i = 1:length(fileNames)
           impath = [currentFolder '/' fileNames(i).name];
           score = py.featureEstimate.MFSIMforMatlab(scrImPath, impath);
           feat = feature_extract(impath);
           feature = struct('floder',floders{index},'filename', fileNames(i).name, 'score', score, 'feature', feat);
           features = [features feature];
       end
       disp(floders{index});
       save([ansPath '/NewDataSetFeatures_PD5.mat'], 'features');
    end
end