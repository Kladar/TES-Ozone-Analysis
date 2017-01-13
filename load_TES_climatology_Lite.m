%% Script to View NetCDF files in Matlab
% Dr. Owen Cooper, ESRL



%%
clear; clc;
%%%%% Change:
%     plot_month
%     plot_year
%     year_list
%     TES_list input file

%%% List of available pressure surfaces between 1000 and 100 hPa
%%% 1000 909 825 750 681 619 562 511 464 422 383 348 316 287 261 237 215 196 178 162 147 133 121 110 100 

plot_level=825;    %%% enter the pressure level to plot   
plot_month=04  ;    %%% enter the month to plot
plot_year=[2011];
month = num2str(plot_month);
year = '2006' %num2str(plot_year);

%%% TES climatology data provided by Kevin Bowman at NASA JPL on July 26, 2013.


year_list=[2011];

TES_list={
%'/vmro3_ACCMIP-monthly_TES_obs_r1i1p3_200501-200512.nc'
%'/wrk/d1/ocooper/d2/TES_climatology/vmro3_ACCMIP-monthly_TES_obs_r1i1p3_200601-200612.nc'
%'/wrk/d1/ocooper/d2/TES_climatology/vmro3_ACCMIP-monthly_TES_obs_r1i1p3_200701-200712.nc'
%'/wrk/d1/ocooper/d2/TES_climatology/vmro3_ACCMIP-monthly_TES_obs_r1i1p3_200801-200812.nc'
%'/wrk/d1/ocooper/d2/TES_climatology/vmro3_ACCMIP-monthly_TES_obs_r1i1p3_200901-200912.nc'
%'/wrk/d1/ocooper/d2/TES_climatology/vmro3_ACCMIP-monthly_TES_obs_r1i1p3_201001-201012.nc'
 '/TES-Aura_L2-O3-Nadir_2006-04_L2v005_Litev08.nc'
 %'/TES-Aura_L2-O3-Nadir_2011-02_L2v005_Litev08.nc'
% '/TES-Aura_L2-O3-Nadir_2011-03_L2v005_Litev08.nc'
% '/TES-Aura_L2-O3-Nadir_2011-04_L2v005_Litev08.nc'
% '/TES-Aura_L2-O3-Nadir_2011-05_L2v005_Litev08.nc'
% '/TES-Aura_L2-O3-Nadir_2011-06_L2v005_Litev08.nc'
% '/TES-Aura_L2-O3-Nadir_2011-07_L2v005_Litev08.nc'
% '/TES-Aura_L2-O3-Nadir_2011-08_L2v005_Litev08.nc'
% '/TES-Aura_L2-O3-Nadir_2011-09_L2v005_Litev08.nc'
% '/TES-Aura_L2-O3-Nadir_2011-10_L2v005_Litev08.nc'
% '/TES-Aura_L2-O3-Nadir_2011-11_L2v005_Litev08.nc'
% '/TES-Aura_L2-O3-Nadir_2011-12_L2v005_Litev08.nc'
};

%% Variable display and cohesion

for nn=find(year_list==plot_year);


filename=char(TES_list(nn));
ncid=netcdf.open(filename,'NC_NOWRITE');

[ndims,nvars,natts,unlimdimID]=netcdf.inq(ncid);

for gg=1:natts;
  global_att_name=netcdf.inqAttName(ncid,netcdf.getConstant('NC_GLOBAL'),gg-1);
  global_att_value=netcdf.getAtt(ncid,netcdf.getConstant('NC_GLOBAL'),global_att_name);
[num2str(gg-1),' ', global_att_name ':  ' , global_att_value];
end



%%% list all of the variables
for gg=1:nvars;
[varname,vartype,dimids,natts]=netcdf.inqVar(ncid,gg-1);
[num2str(gg-1),' ', varname];
  var_list(gg,:)={num2str(gg-1) varname};
end

var_list;


%%% list attributes for a particular variable, where qq is the variable number
for qq=5;
[varname,vartype,dimids,natts]=netcdf.inqVar(ncid,qq);
for hh=1:natts;
  var_att_name=netcdf.inqAttName(ncid,qq,hh-1);
  var_att_value=netcdf.getAtt(ncid,qq,var_att_name);
[num2str(qq),' ', varname, ':  ' , var_att_name, ':  ', var_att_value];
end
end
var_list;

end

%% Variable Creation
lat_var_number=str2num(char(var_list(find(ismember(var_list(:,2),'latitude')),1)));
lon_var_number=str2num(char(var_list(find(ismember(var_list(:,2),'longitude')),1)));
prs_var_number=str2num(char(var_list(find(ismember(var_list(:,2),'pressure')),1)));
o3_var_number=str2num(char(var_list(find(ismember(var_list(:,2),'species')),1)));
daynight_var_number=str2num(char(var_list(find(ismember(var_list(:,2),'daynightflag')),1)));
date_var_number=str2num(char(var_list(find(ismember(var_list(:,2),'yyyymmdd')),1)));
time_var_number=str2num(char(var_list(find(ismember(var_list(:,2),'time')),1)));
qualitycheck_var_number = str2num(char(var_list(find(ismember(var_list(:,2),'o3_ccurve_qa')),1)));

tes_lat=netcdf.getVar(ncid,lat_var_number);
tes_lon=netcdf.getVar(ncid,lon_var_number);
tes_prs_Pa=netcdf.getVar(ncid,prs_var_number);
tes_o3=double(netcdf.getVar(ncid,o3_var_number));
tes_daynight=netcdf.getVar(ncid,daynight_var_number);
tes_date=double(netcdf.getVar(ncid,date_var_number));
tes_time=double(netcdf.getVar(ncid,time_var_number));
tes_quality=netcdf.getVar(ncid,qualitycheck_var_number);

%%%%% Find missing values and NaN them
tes_o3(find(tes_o3==-999))=NaN;
tes_prs_Pa(find(tes_prs_Pa==-999))=NaN;
tes_daynight(find(tes_daynight==-99))=NaN;
tes_quality(find(tes_quality==-99))=NaN;


%Simplify pressure and date, and convert ozone to ppb
        tes_prs_Pa = round(tes_prs_Pa);
        tes_date = floor(tes_date);
        tes_o3_825 = tes_o3(3,:).*1000000000;
        tes_o3_681 = tes_o3(4,:).*1000000000;
        tes_o3_562 = tes_o3(5,:).*1000000000;
        tes_o3_464 = tes_o3(6,:).*1000000000;
        tes_o3_383 = tes_o3(7,:).*1000000000;
        tes_o3_316 = tes_o3(8,:).*1000000000;

%%%%% But I think the pressure given in the Lite data is already in hPa so
%%%%% I'm commenting this out
%tes_prs=round(tes_prs_Pa/100)
%plot_tes=1000000000*tes_o3(:,:,find(tes_prs==plot_level),plot_month)';


%% Plotting Ozone: The data input stuff
%%% Load your map stuff and transpose some stuff for the coming conflicts
load coast;
tes_lat = tes_lat';
tes_lon = tes_lon';
tes_date = tes_date';
tes_daynight = tes_daynight';

%%% Set the map boundaries
hi_lat=90;
lo_lat=-90;
hi_lon=180 ;
lo_lon=-180;

%%%% Loop to pull out the desired box lat, lon, and values of a TES Lite ozone matrix with lats, lons and values
clc; 
%Change lats and lons of desired box, and comment which pressure level you
%want 

  %%% Boxing data rather than taking it globally
        inputmatrix = [tes_lat ; tes_lon ; tes_o3_825; tes_o3_681; tes_o3_562; tes_o3_464; tes_o3_383; tes_o3_316; tes_date; tes_daynight];
        outputmatrix = [0;0;0;0;0;0;0;0;0;0];
        
        %Name and set the box you are looking at
        plot_area = 'Western US';
        latmin = 25;
        latmax = 55;
        lonmin = -130;
        lonmax = -90;
    
   for i=1:length(inputmatrix(1,:));
     if inputmatrix(1,i) > latmin && inputmatrix(1,i) < latmax && inputmatrix(2,i) > lonmin && inputmatrix(2,i) < lonmax;
        outputmatrix = [outputmatrix , inputmatrix(:,i)];
     end;
   end 

        %here is your output matrix w/ first zeroes removed and all
        %information to creat master matrix 1
        outputmatrix = double(outputmatrix(:,2:end));
        
        tes_o3_825 = tes_o3_825(~isnan(tes_o3_825));
        tes_o3_681 = tes_o3_681(~isnan(tes_o3_681));
        tes_o3_562 = tes_o3_562(~isnan(tes_o3_562));
        tes_o3_464 = tes_o3_464(~isnan(tes_o3_464));
        tes_o3_383 = tes_o3_383(~isnan(tes_o3_383));
        tes_o3_316 = tes_o3_316(~isnan(tes_o3_316));
        
        %Pull from output matrix
        tes_lat_boxed = outputmatrix(1,:);
        tes_lon_boxed = outputmatrix(2,:);
        tes_o3_825_boxed = outputmatrix(3,:);
        tes_o3_681_boxed = outputmatrix(4,:);
        tes_o3_562_boxed = outputmatrix(5,:);
        tes_o3_464_boxed = outputmatrix(6,:);
        tes_o3_383_boxed = outputmatrix(7,:);
        tes_o3_316_boxed = outputmatrix(8,:);
        tes_date_boxed = outputmatrix(9,:);
        tes_daynight_boxed = outputmatrix(10,:);
       
        %Remove NaNs
        tes_o3_825_boxed = tes_o3_825_boxed(~isnan(tes_o3_825_boxed));
        tes_o3_681_boxed = tes_o3_681_boxed(~isnan(tes_o3_681_boxed));
        tes_o3_562_boxed = tes_o3_562_boxed(~isnan(tes_o3_562_boxed));
        tes_o3_464_boxed = tes_o3_464_boxed(~isnan(tes_o3_464_boxed));
        tes_o3_383_boxed = tes_o3_383_boxed(~isnan(tes_o3_383_boxed));
        tes_o3_316_boxed = tes_o3_316_boxed(~isnan(tes_o3_316_boxed));
        
        
        %Calculate averages and sample size
        average_global_681 = mean(tes_o3_681);
        average_global_825 = mean(tes_o3_825);
        
        average_boxed_825 = mean(tes_o3_825_boxed);
        average_boxed_681 = mean(tes_o3_681_boxed);
        average_boxed_562 = mean(tes_o3_562_boxed);
        average_boxed_464 = mean(tes_o3_464_boxed);
        average_boxed_383 = mean(tes_o3_383_boxed);
        average_boxed_316 = mean(tes_o3_316_boxed);
        
        samplesize_boxed = length(tes_lat_boxed);
        uniquedates_boxed = length(unique(tes_date_boxed));
        median_boxed_681 = median(tes_o3_681_boxed);
        
        master_matrix1(:,1:2) = year_index;
        master_matrix1(zz,3) = average_boxed_681;
        master_matrix1(zz,4) = average_boxed_562;
        master_matrix1(zz,5) = average_boxed_464;
        master_matrix1(zz,6) = average_boxed_383;
        master_matrix1(zz,7) = average_boxed_316;
        master_matrix1(zz,8) = samplesize_boxed;
        master_matrix1(zz,9) = uniquedates_boxed;
        
        
        %%%Plotting and saving as JPEG
        plot_lat=[tes_lat_boxed; tes_lat_boxed];
        plot_lon=[tes_lon_boxed; tes_lon_boxed];
        plot_o3_825=[tes_o3_825_boxed; tes_o3_825_boxed];
        plot_o3_681=[tes_o3_681_boxed; tes_o3_681_boxed];
        plot_o3_464 = [tes_o3_464_boxed; tes_o3_464_boxed];


%create average of both global and boxed ozone concentrations (have to
%eliminate NaNs from the global

tes_o3_681 = tes_o3_681(~isnan(tes_o3_681));
tes_o3_825 = tes_o3_825(~isnan(tes_o3_825));
tes_o3_boxed = tes_o3_boxed(~isnan(tes_o3_boxed));
average_global_681 = mean(tes_o3_681);
average_global_825 = mean(tes_o3_825);
average_boxed = mean(tes_o3_boxed)

samplesize_boxed = length(tes_lat_boxed)


% %% Plotting Ozone: Actual plotting code
figure(1);
fig1=figure(1);
clf;
set(fig1,'PaperOrientation','portrait','PaperUnits','centimeters','PaperPosition',[0 0 18 20.5],'Position',[100 50 1200 500])

plot_1=axes('Units','centimeters','position',[1.5,.5,22.5,10]);
hold on
plot3(long,lat,zeros(size(lat)),'k-')
plot_color_o3=mesh(plot_lon,plot_lat,plot_o3);
set(plot_color_o3,'LineStyle','none','LineWidth',[3],'Marker','.','MarkerSize',[8])
hold off
axis([lo_lon hi_lon lo_lat hi_lat])
  set(gca,'XTickLabel',[],'YTickLabel',[],'Color',[.7 .7 .7],'CLim',[30 90])
text(-75,85,['Chinese Coastal TES ozone at 681 hPa ' year ' ' month],'FontSize',[12],'FontName','Helvetica','Color',[0 0 0],'FontWeight','demi')

hhh=axes('Units','centimeters','position',[24.5,3.0,.3,5]);
colorbar1=colorbar(hhh,'peer',plot_1);
ylabel('Ozone, ppbv')
axis([ 0 1 0 80])
set(colorbar1,'FontSize',[10],'FontWeight','normal','FontName','helvetica','YTick',[0:10:100]);



%%
% %%%%% This is all plotting stuff that doesn't work anymore
% figure(1)
% fig1=figure(1)
% clf
% set(fig1,'PaperOrientation','portrait','PaperUnits','centimeters','PaperPosition',[0 0 20 11],'Position',[100 10 900 900])
% 
% plot_1=axes('Units','centimeters','position',[.5,.5,17,9])
% pcolor(tes_lon,tes_lat,plot_tes)
% shading flat
%   set(gca,'CLim',[0 100],'FontSize',[11],'FontWeight','demi','XTickLabel',[],'YTickLabel',[])
% hold on
%   plot(long,lat,'k-','Color',[0 0 0],'Linewidth',[1.5])
% hold off
% axis([-180 180 -90 90])
% title(plot_title)
% 
% hhh=axes('Units','centimeters','position',[18,2,.3,7]);
% colorbar1=colorbar(hhh,'peer',plot_1);
% ylabel('ozone, ppbv','FontSize',[11],'FontWeight','normal','FontName','helvetica')
% set(colorbar1,'FontSize',[11],'FontWeight','normal','FontName','helvetica','YTick',[0:10:100])
% 
% set(gcf,'InvertHardCopy','off','Color',[1 1 1])
% 
% 
% print_name=['TES_ozone_' num2str(plot_level) 'hPa_'  num2str(plot_year) num2str(plot_month,'%02.0f') '.tiff']
% print('-dtiff','-r0',print_name)
% %%