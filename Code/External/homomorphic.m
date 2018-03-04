% HOMOMORPHIC - Performs homomorphic filtering on an image.
%
% Function performs homomorphic filtering on an image. This form of
% filtering sharpens features and flattens lighting variantions in an image.
% It usually is very effective on images which have large variations in
% lighting, for example when a subject appears against strong backlighting.
%
%
% Usage: newim =
% homomorphic(inimage,boost,CutOff,order,saturation_range)
% homomorphic(inimage,boost,CutOff,order)
%
% Parameters:  (suggested values are in brackets)
%         boost    - The ratio that high frequency values are boosted
%                    relative to the low frequency values (2).
%         CutOff   - Cutoff frequency of the filter (0 - 0.5)
%         order    - Order of the modified Butterworth style filter that
%                    is used, this must be an integer > 1 (2)
%  If lhistogram_cut and uhistogram_cut are not specified no histogram truncation will be
%  applied.
%
%
% Suggested values: newim = homomorphic(im, 2, .25, 2, 0, 5, [5,98]);
%

function him = homomorphic(im, boost, cutoff, order,saturation_range)

if nargin<5
    saturation_range = [5 98];
else
    if length(saturation_range)~=2
        error 'saturation range must be a 2-element vector';
    end
end
if nargin<4
    order = 2;
end
if nargin<3
    cutoff = 0.25;
end
if nargin<2
    boost = 2;
end

%take log-fft
im_ft = fft2(log(max(im,0.01)));

%create high-boost filter
[rows,cols] = size(im);
hb_filt = make_hbfilt(boost,cutoff,order,rows,cols);

%bring back into image domain
him = exp(real(ifft2(im_ft.*hb_filt))); % Apply the filter, invert fft, and invert the log.

%saturate image: remove high and low intensity pixels
low_sat_point = percentile(him,saturation_range(1));
him(him<low_sat_point) = low_sat_point;

high_sat_point = percentile(him,saturation_range(2));
him(him>high_sat_point) = high_sat_point;

him = (him-low_sat_point)/high_sat_point;

%get the value corresponding to the prc-th percentile
function val = percentile(im,prc)
pos = round((numel(im)-1)*prc/100)+1;
vals = sort(im(:),'ascend');
val = vals(pos);

%create a high-boost filter
function hb_filt = make_hbfilt(boost,cutoff,order,rows,cols)
[x,y] = meshgrid(linspace(-0.5,0.5,cols),linspace(-0.5,0.5,rows));
radius = sqrt(x.^2 + y.^2); % A matrix with every pixel = radius relative to centre.
lp_filt = ifftshift( 1.0 ./ (1.0 + (radius/cutoff).^(2*order)) );
hb_filt = (1-1/boost)*(1.0 - lp_filt) + 1/boost;
