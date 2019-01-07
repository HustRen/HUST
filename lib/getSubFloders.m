function floders = getSubFloders(path)
    d = dir(path); 
    isub = [d(:).isdir];	%#?returns?logical?vector??
    floders = {d(isub).name}';
    floders(ismember(floders,{'.','..'})) = [];
end