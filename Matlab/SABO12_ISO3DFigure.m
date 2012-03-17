function fig_res = SABO12_ISO3DFigure(tico09, srou03, bm3d, out_name)

    %X  = [3      7     15   31 ];
    %Y  = [0.0001 0.001 0.01 0.1]; 

    figure
    
	hold on 

	view(135,20)
	 
	axis([1 8 1 4 0 40 0 1])
	grid on
	set(gca,'YTickLabel',{'3',' ','7',' ','15',' ', '31',' '})
	set(gca,'XTickLabel',{'200','400','800','1600','3200','6400','12800','25600'})
	 
	hidden off
	mesh(gca, bm3d,'FaceColor','none','EdgeColor','red'  ) 
	 
	hidden off
	mesh(gca, tico09   ,'FaceColor','none','EdgeColor','green')
	 
	hidden off
	mesh(gca, srou03,'FaceColor','none','EdgeColor','blue' )  
	 
	hold off
    
    print(sprintf('-f%d',gcf),'-dpsc2',out_name);
    
    close(gcf); 

    fig_res = 0;    

end


