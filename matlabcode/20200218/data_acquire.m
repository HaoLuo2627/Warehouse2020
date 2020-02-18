function data_acquire(latmin,latmax,lonmin,lonmax,location)
% 数据预处理，将全球海温数据处理成在名为location区域经纬度范围内
% 200m以内水深按季度平均的xlsx文件，便于后续处理
% 示例：data_acquire(55,57,353,358,'Scotland')
if (latmin>latmax)||(lonmin>lonmax)
    error('minimum is greater than maximum, please check the input.')
end

year=1940;
temp_all_mean = [];
temp_all_min = [];
temp_all_max = [];

while year <= 2019
    decade=floor(year/10)*10;
    season=[];
    for month=1:12
        fname=['C:\Users\John\Downloads\SeaTempData\IAP_CZ16_',num2str(decade),'_',num2str(decade+9),'\CZ16_1_2000m_Temp_year_',num2str(year),'_month_',num2str(month,'%02d'),'.nc'];
        depth = ncread(fname,'depth_std');  % Standard depth
        a=depth<=200;   %取0-200m深度水温数据
        lat=ncread(fname,'lat');
        lat_range=(latmin<=lat)&(lat<=latmax);
        lon=ncread(fname,'lon');
        lon_range=(lonmin<=lon)&(lon<=lonmax);
        temp = ncread(fname,'temp');  % Gridded temperature field
        temp=temp(a,lon_range,lat_range);   %取lon_range, lat_range范围内200以内水温数据
        season=[season;mean(temp,'omitnan')]; %按深度平均
        if mod(month,3)==0  %以季度为单位操作,对经纬度范围内所有数据取平均、最小、最大值，降低维度
           temp_mean=mean(season,'all','omitnan');
           temp_min=min(season,[],'all','omitnan');
           temp_max=max(season,[],'all','omitnan');
%             X=find(lon_range);Y=find(lat_range);
%             for i=1:length(X)
%                 for j=1:length(Y)
%                     temp_all=[temp_all;year month/3 lat(Y(j)) lon(X(i)) temp_min(:,i,j)];
%                 end
%             end
            temp_all_mean=[temp_all_mean;year month/3 temp_mean];
            temp_all_min=[temp_all_min;year month/3 temp_min];
            temp_all_max=[temp_all_max;year month/3 temp_max];
            season=[];
        end
    end
    year=year+1;
end

T_mean=table;
T_mean.Year=temp_all_mean(:,1);
T_mean.Season=temp_all_mean(:,2);
T_mean.AverageTemperature=temp_all_mean(:,3);
filename1=['./iac/',location,' (1).xlsx'];
writetable(T_mean,filename1)
T_min=table;
T_min.Year=temp_all_min(:,1);
T_min.Season=temp_all_min(:,2);
T_min.AverageTemperature=temp_all_min(:,3);
filename2=['./iac/',location,' min.xlsx'];
writetable(T_min,filename2)
T_max=table;
T_max.Year=temp_all_max(:,1);
T_max.Season=temp_all_max(:,2);
T_max.AverageTemperature=temp_all_max(:,3);
filename3=['./iac/',location,' max.xlsx'];
writetable(T_max,filename3)
clear