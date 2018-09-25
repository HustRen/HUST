function [ info] = getSpotFromImg( img, threshold)
% locX 目标点中心位置x    locY 目标点中心位置y
% areaSize 目标区域面积   targetNum 图像中目标数量
% 作者 任立均 2017/3/23
    [row, col] = size(img);
    targetNum = 0;
    xNum = [ 1 1 0 -1 -1 -1 0 1 ];
    yNum = [ 0 1 1 1 0 -1 -1 -1 ];
    imgLabl = zeros(row, col);
    stackX = [];
    stackY = [];

    areaSize = [];
    rowsMax = [];
    rowsMin = [];
    colsMax = [];
    colsMin = [];

    for y = 1 : row
        for x = 1 : col
            if(img(y, x) >= threshold && imgLabl(y, x) == 0)
                targetNum = targetNum + 1;
                imgLabl(y, x) = targetNum;

                rowMax = 1; rowMin = row; colMax = 1; colMin = col;           
                rowMax = max(rowMax, y); rowMin = min(rowMin, y);            
                colMax = max(colMax, x); colMin = min(colMin, x);

                areaTemp = 1;
                stackX = [stackX x]; stackY = [stackY y];            
                while (~isempty(stackX))
                    tempx = stackX(length(stackX));
                    stackX = stackX(1:length(stackX) - 1);
                    tempy = stackY(length(stackY));
                    stackY = stackY(1:length(stackY) - 1);
                    for i = 1 : 8
                        xx = tempx + xNum(i);
                        yy = tempy + yNum(i);
                        if (xx >= 1 && xx <= col && yy >= 1 && yy <= row)
                            if (img(yy, xx) >= threshold && imgLabl(yy, xx) == 0)
                                imgLabl(yy, xx) = targetNum;
                                areaTemp = areaTemp + 1;
                                stackX = [stackX xx];
                                stackY = [stackY yy];                          
                                rowMax = max(rowMax, yy); rowMin = min(rowMin, yy);            
                                colMax = max(colMax, xx); colMin = min(colMin, xx);
                            end
                        end            
                    end
                end
                areaSize = [areaSize areaTemp];      
                rowsMax = [rowsMax rowMax];
                rowsMin = [rowsMin rowMin];
                colsMax = [colsMax colMax];
                colsMin = [colsMin colMin];
            end
        end
    end
    info = struct('rowMax', rowsMax, 'rowMin', rowsMin, 'colMax', colsMax, 'colMin', colsMin, 'areaSize', areaSize, 'spotNum', targetNum);
end

