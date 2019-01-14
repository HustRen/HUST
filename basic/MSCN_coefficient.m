function [N,edges] = MSCN_coefficient(im)
    structdis = getstructdis(im);
    [N,edges] = histcounts(structdis);
end


