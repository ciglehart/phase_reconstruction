function complex_plot(im)

figure;
subplot(1,2,1);
imagesc(squeeze(abs(im)));
axis equal;
axis tight;
colormap gray;
title('Magnitude');

subplot(1,2,2);
imagesc(squeeze(angle(im)));
axis equal;
axis tight;
title('Phase');

end