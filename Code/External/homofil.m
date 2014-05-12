%homofil performs homomorphic filtering
%im 0-255 integer image
%d?
%n order

function im_e = homofil(im,d,n)

if nargin<3
    n=2;
end
if nargin <2
    d=10;
end

[r c]=size(im);
%%%%%%%%%%Butterworth high pass filter %%%%%%%%%%%%%%
A=zeros(r,c);
for i=1:r
    for j=1:c
        A(i,j)=(((i-r/2).^2+(j-c/2).^2)).^(.5);
        H(i,j)=1/(1+((d/A(i,j))^(2*n)));
    end
end
%%%%%%%%%%%%%Using it for my application as homomorphic filtering is
%%%%%%%%%%%%%application specific, taking the value of alphaL and alphaH
%%%%%%%%%%%%%values accordingly.
alphaL=.0999;
aplhaH=1.01;
H=((aplhaH-alphaL).*H)+alphaL;
H=1-H;
%%%%%log of image
im_l=log(1+im);
%%%%%DFT of logged image
im_f=fft2(im_l);
%%%%%Filter Applying DFT image
im_nf=H.*im_f;
%%%%Inverse DFT of filtered image
im_n=abs(ifft2(im_nf));
%%%%%Inverse log 
im_e=exp(im_n);
