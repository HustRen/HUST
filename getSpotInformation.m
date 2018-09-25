function V= getSpotInformation(im, threshold)
    a = 0.6;
    spots = getSpotFromImg(im, threshold);
    info.entropy = 0.0;
    info.area = 0.0;
    box0 = struct('rowMin', 0, 'colMin', 0, 'rowMax', 0, 'colMax', 0);
    info.box = struct('inBox', box0, 'outBox', box0);
    [rows, cols] = size(im);
    areaMax = max(spots.areaSize);
    for i = 1 : spots.spotNum
        if spots.areaSize(i) == areaMax && spots.areaSize(i)/(rows * cols) > 0.005
            surroundRowMax = min(spots.rowMax(i) + a * (spots.rowMax(i) - spots.rowMin(i)), rows);
            surroundRowMin = max(spots.rowMin(i) - a * (spots.rowMax(i) - spots.rowMin(i)), 1);
            surroundColMax = min(spots.colMax(i) + a * (spots.colMax(i) - spots.colMin(i)),cols);
            surroundColMin = max(spots.colMin(i) - a * (spots.colMax(i) - spots.colMin(i)), 1);
            inBox = struct('rowMin', spots.rowMin(i), 'colMin', spots.colMin(i), 'rowMax', spots.rowMax(i), 'colMax', spots.colMax(i));
            outBox = struct('rowMin', surroundRowMin, 'colMin', surroundColMin, 'rowMax', surroundRowMax, 'colMax', surroundColMax);
            boxs = struct('inBox', inBox, 'outBox', outBox);
            spotBk = im(round(surroundRowMin):round(surroundRowMax), round(surroundColMin):round(surroundColMax));
            [counts, graylevel] = imhist(spotBk);
            bkNum = sum(counts(1 : threshold + 1));
            p = counts /  bkNum;
            entropyTemp = 0.0;
            for level = 1 : threshold + 1
                if p(level) ~= 0.0000
                    entropyTemp = entropyTemp - p(level) * log2(p(level));  
                end
            end
            info.box = boxs;
            info.area = spots.areaSize(i) / (rows * cols);
            info.entropy = entropyTemp;
        end
    end
    V = info;
end