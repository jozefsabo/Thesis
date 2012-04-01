function fig_res = SABO12_ISO2DFigure(in_data, out_name)

    figure
    
    RGBmap = [0.75 0.31 0.30;0.61 0.73 0.35;0.31 0.51 0.74]; 

    colormap(RGBmap);
    
    %image(in_data)
	image(flipud(in_data))
    
	grid on
    
    set(gca,'FontSize',15);
    %set(gca,'YTickLabel',{' ', '3',' ','7',' ','15',' ', '31'});
    set(gca,'YTickLabel',{' ', '31',' ','15',' ','7',' ', '3'});
    
    set(gca,'XTickLabel',{'200','400','800','1600','3200','6400','12800','25600','102400'});
   	%xlabel(gca,'Input ISO');
	%ylabel(gca,'PSF size');
	
    print(sprintf('-f%d',gcf),'-dpsc2',out_name);

    close(gcf);
    
    fig_res = 0;    

end


