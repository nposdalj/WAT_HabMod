clearvars
close all
%% Parameters defined by user
filePrefix = 'WAT_BP'; % File name to match. 
siteabrev = 'BP'; %abbreviation of site.
sp = 'Pm'; % your species code
saveDir = 'I:\My Drive\WAT_TPWS_metadataReduced\SeasonalityAnalysis\BP'; %specify directory to load/save detection files
titleNAME = 'Western Atlantic - Gulf Stream'; %title name for plots
HZ = 'C:\Users\nposd\Documents\GitHub\SeaTech\2021-2022\EnvironmentalData\Chla_BP_Daily.csv'; %environmetnal data file name
%% load environmental
HZ = readtable(HZ);
%% load workspace with presence data
load([saveDir,'\',siteabrev,'_workspaceStep2.mat']);
%% Fill in missing days
%day table
dayTable.day= double(dayTable.day);
dayTable = retime(dayTable,'daily','fillwithconstant');
%% Retime for weekly presence
%week table table
weekTable = retime(dayTable,'weekly','sum');
weekTable.NormEffort_Bin = weekTable.Effort_Sec ./weekTable.MaxEffort_Sec;
weekTable.NormEffort_Bin(isnan(weekTable.NormEffort_Bin)) = 0;
weekTable.HoursProp = weekTable.Hours ./ (weekTable.Effort_Sec ./ (60*60));

%monthly table
monthlyTable = retime(dayTable,'monthly','mean');
monthlyTable.NormEffort_Bin = monthlyTable.Effort_Sec ./monthlyTable.MaxEffort_Sec;
monthlyTable.NormEffort_Bin(isnan(monthlyTable.NormEffort_Bin)) = 0;
monthlyTable.HoursProp = monthlyTable.Hours ./ (monthlyTable.Effort_Sec ./ (60*60));
monthlyTable.Month = month(monthlyTable.tbin);
monthlyTable.month = [];

%merge environmental data with presence data
if strcmp(siteabrev, 'HZ')
    HZ(end,:) = [];
    monthlyData = join(monthlyTable,HZ);
elseif strcmp(siteabrev,'BP')
    dayTable.time = dayTable.tbin;
    DailyData = join(dayTable,HZ);
else
    GS.tbin = monthlyTable.tbin;
    GS.Month = [];
    monthlyData = join(timetable2table(monthlyTable),GS);
end


%% Plots
%Plot proportion of hours per DAY with sperm whale presence
figure
yyaxis left
bar(dayTable.tbin, dayTable.HoursProp)
ylim([0 1]);
ylabel('Proportion of hours per day with sperm whale presence')
yyaxis right
plot(dayTable.tbin, dayTable.NormEffort_Bin*100,'.r')
ylim([-1 101])
ylabel('Percent effort')
title(['Daily Presence of Sperm whales in the ',titleNAME])
saveas(gcf,[saveDir,'\',siteabrev,'DailyPresence.png']);

%Plot proportion of hours per WEEK with sperm whale presence
figure
yyaxis left
bar(weekTable.tbin, weekTable.HoursProp)
ylabel('Proportion of hours per week with sperm whale presence')
yyaxis right
plot(weekTable.tbin, weekTable.NormEffort_Bin*100,'.r')
ylim([-1 101])
ylabel('Percent effort')
legend('Sperm Whale','Effort');
title(['Weekly Presence of Sperm whales in the ',titleNAME])
saveas(gcf,[saveDir,'\',siteabrev,'WeeklyPresence.png']);

%Plot sperm whale presence with environmental data and echosounder
figure
bar(pmDATA.tbin,pmDATA.Count_Bin)
addaxis(SST_GS.time,SST_GS.analysed_sst,'b','LineWidth',3)
addaxis(Chl_GS.time,Chl_GS.chla,'g','LineWidth',3)
addaxis(echoTABLE.StartTime,echoTABLE.EchoDuration,'.r')

% yyaxis left
bar(monthlyData.tbin, monthlyData.HoursProp,'k')
addaxis(monthlyData.tbin,monthlyData.SST,'b','LineWidth',3)
addaxis(monthlyData.tbin,monthlyData.NormEffort_Bin,'.r')
addaxis(monthlyData.tbin,monthlyData.CHL,'g','LineWidth',3)
addaxislabel(1,'Proportion of hours per month (PM)')
addaxislabel(2, 'SST (C)')
addaxislabel(3, 'Percent Effort')
addaxislabel(4, 'Chl a (mg/m^3)')
legend('Sperm Whale','SST','Effort','Chl a');
xlim([min(monthlyData.tbin)-15 max(monthlyData.tbin)+15])
title(['Monthly Presence of Sperm whales in the ',titleNAME])
saveas(gcf,[saveDir,'\',siteabrev,'MonthlyPresence_withEnviro.png']);