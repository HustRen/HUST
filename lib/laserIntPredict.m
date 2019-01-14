function score = laserIntPredict(impath)
    score = struct('NR', 0.0, 'SSIM', 0.0, 'MFSIM', 0.0);
    model = load('D:/LaserData/background/1024X1024/trainData/NewDataSet/model/trainedModel(f_pp_pd_ef).mat');
    svmModel = model.trainedModel;
    x = feature_extract(impath);
    score.NR = svmModel.predictFcn(x);
    ps = py.featureEstimate.getScore(impath);
    s = cell(ps);
    score.SSIM = s{1};
    score.MFSIM = s{2};
end

