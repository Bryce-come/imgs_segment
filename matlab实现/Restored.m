% x = [1,-0.2,0.3,0.8,-0.5
% -0.2,1,0.6,-0.7,0.2
% 0.3,0.6,1,0.5,-0.3
% 0.8,-0.7,0.5,1,0.7
% -0.5,0.2,-0.3,0.7,1];
x = [1,2,3,4
    3,2,4,1
    2,3,2,4
    3,3,1,12]

matrixplot(x);
matrixplot(x,'DisplayOpt','off');
matrixplot(x,'FillStyle','nofill','TextColor','Auto');
matrixplot(x,'TextColor',[0.7,0.7,0.7],'FigShap','s','FigSize','Auto','ColorBar','on');
matrixplot(x,'TextColor','k','FigShap','d','FigSize','Full','ColorBar','on','FigStyle','Triu');
XVarNames = {'1','2','3','4'};
matrixplot(x,'FigShap','e','FigSize','Auto','ColorBar','on','XVarNames',XVarNames,'YVarNames',XVarNames);