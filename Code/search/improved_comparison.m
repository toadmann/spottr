function cc = improved_comparison(comparisons,pic1,pic2)
cpfnames = {comparisons.pics.filename};
ind1 = find(strcmp(pic1.filename,cpfnames));
ind2 = find(strcmp(pic2.filename,cpfnames));

data1 = get_wdata(pic1);
data2 = get_wdata(pic2);

mask1 = data1.wshed.spots.fin;
mask2 = data2.wshed.spots.fin;

p = comparisons.lucas.p{ind1,ind2};

validarea = true(size(mask1));
validarea([1 end],:) = false;
validarea(:,[1 end]) = false;
validarea = boolean(rejiggle(validarea,p));

mask1j = rejiggle(mask1,p);

cc = corrcoef(mask1j(validarea),double(mask2(validarea)));
cc = cc(2);