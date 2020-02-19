% Map of population density of U.S. states
clear;close all
%%
figure
ax = usamap('all');
set(ax, 'Visible', 'off')
states = shaperead('usastatelo', 'UseGeoCoords', true);
names = {states.Name};
PopDens = {states.PopDens2000};
indexHawaii = strcmp('Hawaii',names);
indexAlaska = strcmp('Alaska',names);
indexConus = ones(1,numel(states));
indexConus(indexHawaii|indexAlaska) = 0; 
indexConus = logical(indexConus);
%%
PopDens = cell2mat(PopDens);
k=6;
map = summer(k);
mysymbolspec = cell(1,numel(names));
% scolor = zeros(length(names),3);
minp=min(PopDens);maxp=max(PopDens);
for i=1:length(names)
    rate=(PopDens(i)-minp)/(maxp-minp);
    if rate < 0.001
        temp = map(1,:);
    elseif rate < 0.0045
        temp = map(2,:);
    elseif rate < 0.0081
        temp = map(3,:);
    elseif rate < 0.0149
        temp = map(4,:);    
    elseif rate < 0.0293
        temp = map(5,:);   
    else 
        temp = map(6,:);
    end
    state_name = names{i};
    mysymbolspec{i}={'Name',char(state_name),'FaceColor',temp};
end
%%
abc = mysymbolspec(indexConus);
symbolConus = makesymbolspec('Polygon',{'default', 'FaceColor', [.9 .9 .8],...
    'LineStyle','-','LineWidth',0.2,'EdgeColor',[.8 .9 .9]},abc{:});
symbolAlaska = makesymbolspec('Polygon',{'default', 'FaceColor', [.9 .9 .8],...
    'LineStyle','-','LineWidth',0.2,'EdgeColor',[.8 .9 .9]},mysymbolspec{indexAlaska});
symbolHawaii = makesymbolspec('Polygon',{'default', 'FaceColor', [.9 .9 .8],...
    'LineStyle','-','LineWidth',0.2,'EdgeColor',[.8 .9 .9]},mysymbolspec{indexHawaii});
geoshow(ax(1), states(indexConus), 'DisplayType', 'polygon', 'SymbolSpec', symbolConus);
geoshow(ax(2), states(indexAlaska), 'DisplayType', 'polygon', 'SymbolSpec', symbolAlaska)
geoshow(ax(3), states(indexHawaii), 'DisplayType', 'polygon', 'SymbolSpec', symbolHawaii)
%%
colormap(map)
hcb = colorbar('EastOutside');
set(hcb,'YTick',[0:1/k:1])
set(hcb,'YTickLabel',num2cell(round([0 0.001 0.0045 0.0081 0.0149 0.0293 1]*maxp)));
title('美国各州人口密度分布图');
%%
for k = 1:3
    setm(ax(k), 'Frame', 'off', 'Grid', 'off',...
      'ParallelLabel', 'off', 'MeridianLabel', 'off')
end