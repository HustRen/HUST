TrainAndTestData();

function score = laserIntPredict(impath)
    model = load('D:/LaserData/background/1024X1024/trainData/trainedModel.mat');
    svmModel = model.trainedModel;
    x = feature_extract(impath);
    score = svmModel.predictFcn(x);
end

function TrainAndTestData()
    data = load('D:/LaserData/background/1024X1024/trainData/features.mat');
    features = data.features;
    len = length(features);
    trainLen = round(len * 0.8);
    trainFeature = [];
    trainLabel = [];
    for i = 1 : trainLen
        trainLabel = [trainLabel; features(i).score];
        trainFeature = [trainFeature; features(i).feature];
    end
    testFeature = [];
    testLabel = [];
    for i = trainLen + 1 : len
        testLabel = [testLabel; features(i).score];
        testFeature = [testFeature; features(i).feature];
    end
    TrainData = struct('label', trainLabel, 'feature', trainFeature);
    TestData = struct('label', testLabel, 'feature', testFeature);
    save('D:/LaserData/background/1024X1024/trainData/train.mat', 'TrainData');
    save('D:/LaserData/background/1024X1024/trainData/test.mat', 'TestData');
end

function prepareTrainData()
    ansPath = 'D:/LaserData/background/1024X1024/trainData';
    scrPath = 'D:/LaserData/background/1024X1024/resize';
    simPath = 'D:/LaserData/background/1024X1024/sim';
    floders = getSubFloders(simPath);
    features = [];
    lens = length(floders);
    for index = 1:lens
       currentFolder = [simPath '/' floders{index}];
       fileNames = dir(fullfile(currentFolder,'*.png')); 
       scrImPath = [scrPath '/' floders{index} '.png'];
       for i = 1:length(fileNames)
           name = [floders{index} '_' fileNames(i).name];
           impath = [currentFolder '/' fileNames(i).name];
           score = py.featureEstimate.MFSIMforMatlab(scrImPath, impath);
           feat = feature_extract(impath);
           feature = struct('name', name, 'score', score, 'feature', feat);
           features = [features feature];
           disp(name);
       end
       save([ansPath '/features.mat'], 'features');
    end
end