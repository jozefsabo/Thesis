%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Triple ISO plotting procedure %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% tico09_data  - TICO09 (2-D) data
%%% srou03_data  - SROU03 (2-D) data
%%% bm3d_data    - BM3D   (2-D) data
%%% out_name     - output file name
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fig_res = SABO12_ISOTriplePlot(tico09_data, srou03_data, bm3d_data, out_name)

    figure
    
    RGBmap = [0.75 0.31 0.30;0.61 0.73 0.35;0.31 0.51 0.74]; 

    colormap(RGBmap);
    
	hold on

    plot(tico09_data, '-d', 'Color', [0.61 0.73 0.35], 'LineWidth',2, 'MarkerFaceColor', [0.61 0.73 0.35]);
    plot(srou03_data, '-s', 'Color', [0.31 0.51 0.74], 'LineWidth',2, 'MarkerFaceColor', [0.31 0.51 0.74]);
    plot(bm3d_data  , '-^', 'Color', [0.75 0.31 0.30], 'LineWidth',2, 'MarkerFaceColor', [0.75 0.31 0.30]);
    legend('TICO09','SROU03','BM3D');
	grid on
    
    set(gca,'FontSize',10);
    %set(gca,'YTickLabel',{' ', '3',' ','7',' ','15',' ', '31'});
    %set(gca,'YTickLabel',{' ', '31',' ','15',' ','7',' ', '3'});
    
    set(gca,'XTickLabel',{'200','400','800','1600','3200','6400','12800','25600','102400'});
   	xlabel(gca,'Input ISO');
	ylabel(gca,'SNR');
	
    
    
    print(sprintf('-f%d',gcf),'-dpsc2',out_name);

    close(gcf);
    
    fig_res = 0;    

end


