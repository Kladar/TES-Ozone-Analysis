%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This file loads Ryan Kladar and Owen Cooper's monthly single level     %%%
%%% ozone pressure grid.                                                   %%%
%%%                                                                        %%%
%%% Monthly tropospheric single pressure level ozone is derived            %%%
%%% from TES Lite single pressure level ozone.                             %%%
%%% More information on this product can be found at:                      %%%
%%% http://avdc.gsfc.nasa.gov/index.php?site=635564035&id=10               %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear;
%close;

%% Create a single matrix to hold all of the monthly TES data available
year_index = [];
month_index = [];
process_years = 2004:2013;
master_matrix1 = ones(102,9);

for yy=1:length(process_years)
    for mm=1:12
        year_index=[year_index; process_years(yy)];
        month_index=[month_index; mm];
    end
end

%%%Because our data is incomplete year to year and month to month, I'm
%%%removing the months I don't have. Very ugly, but very catered to my data.
year_index = [year_index month_index];

%remove Jan-Aug 2005
year_index = year_index(9:end,:);

%remove June 2005 (no data)
year_index(10,:) = [];

%remove Jan, Feb, March 2012 (no data)
year_index(88:90,:) = [];

%remove last six months of 2013 (no data)
year_index(103:108,:) = [];

%Create all the variables that will grow in the Full Set Monthly Average

% %% Load the monthly TES Lite data
% %Loop all the months in the set to run everything at once, rather than one month at a time
% %for
% month_count = 1
%      
    
%     %For full monthly data set averages, only include the year for which there
%     %is data
%     month = num2str(month_count,'%02d');
%     %pressure_levels = {'464' '562' '681' '825' '1000'};
%     pressure_levels = {'215' '261' '316' '383'};
%     if str2num(month) == 1;
%         year={'2005' '2006' '2007' '2008' '2009' '2010' '2011' '2013'};
%         month_printname = 'January';
%     elseif str2num(month) == 2;
%         year={'2005' '2006' '2007' '2008' '2009' '2010' '2011' '2013'};
%         month_printname = 'February';
%     elseif str2num(month) == 3;
%         year={'2005' '2006' '2007' '2008' '2009' '2010' '2011' '2013'};
%         month_printname = 'March'
%     elseif str2num(month) == 4; 
%         year={'2005' '2006' '2007' '2008' '2009' '2010' '2011' '2012' '2013'};
%         month_printname = 'April';
%     elseif str2num(month) == 5;
%         year={'2005' '2006' '2007' '2008' '2009' '2010' '2011' '2012' '2013'};
%         month_printname = 'May';
%     elseif str2num(month) == 6;
%         year={'2006' '2007' '2008' '2009' '2010' '2011' '2012' '2013'};
%         month_printname = 'June';
%     elseif str2num(month) == 7; 
%         year={'2005' '2006' '2007' '2008' '2009' '2010' '2011' '2012'};
%         month_printname = 'July';
%     elseif str2num(month) == 8;
%         year={'2005' '2006' '2007' '2008' '2009' '2010' '2011' '2012'};
%         month_printname = 'August';
%     elseif str2num(month) == 9;
%         year={'2004' '2005' '2006' '2007' '2008' '2009' '2010' '2011' '2012'};
%         month_printname = 'September';
%     elseif str2num(month) == 10;
%         year={'2004' '2005' '2006' '2007' '2008' '2009' '2010' '2011' '2012'};
%         month_printname = 'October';
%     elseif str2num(month) == 11;
%         year={'2004' '2005' '2006' '2007' '2008' '2009' '2010' '2011' '2012'};
%         month_printname = 'November';
%     elseif str2num(month) == 12;
%         year={'2004' '2005' '2006' '2007' '2008' '2009' '2010' '2011' '2012'};
%         month_printname = 'December';
%     end
    
    %for zz=1:length(year)         %Full set Monthly Averages
        for zz=1:length(year_index)  %Individual Monthly averages
        
        file_name=['TES-Aura_L2-O3-Nadir_'  char(num2str(year_index(zz))) '-' char(num2str(year_index(zz,2),'%02.0f')) '_L2v005_Litev08.nc']
        %file_name = ['TES-Aura_L2-O3-Nadir_' char(year(zz)) '-' char(month) '_L2v005_Litev08.nc']
        %file_name = '/TES-Aura_L2-O3-Nadir_2010-06_L2v005_Litev08.nc'
        
    tes_o3_1000 = [];
    tes_o3_825 = [];
    tes_o3_681 = [];
    tes_o3_562 = [];
    tes_o3_464 = [];
    tes_o3_383 = [];
    tes_o3_316 = [];
    tes_o3_261 = [];
    tes_o3_215 = [];
    tes_lat_total = [];
    tes_lon_total = [];
    
        %year = num2str(year_index(zz));
        %month = num2str(year_index(zz,2));
        
        ncid=netcdf.open(file_name,'NC_NOWRITE');
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
        
        %%% list attributes for a particular variable, where qq is the variable number
        for qq=5;
            [varname,vartype,dimids,natts]=netcdf.inqVar(ncid,qq);
            
            for hh=1:natts;
                var_att_name=netcdf.inqAttName(ncid,qq,hh-1);
                var_att_value=netcdf.getAtt(ncid,qq,var_att_name);
                [num2str(qq),' ', varname, ':  ' , var_att_name, ':  ', var_att_value];
            end
        end
        %% Variable Creation
        %read in variables from the given file
        lat_var_number=str2double(char(var_list(find(ismember(var_list(:,2),'latitude')),1)));
        lon_var_number=str2double(char(var_list(find(ismember(var_list(:,2),'longitude')),1)));
        prs_var_number=str2double(char(var_list(find(ismember(var_list(:,2),'pressure')),1)));
        o3_var_number=str2double(char(var_list(find(ismember(var_list(:,2),'species')),1)));
        daynight_var_number=str2double(char(var_list(find(ismember(var_list(:,2),'daynightflag')),1)));
        date_var_number=str2double(char(var_list(find(ismember(var_list(:,2),'yyyymmdd')),1)));
        time_var_number=str2double(char(var_list(find(ismember(var_list(:,2),'time')),1)));
        qualitycheck_var_number = str2double(char(var_list(find(ismember(var_list(:,2),'o3_ccurve_qa')),1)));
        
        tes_lat=netcdf.getVar(ncid,lat_var_number)';
        tes_lon=netcdf.getVar(ncid,lon_var_number)';
        tes_prs_Pa=netcdf.getVar(ncid,prs_var_number);
        tes_o3=double(netcdf.getVar(ncid,o3_var_number));
        tes_daynight=netcdf.getVar(ncid,daynight_var_number);
        tes_date=double(netcdf.getVar(ncid,date_var_number));
        tes_time=double(netcdf.getVar(ncid,time_var_number));
        tes_quality=netcdf.getVar(ncid,qualitycheck_var_number);
        
        %Find missing values and NaN them
        tes_o3(find(tes_o3==-999))=NaN;
        tes_prs_Pa(find(tes_prs_Pa==-999))=NaN;
        tes_daynight(find(tes_daynight==-99))=NaN;
        tes_quality(find(tes_quality==-99))=NaN;
        
        %Simplify pressure and date, and convert ozone to ppb
        tes_prs_Pa = round(tes_prs_Pa);
        tes_date = floor(tes_date);
        tes_o3_1000 = [tes_o3_1000 tes_o3(2,:).*1000000000];
        tes_o3_825 = [tes_o3_825 tes_o3(3,:).*1000000000];
        tes_o3_681 = [tes_o3_681 tes_o3(4,:).*1000000000];
        tes_o3_562 = [tes_o3_562 tes_o3(5,:).*1000000000];
        tes_o3_464 = [tes_o3_464 tes_o3(6,:).*1000000000];
        tes_o3_383 = [tes_o3_383 tes_o3(7,:).*1000000000];
        tes_o3_316 = [tes_o3_316 tes_o3(8,:).*1000000000];
        tes_o3_261 = [tes_o3_261 tes_o3(9,:).*1000000000];
        tes_o3_215 = [tes_o3_215 tes_o3(10,:).*1000000000];
        tes_lat_total = [tes_lat_total tes_lat];
        tes_lon_total = [tes_lon_total tes_lon];
        
    %end %For Full Set Monthly Averages
    %% Boxing data rather than taking it globally
    
    %         inputmatrix = [tes_lat' ; tes_lon' ; tes_o3_825; tes_o3_681;
    %                        tes_o3_562; tes_o3_464; tes_o3_383; tes_o3_316;
    %                        tes_date'; tes_daynight'];
    %         outputmatrix = [0;0;0;0;0;0;0;0;0;0];
    %
    %         %Name and set the box you are looking at
    %         plot_area = 'Mauna Loa Extended Boxed';
    %         latmin = 10;
    %         latmax = 30;
    %         lonmin = -167;
    %         lonmax = -137;
    %
    %    for i=1:length(inputmatrix(1,:));
    %      if inputmatrix(1,i) > latmin && inputmatrix(1,i) < latmax && inputmatrix(2,i) > lonmin && inputmatrix(2,i) < lonmax;
    %         outputmatrix = [outputmatrix , inputmatrix(:,i)];
    %      end;
    %    end
    %
    %         %here is your output matrix w/ first zeroes removed and all
    %         %information to creat master matrix 1
    %         outputmatrix = double(outputmatrix(:,2:end));
    %
    %         %Pull from output matrix
    %         tes_lat_boxed = outputmatrix(1,:);
    %         tes_lon_boxed = outputmatrix(2,:);
    %         tes_o3_825_boxed = outputmatrix(3,:);
    %         tes_o3_681_boxed = outputmatrix(4,:);
    %         tes_o3_562_boxed = outputmatrix(5,:);
    %         tes_o3_464_boxed = outputmatrix(6,:);
    %         tes_o3_383_boxed = outputmatrix(7,:);
    %         tes_o3_316_boxed = outputmatrix(8,:);
    %         tes_date_boxed = outputmatrix(9,:);
    %         tes_daynight_boxed = outputmatrix(10,:);
    %
    %         %Remove Boxed Data NaNs
    %         tes_o3_825_boxed = tes_o3_825_boxed(~isnan(tes_o3_825_boxed));
    %         tes_o3_681_boxed = tes_o3_681_boxed(~isnan(tes_o3_681_boxed));
    %         tes_o3_562_boxed = tes_o3_562_boxed(~isnan(tes_o3_562_boxed));
    %         %tes_o3_464_boxed = tes_o3_464_boxed(~isnan(tes_o3_464_boxed));
    %         tes_o3_464_boxed_NaN = tes_o3_464_boxed(~isnan(tes_o3_464_boxed));
    %         tes_o3_383_boxed = tes_o3_383_boxed(~isnan(tes_o3_383_boxed));
    %         tes_o3_316_boxed = tes_o3_316_boxed(~isnan(tes_o3_316_boxed));
    
    %% Clean Up Data and Take Statistics of it
    %         %Remove Global Data NaNs, or comment if size matters
    %         tes_o3_825 = tes_o3_825(~isnan(tes_o3_825));
    %         tes_o3_681 = tes_o3_681(~isnan(tes_o3_681));
    %         tes_o3_562 = tes_o3_562(~isnan(tes_o3_562));
    %         %tes_o3_464 = tes_o3_464(~isnan(tes_o3_464));
    %         tes_o3_383 = tes_o3_383(~isnan(tes_o3_383));
    %         tes_o3_316 = tes_o3_316(~isnan(tes_o3_316));
    %
    %         %Calculate averages and sample size
    %         average_global_681 = mean(tes_o3_681);
    %         average_global_825 = mean(tes_o3_825);
    %
    %         average_boxed_825 = mean(tes_o3_825_boxed);
    %         average_boxed_681 = mean(tes_o3_681_boxed);
    %         average_boxed_562 = mean(tes_o3_562_boxed);
    %         average_boxed_464 = mean(tes_o3_464_boxed_NaN);
    %         average_boxed_383 = mean(tes_o3_383_boxed);
    %         average_boxed_316 = mean(tes_o3_316_boxed);
    %
    %         samplesize_boxed = length(tes_lat_boxed);
    %         uniquedates_boxed = length(unique(tes_date_boxed));
    %         median_boxed_681 = median(tes_o3_681_boxed);
    
    
    
    %% Create a master matrix with your generated statistics for Excel Visualization
    
    %Master Matrix 1 will eventually contain, in order, as columns: year, month, pressure
    %level, average global ozone concentration 825hPa, average boxed ozone concentration 825hPa,
    %average global concentration 681hPa, average boxed ozoneconcentration 681hPa, number of boxed points,
    %and number of unique boxed dates
    
    
    %         master_matrix1(:,1:2) = year_index;
    %         master_matrix1(zz,3) = average_boxed_681;
    %         master_matrix1(zz,4) = average_boxed_562;
    %         master_matrix1(zz,5) = average_boxed_464;
    %         master_matrix1(zz,6) = average_boxed_383;
    %         master_matrix1(zz,7) = average_boxed_825;
    %         master_matrix1(zz,8) = samplesize_boxed;
    %         master_matrix1(zz,9) = uniquedates_boxed;
    
    
    %% For combining two months (only use if you know what you're doing)
    %
    %           tes_1_o3_464 = tes_o3_464;
    %           tes_1_o3_lat = tes_lat;
    %           tes_1_o3_lon = tes_lon;
    %
    %
    %           tes_2_o3_464 = tes_o3_464;
    %           tes_2_o3_lat = tes_lat;
    %           tes_2_o3_lon = tes_lon;
    %
    %
    %           tes_o3_464 = [tes_1_o3_464  tes_2_o3_464];
    %           tes_lat = [tes_1_o3_lat tes_2_o3_lat];
    %           tes_lon = [tes_1_o3_lon tes_2_o3_lon];
    
    %% Create a Gridded Data Product
    tes_o3_total = [tes_o3_681]; %[tes_o3_215; tes_o3_261; tes_o3_316; tes_o3_383; tes_o3_464; tes_o3_562; tes_o3_681; tes_o3_825; tes_o3_1000];
    %for mm = 1:length(tes_o3_total) 
        %Step through to make a L3 plot of the TES data
        %Specify grid
        cell_lat_range=3; %degrees
        cell_lon_range=3; %degrees
        
        %Specify Pressure Level
        %tes_o3_pressurelevel = tes_o3_total(mm,:);
        tes_o3_pressurelevel = tes_o3_681;
        
        grid_lon_left_edge=-180:cell_lon_range:180;
        grid_lat_bottom_edge=-90:cell_lat_range:90;
        plot_grid = NaN*ones(length(grid_lat_bottom_edge),length(grid_lon_left_edge));
        
        grid_lon_center=grid_lon_left_edge(1:(length(grid_lon_left_edge)-1))+ cell_lon_range/2;
        grid_lat_center=grid_lat_bottom_edge(1:(length(grid_lat_bottom_edge)-1))+ cell_lat_range/2;
        
        data_grid=NaN*ones(length(grid_lat_center),length(grid_lon_center));
        data_grid_count=NaN*ones(length(grid_lat_center),length(grid_lon_center));
        
        for rr=1:length(grid_lat_center)
            for cc=1:length(grid_lon_center)
                
                keep_tes=find(tes_lat_total<(grid_lat_center(rr)+cell_lat_range/2) & tes_lat_total>(grid_lat_center(rr)-cell_lat_range/2) & tes_lon_total<(grid_lon_center(cc)+cell_lon_range/2) &  tes_lon_total>(grid_lon_center(cc)-cell_lon_range/2));
                %keep_tes=find(tes_lat_boxed<(grid_lat_center(rr)+cell_lat_range/2) & tes_lat_boxed>(grid_lat_center(rr)-cell_lat_range/2) & tes_lon_boxed<(grid_lon_center(cc)+cell_lon_range/2) &  tes_lon_boxed>(grid_lon_center(cc)-cell_lon_range/2));
                
                data_grid_count(rr,cc)=length(keep_tes);
                data_grid(rr,cc)=mean(tes_o3_pressurelevel(keep_tes)); %Comment out for Density Plots
                
            end  %% end of cc loop to step through each column
        end  %% end of rr loop to step through each row
        
        
        %% Creating Plot Variables
        %         plot_lat=[tes_lat_boxed; tes_lat_boxed];
        %         plot_lon=[tes_lon_boxed; tes_lon_boxed];
        %         plot_o3_825=[tes_o3_825_boxed; tes_o3_825_boxed];
        %         plot_o3_681=[tes_o3_681_boxed; tes_o3_681_boxed];
        %         plot_o3_464 = [tes_o3_464_boxed; tes_o3_464_boxed];
        
        
        %Set the map boundaries
        %         hi_lat=90;
        %         lo_lat=-90;
        %         hi_lon=0;
        %         lo_lon=-180;
        
        %Global Default
        hi_lat=90;
        lo_lat=-90;
        hi_lon=180;
        lo_lon=-180;
        
        %% Actual Plotting Code
        
        load coast
        
        %Plot Number 1
        figure(1);
        fig1=figure(1);
        clf;
        set(fig1,'PaperOrientation','portrait','PaperUnits','centimeters','PaperPosition',[0 0 32 20],'Position',[100 50 940 460])
        
        colormap(jet);
        plot_1=axes('Units','centimeters','position',[1.5,.5,22.5,10]);
        
        hold on
        
        plot_grid(1:(180/cell_lon_range),1:(360/cell_lon_range)) = data_grid; %For Ozone Plots
        %plot_grid(1:(180/cell_lon_range),1:(360/cell_lon_range)) = data_grid_count; %For Point Density Plots
        
        plot_color_o3=pcolor(grid_lon_left_edge,grid_lat_bottom_edge,plot_grid);
        shading flat
        plot(long,lat,'k-', 'LineWidth',3)
        set(plot_color_o3,'LineStyle','none','LineWidth',3,'Marker','square','MarkerSize',16)
        hold off
        
        axis([lo_lon hi_lon lo_lat hi_lat])
        set(gca,'XTickLabel',[],'YTickLabel',[],'Color',[.7 .7 .7],'CLim',[20 105]) %For Ozone Plots
        %set(gca,'XTickLabel',[],'YTickLabel',[],'Color',[.7 .7 .7],'CLim',[0 40]) %For Density Plots
        
        titulartext = ['Global TES Ozone at 681 hPa ' char(num2str(year_index(zz))) ' ' char(num2str(year_index(zz,2),'%02.0f')) ]; %For boxed, individual month
        %titulartext = ['Global ' char(month_printname) ' Average for 2005 to 2013 at ' char(pressure_levels(mm)) 'hPa']; %For Full Run
        text(-140,94,titulartext,'FontSize',15,'FontName','Helvetica','Color',[0 0 0],'FontWeight','demi')
        
        hhh=axes('Units','centimeters','position',[25.5,3.0,.3,5]);
        colorbar1=colorbar(hhh,'peer',plot_1);
        
        %ylabel('Points per Grid')
        ylabel('Ozone, ppbv')
        
        axis([ 0 1 0 80])
        
        set(colorbar1,'FontSize',10,'FontWeight','normal','FontName','helvetica','YTick',0:10:100);
        %
        %Plot Number 2
        % figure(1);
        % fig1=figure(1);
        % clf;
        % set(fig1,'PaperOrientation','portrait','PaperUnits','centimeters','PaperPosition',[0 0 25 30],'Position',[100 50 1200 500])
        %
        % colormap(jet);
        % plot_1=axes('Units','centimeters','position',[1.5,.5,22.5,10]);
        % hold on
        % plot3(long,lat,zeros(size(lat)),'k-')
        % plot_color_o3=mesh(plot_lon,plot_lat,plot_o3_825);
        % set(plot_color_o3,'LineStyle','none','LineWidth',[3],'Marker','.','MarkerSize',8)
        % hold off
        % axis([lo_lon hi_lon lo_lat hi_lat])
        % set(gca,'XTickLabel',[],'YTickLabel',[],'Color',[.7 .7 .7],'CLim',[0 80])
        % text(-75,85,['Chinese Coastal TES ozone at 825 hPa ' year ' ' month],'FontSize',12,'FontName','Helvetica','Color',[0 0 0],'FontWeight','demi')
        %
        % hhh=axes('Units','centimeters','position',[24.5,3.0,.3,5]);
        % colorbar1=colorbar(hhh,'peer',plot_1);
        % ylabel('Ozone, ppbv')
        % axis([ 0 1 0 80])
        % set(colorbar1,'FontSize',10,'FontWeight','normal','FontName','helvetica','YTick',0:10:100);
        
        
        %Save plots if loop is used
        %print_name = ['Global_' char(month_printname)  '_Average_for_2005-2013_at_' char(pressure_levels(mm)) '_hPa.jpg'];
        print_name=[ 'TES_Lite_' char(num2str(year_index(zz))) '_' char(num2str(year_index(zz,2),'%02.0f')) '_681hPa.jpg'];
        saveas(fig1, sprintf(print_name));
    %end %Plotting each pressure level
%end % for looping through 12 months
end %for individual monthly averages