%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Noise simulation for a particular camera (Canon 300D) by Ojala (2008) %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% input_ISO   - the ISO used to "shoot" the scene
%%% input_image - input single channel image
%%% out_image   - image with added noise 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out_image = OJAL08_CameraNoiseSimulation(input_image, input_ISO)

	%Model parameters as taken from OJAL08 (averaged measurements at 21 °C)
	ISO_values = [200 400 800 1600 3200]; 
	a_values   = [4.64700E-05 9.05967E-05 1.78800E-04 3.57867E-04 7.37933E-04]; 

	b_values   = [6.41233E-08 2.97067E-07 1.01390E-06 3.29467E-06 1.18733E-05]; 

	%Parameter a is approximated with a degree 1 polynomial (line)
	a_poly     = polyfit(ISO_values, a_values, 1); 

	%Parameter b is approximated with a degree 2 polynomial (quadratic function)
	b_poly     = polyfit(ISO_values, b_values, 2); 

	%Evaluation of a and b for the input ISO
	a          = polyval(a_poly, input_ISO); 
	b          = polyval(b_poly, input_ISO); 

	%Adding noise given by the a and b parameters
	out_image  = FOI07_GenerateNoise(input_image, a, b); 

end 