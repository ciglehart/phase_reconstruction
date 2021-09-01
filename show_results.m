clear all;
close all;
clc;

acc = 8;
slice = 32;
lm = [0.00001,0.0001,0.001,0.01,0.1,1.0];
lp = [0.00001,0.0001,0.001,0.01,0.1,1.0];

for mm = 1:6
    for pp = 1:6
        
        load('te_images.mat');
        load(['regularization_parameter_experiment/recon_slice_acc_',num2str(acc),'_slice_',num2str(slice),'_lm_',num2str(mm),'_lp_',num2str(pp),'.mat']);
        
        for echo = 1
            truth = squeeze(im(:,:,slice,echo));
            recon = squeeze(img(:,:,echo));
            
            f = figure;
            f.Position = [50 50 1000 1000];
            
            subplot(2,2,1)
            imagesc(abs(truth));
            axis equal;
            axis off;
            colormap gray;
            axis tight;
            title(['Actual magnitude, echo ',num2str(echo)],'FontSize',18);
            
            subplot(2,2,2)
            imagesc(abs(recon));
            axis equal;
            axis off;
            colormap gray;
            axis tight;
            title(['Recon magnitude, \lambda_{m} =  ',num2str(lm(mm))],'FontSize',18);
            
            subplot(2,2,3)
            imagesc(angle(truth));
            axis equal;
            axis off;
            colormap gray;
            axis tight;
            title(['Actual phase, echo ',num2str(echo)],'FontSize',18);
            
            subplot(2,2,4)
            imagesc(angle(recon));
            axis equal;
            axis off;
            colormap gray;
            axis tight;
            title(['Recon phase,  \lambda_{p} =  ',num2str(lp(pp))],'FontSize',18);
        end
        
    end
end