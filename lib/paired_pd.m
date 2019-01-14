function [pd1, pd2, pd3, pd4, pd5, pd6, pd7] = paired_pd(im)
    J = log10(abs(im) + 0.1);
    shifts = [1 1;  1 0;  1 -1; ...
              0 1;        0 -1; ...
             -1 1; -1 0; -1 -1];
    Jss = circshift(J,shifts(1,:)); %[row col]
    Jsm = circshift(J,shifts(2,:));
    Jsl = circshift(J,shifts(3,:));
    Jms = circshift(J,shifts(4,:));
    Jml = circshift(J,shifts(5,:));
    Jls = circshift(J,shifts(6,:));
    Jlm = circshift(J,shifts(7,:));
    Jll = circshift(J,shifts(8,:));

    pd1 = Jml - J;
    pd2 = Jlm - J;
    pd3 = Jll - J;
    pd4 = Jls - J;
    pd5 = (Jsm + Jlm) - (Jms + Jml);
    pd6 = (J   + Jll) - (Jml + Jlm);
    pd7 = (Jss + Jll) - (Jsl + Jls);
end    


