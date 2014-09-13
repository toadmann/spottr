function img = alg_hand(img,pos,neg)
if strcmp(class(img),'double')
    hi = 1.0;
    lo = 0.0;
else
    hi = true;
    lo = false;
end
img(pos) = hi;
img(neg) = lo;