function [fitresult, gof] = createFit(t, beta)
%CREATEFIT(T,BETA)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : t
%      Y Output: beta
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  另请参阅 FIT, CFIT, SFIT.

%  由 MATLAB 于 16-Feb-2020 18:25:59 自动生成


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( t, beta );

% Set up fittype and options.
ft = fittype( 'poly1' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

% % Plot fit with data.
% figure( 'Name', 'untitled fit 1' );
% h = plot( fitresult, xData, yData );
% legend( h, 'beta vs. t', 'untitled fit 1', 'Location', 'NorthEast', 'Interpreter', 'none' );
% % Label axes
% xlabel( 't', 'Interpreter', 'none' );
% ylabel( 'beta', 'Interpreter', 'none' );
% grid on


