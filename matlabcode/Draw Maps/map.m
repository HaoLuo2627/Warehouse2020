% Map of population density of U.S. states
clear;close all
states = shaperead('usastatelo', 'UseGeoCoords', true);
names = {states.Name};
PopDens = {states.PopDens2000};
indexHawaii = strcmp('Hawaii',names);
indexAlaska = strcmp('Alaska',names);
indexConus = 1:numel(states);
indexConus(indexHawaii|indexAlaska) = []; 

PopDens = cell2mat(PopDens);
k=10;
Amap = summer(k);
mysymbolspec = cell(1,numel(names));
minp=min(PopDens);maxp=max(PopDens);
for i=1:length(names)
    count = PopDens(i);
    idx = floor(k*count/maxp);
    idx(idx<1)=1;
    state_name = names{i};
    mysymbolspec{i}={'Name',char(state_name),'FaceColor',Amap(idx,:)};
end

figure
ax = worldmap('USA');
load coast
geoshow(ax, lat, long,...
    'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])

symbols = makesymbolspec('Polygon',{'default', 'FaceColor', [.9 .9 .8],...
    'LineStyle','-','LineWidth',0.2,'EdgeColor',[.8 .9 .9]},mysymbolspec{:});
geoshow(ax, states, 'DisplayType', 'polygon', 'SymbolSpec', symbols)
colormap(summer(k))
hcb = colorbar('EastOutside');
step = round(maxp/(k+1));
set(hcb,'YTick',(0:.1:1));
set(hcb,'YTickLabel',num2cell(0:step:maxp));
title('美国各州人口密度分布图');