function y = AGGD(x, alpha, leftstd, rightstd )
%AGGD 此处显示有关此函数的摘要
%   此处显示详细说明
    y = [];
    len = length(x);
    bl = leftstd * (sqrt(gamma(1/alpha))/sqrt(gamma(3/alpha)));
    br = rightstd * (sqrt(gamma(1/alpha))/sqrt(gamma(3/alpha)));
    const = alpha / ((bl + br) * gamma(1/alpha));
    for i = 1 : len 
        if x(i) < 0
            value = const * exp(-power(-x(i)/bl, alpha));
        else
            value = const * exp(-power(x(i)/br, alpha));
        end
        y = [y value];
    end
end

