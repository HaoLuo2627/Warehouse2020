% Draw heat map of the number of charging stations in U.S. counties
%%
clear;close all
tic
counties = shaperead('C:\Users\John\Downloads\gadm36_USA_shp\gadm36_USA_2.shp', 'UseGeoCoords', true);
state_names={counties.NAME_1};
county_names={counties.NAME_2};
pipei = readtable("C:\Users\John\Downloads\匹配及未找到对应列表数据.xlsx");
pipei = table2cell(pipei);
for j = 1:numel(counties)
    name=county_names(j);
    ind=strcmp(name,pipei(:,1));
    if any(ind)
        num=cell2mat(pipei(ind,2));
        counties(j).numOfChargingStations = num;
    else
        counties(j).numOfChargingStations = NaN;
    end
end
clear pipei ind
%%
k = 6;
map = spring(k);
nancolor = [1,1,1];
mysymbolspec = cell(1,numel(counties));
% scolor = zeros(numel(counties),3);

ChargingStations = {counties.numOfChargingStations};
ChargingStations = cell2mat(ChargingStations);
max_data=max(ChargingStations);
for i=1:numel(counties)
    if isnan(ChargingStations(i))
        temp=nancolor;
    else
        idx=ceil(k*ChargingStations(i)/max_data);
%         idx(idx<1)=1;
        temp=map(idx,:);
    end
    county_name=county_names{i};
    mysymbolspec{i}={'NAME_2',char(county_name),'FaceColor',temp};
end
% clear ChargingStations;
%%
figure
ax = usamap('all');
set(ax, 'Visible', 'off')
indexConus = ones(1, numel(counties));
indexAlaska = strcmp('Alaska',state_names);
indexHawaii = strcmp('Hawaii',state_names);
indexConus(indexAlaska|indexHawaii)=0;
indexConus=logical(indexConus);
abc = mysymbolspec(indexConus);
symbolConus = makesymbolspec('Polygon',{'default', 'FaceColor', [.9 .9 .8],...
    'LineStyle','-','LineWidth',0.2,'EdgeColor',[.8 .9 .9]},abc{:});
abc = mysymbolspec(indexAlaska);
symbolAlaska = makesymbolspec('Polygon',{'default', 'FaceColor', [.9 .9 .8],...
    'LineStyle','-','LineWidth',0.2,'EdgeColor',[.8 .9 .9]},abc{:});
abc = mysymbolspec(indexHawaii);
symbolHawaii = makesymbolspec('Polygon',{'default', 'FaceColor', [.9 .9 .8],...
    'LineStyle','-','LineWidth',0.2,'EdgeColor',[.8 .9 .9]},abc{:});

geoshow(ax(1), counties(indexConus), 'DisplayType', 'polygon', 'SymbolSpec', symbolConus);
geoshow(ax(2), counties(indexAlaska), 'DisplayType', 'polygon', 'SymbolSpec', symbolAlaska)
geoshow(ax(3), counties(indexHawaii), 'DisplayType', 'polygon', 'SymbolSpec', symbolHawaii)
colormap(map)
hcb = colorbar('EastOutside');
set(hcb,'YTick',[0:1/k:1]);
set(hcb,'YTickLabel',num2cell(round([0:1/k:1]*max_data)));
title('Distribution of Tesla charging piles in U.S. counties');

for k = 1:3
    setm(ax(k), 'Frame', 'off', 'Grid', 'off',...
      'ParallelLabel', 'off', 'MeridianLabel', 'off')
end
toc
beep

