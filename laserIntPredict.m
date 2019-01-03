function score = laserIntPredict(impath)
    model = load('D:/LaserData/background/1024X1024/trainData/trainedModel.mat');
    svmModel = model.trainedModel;
    x = feature_extract(impath);
    score = svmModel.predictFcn(x);
end

