function fig_res = SABO12_VarTriplePlot(tico09_data, srou03_data, bm3d_data, out_name)

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
    
    set(gca,'XTickLabel',{'0.0001',' ','0.001',' ','0.01',' ','0.1'});
   	xlabel(gca,'Input variance');
	ylabel(gca,'SNR');
	
    
    
    print(sprintf('-f%d',gcf),'-dpsc2',out_name);

    close(gcf);
    
    fig_res = 0;    

end


