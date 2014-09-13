function [mask,raw] = wshed_4gui(I,params)

if ~params.do
    mask=params.fg.fin;
else
    gradmag2 = imimposemin(params.edges.fin, params.fg.fin);
    L = watershed(gradmag2);

    %pick out the good ones
    labs = unique(L);
    mask = false(size(I));
    testmask = zeros(size(I));
    spotthresh = prctile(I(:),params.fgthresh);
    for lno = 1:length(labs)

        bin = (L==labs(lno));
        mean_I = mean(I(bin));
        testmask(bin) = mean_I;
        [Y,X] = find(bin);
        if (mean_I>spotthresh)
            mask = mask|bin;
        end
    end
    mask = mask|params.fg.fin;
end

raw = mask;

mask(params.spots.pos) = true;
mask(params.spots.neg) = false;
mask([1,end],:) = false;
mask(:,[1,end]) = false;
