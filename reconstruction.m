clc;
clear all;
close all;
setPath;

accel = 8;
slices = 32;
echoes = 1;
ncalib = 24;
ksize = [6,6];
niter = 100;
ninneriter = 10;
doplot = 0;
dohogwild = 1;
ncycles = 16;
lambdam = 0.003;
lambdap = 0.005;
lm = [0.00000001,0.0000001,0.000001,0.00001,0.0001,0.001];
lp = [0.00000001,0.0000001,0.000001,0.00001,0.0001,0.001];
M = Identity;
P = Identity;
C = Identity;
results_dir = '/Users/charlesiglehart/Desktop/phase_cycling_reconstruction/regularization_parameter_experiment2';
load('sens_maps_256_256_8.mat');
image_struct = load('te_images.mat');

for ii = 1:numel(lm)
    lambdam = lm(ii);
    for jj = 1:numel(lp)
        lambdap = lp(jj);
        for acc = accel
            load(['mask_acc_',num2str(acc),'.mat']);
            mask = repmat(mask,1,1,size(maps,3));
            for slice = slices
                img = zeros(size(squeeze(image_struct.im(:,:,slice,:))));
                for echo = echoes
                    im = squeeze(image_struct.im(:,:,slice,echo));
                    coil_images = zeros(size(maps));
                    ksp = zeros(size(maps));
                    kspc = zeros(size(maps));
                    
                    for ii = 1:size(ksp,3)
                        coil_images(:,:,ii) = squeeze(maps(:,:,ii)).*im;
                        ksp(:,:,ii) = fft2(squeeze(maps(:,:,ii)).*im);
                        kspc(:,:,ii) = fft2c(coil_images(:,:,ii));
                    end
                    
                    if (echo == 1)
                        [m,w] = ecalib(ksp, ncalib, ksize);
                        w = fftshift(w);
                        for ii = 1:size(m,3)
                            m(:,:,ii) = fftshift(m(:,:,ii));
                        end
                        S = ESPIRiT(m, w);
                    end
                    
                    F = p2DFT(mask,size(mask));
                    y = mask.*kspc;
                    Pm = wave_thresh('db4', 3, lambdam);
                    Pp = wave_thresh('db4', 3, lambdap);
                    [m0, p0, W] = pfinit(y, S, F, ncycles);
                    message = ['Reconstructing slice ',num2str(slice),', echo ',num2str(echo),', acceleration ',num2str(acc),' lambdap = ',num2str(lambdap),', lambdam = ',num2str(lambdam)];
                    [mag0, phase] = mprecon(y, F, S, C, M, P, Pm, Pp, m0, p0, W, niter, ninneriter, dohogwild, doplot,message);
                    img(:,:,echo) = mag0 .* sqrt(w).*exp(1j*phase);
                end
                save(fullfile(results_dir,['recon_slice_acc_',num2str(acc),'_slice_',num2str(slice),'_lm_',num2str(ii),'_lp_',num2str(jj)]),'img');
            end
        end
    end
end
