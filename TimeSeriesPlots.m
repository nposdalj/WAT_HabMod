clearvars
close all
%% Parameters defined by user
filePrefix = 'WAT_HZ_04'; % File name to match. 
siteabrev = 'HZ'; %abbreviation of site.
sp = 'Pm'; % your species code
ID_dir = 'E:\Project Sites\HZ\TPWS_125'; %where the ID files are stored
saveDir = 'E:\Project Sites\HZ\Seasonality'; %specify directory to save files
titleNAME = 'Western Atlantic - Heezen Canyon';
%% load environmental
HZ = 'HZ.xlsx';
GS = 'GS.xlsx';
HZ = readtable(HZ);
GS = readtable(GS);
%% load workspace
load([saveDir,'\',siteabrev,'_workspaceStep2.mat']);
load([saveDir,'\',siteabrev,'_workspaceStep3.mat']);
%% Fill in missing days
%day table
dayTable.day= double(dayTable.day);
dayTable = retime(dayTable,'daily','fillwithconstant');

%sex table
binPresence.day = double(binPresence.day);
binPresence = retime(binPresence,'daily','fillwithconstant');
%% Retime for weekly presence
%day table
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

%merge environmental data
if strcmp(siteabrev, 'HZ')
    HZ(end,:) = [];
    monthlyData = join(monthlyTable,HZ);
else
    GS.tbin = monthlyTable.tbin;
    GS.Month = [];
    monthlyData = join(timetable2table(monthlyTable),GS);
end

%sex table - weekly
weekPresence = retime(binPresence,'weekly','sum');
weekPresence.NormEffort_Bin = weekPresence.Effort_Sec ./weekPresence.MaxEffort_Sec;
weekPresence.NormEffort_Bin(isnan(weekPresence.NormEffort_Bin)) = 0;
weekPresence.FeHoursProp = weekPresence.FeHours ./(weekPresence.Effort_Sec ./ (60*60));
weekPresence.JuHoursProp = weekPresence.JuHours ./(weekPresence.Effort_Sec ./ (60*60));
weekPresence.MaHoursProp = weekPresence.MaHours ./(weekPresence.Effort_Sec ./ (60*60));

%sex table - monthly
monthlyPresence = retime(binPresence,'monthly','sum');
monthlyPresence.NormEffort_Bin = monthlyPresence.Effort_Sec ./monthlyPresence.MaxEffort_Sec;
monthlyPresence.NormEffort_Bin(isnan(monthlyPresence.NormEffort_Bin)) = 0;
monthlyPresence.FeHoursProp = monthlyPresence.FeHours ./(monthlyPresence.Effort_Sec ./ (60*60));
monthlyPresence.JuHoursProp = monthlyPresence.JuHours ./(monthlyPresence.Effort_Sec ./ (60*60));
monthlyPresence.MaHoursProp = monthlyPresence.MaHours ./(monthlyPresence.Effort_Sec ./ (60*60));

%merge environmental data
if strcmp(siteabrev, 'HZ')
    monthlyPresence.Month = month(monthlyPresence.tbin);
    monthlyDataSexes = join(monthlyPresence,HZ);
else
    GS.tbin = monthlyPresence.tbin;
    monthlyDataSexes = join(timetable2table(monthlyPresence),GS);
end

%% load ID files for GS
if strcmp(siteabrev,'GS') % if the site name is GS
   itnum = '1';
   detfn = [filePrefix,'.*','ID',itnum,'.mat']; % load the ID files 
   fileList = cellstr(ls(ID_dir));
   fileMatchIdx = find(~cellfun(@isempty,regexp(fileList,detfn))>0);
   fileMatch = fileMatchIdx(4:5); % use ID files from disk 4 and 5 only
   concatFiles = fileList(fileMatch);
   D1 = load(fullfile(ID_dir,concatFiles{1}));
   D1.zID(:,2) = [];
   D2 = load(fullfile(ID_dir,concatFiles{2}));
   D2.zID(:,2) = [];
   D = [D1.zID;D2.zID];
   vTT = datevec(D);
   tbin = datetime([vTT(:,1:4), floor(vTT(:,5)/5)*5, ...
    zeros(length(vTT),1)]);
   Dtable = table(tbin);
   [p,q] = size(Dtable);
   Dtable.Value = ones(p,1);
   Dtable = table2timetable(Dtable);
   D_binData = varfun(@max,Dtable,'GroupingVariable','tbin','InputVariable','Value');
   Dtable_week = retime(D_binData(:,1),'weekly','count');% group times by week
   Dtable_week.Min = Dtable_week.GroupCount*5;
   [p,q] = size(Dtable_week);
   Dtable_week.MinMax = ones(p,1)*7*24*60;
   Dtable_week.EffortBin = weekTable.Effort_Bin(28:41)*5;
   Dtable.Week = week(Dtable.tbin); % add week
   Dtable_week.Prop = Dtable_week.Min./Dtable_week.EffortBin; % proportion of hours per week with echosounder (account for effort)
else
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

%Plot proportion of hours per month with sperm whale presence
figure
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

figure
yyaxis left
bar(weekTable.tbin, weekTable.HoursProp)
hold on
plot(Dtable_week.tbin, Dtable_week.Prop,'.g','MarkerSize',15)
hold off
ylabel('Proportion of hours per week with sperm whale presence')
yyaxis right
plot(weekTable.tbin, weekTable.NormEffort_Bin*100,'.r')
ylim([-1 101])
ylabel('Percent effort')
legend('Sperm Whale','Echosounder','Effort');
title(['Weekly Presence of Sperm whales and Echosounders in the ',titleNAME])
saveas(gcf,[saveDir,'\',siteabrev,'WeeklyPresence_EchoSounder.png']);


%Plot proportion of hours per DAY with presence from each group
figure
subplot(3,1,1)
yyaxis left
bar(binPresence.tbin,binPresence.FeHoursProp,'FaceColor','y','BarWidth',3)
ylim([0 max(binPresence.FeHoursProp)])
yyaxis right
plot(binPresence.tbin, binPresence.NormEffort_Bin*100,'.r')
ylim([-1 101])
title(['Daily Presence of Social Units in the ',titleNAME])
subplot(3,1,2)
yyaxis left
bar(binPresence.tbin,binPresence.JuHoursProp,'FaceColor','b','BarWidth',3)
ylim([0 max(binPresence.JuHoursProp)])
ylabel('Proportion of hours per day with group presence')
yyaxis right
plot(binPresence.tbin, binPresence.NormEffort_Bin*100,'.r')
ylim([-1 101])
ylabel('Percent Effort')
title(['Daily Presence of Mid-Size Animals in the ',titleNAME])
subplot(3,1,3)
yyaxis left
bar(binPresence.tbin,binPresence.MaHoursProp,'FaceColor','c','BarWidth',3)
ylim([0 max(binPresence.MaHoursProp)])
title(['Daily Presence of Males in the ',titleNAME])
yyaxis right
plot(binPresence.tbin, binPresence.NormEffort_Bin*100,'.r')
ylim([-1 101])
saveas(gcf,[saveDir,'\',siteabrev,'DailyPresence_AllClasses_Subplots.png']);

%Plot proportion of hours per WEEK with presence from each group
figure
subplot(3,1,1)
yyaxis left
bar(weekPresence.tbin,weekPresence.FeHoursProp,'FaceColor','y','BarWidth',1)
ylim([0 max(weekPresence.FeHoursProp)])
yyaxis right
plot(weekPresence.tbin, weekPresence.NormEffort_Bin*100,'.r')
ylim([-1 101])
title(['Weekly Presence of Social Units in the ',titleNAME])
subplot(3,1,2)
yyaxis left
bar(weekPresence.tbin,weekPresence.JuHoursProp,'FaceColor','b','BarWidth',1)
ylim([0 max(weekPresence.JuHoursProp)])
ylabel('Proportion of hours per week with group presence')
yyaxis right
plot(weekPresence.tbin, weekPresence.NormEffort_Bin*100,'.r')
ylim([-1 101])
ylabel('Percent Effort')
title(['Weekly Presence of Mid-Size Animals in the ',titleNAME])
subplot(3,1,3)
yyaxis left
bar(weekPresence.tbin,weekPresence.MaHoursProp,'FaceColor','c','BarWidth',1)
ylim([0 max(weekPresence.MaHoursProp)])
title(['Weekly Presence of Males in the ',titleNAME])
yyaxis right
plot(weekPresence.tbin, weekPresence.NormEffort_Bin*100,'.r')
ylim([-1 101])
saveas(gcf,[saveDir,'\',siteabrev,'WeeklyPresence_AllClasses_Subplots.png']);

%Plot proportion of hours per month with male sperm whale presence
figure
bar(monthlyDataSexes.tbin, monthlyDataSexes.MaHoursProp,'k')
addaxis(monthlyDataSexes.tbin,monthlyDataSexes.SST,'b','LineWidth',3)
addaxis(monthlyDataSexes.tbin,monthlyDataSexes.NormEffort_Bin,'.r')
addaxis(monthlyDataSexes.tbin,monthlyDataSexes.CHL,'g','LineWidth',3)
addaxislabel(1,'Proportion of hours per month (PM)')
addaxislabel(2, 'SST (C)')
addaxislabel(3, 'Percent Effort')
addaxislabel(4, 'Chl a (mg/m^3)')
legend('Sperm Whale','SST','Effort','Chl a');
xlim([min(monthlyData.tbin)-15 max(monthlyData.tbin)+15])
title(['Monthly Presence of Males Sperm whales in the ',titleNAME])
saveas(gcf,[saveDir,'\',siteabrev,'MonthlyPresence_Males_withEnviro.png']);

%Plot proportion of hours per month with mid-size sperm whale presence
figure
bar(monthlyDataSexes.tbin, monthlyDataSexes.JuHoursProp,'k')
addaxis(monthlyDataSexes.tbin,monthlyDataSexes.SST,'b','LineWidth',3)
addaxis(monthlyDataSexes.tbin,monthlyDataSexes.NormEffort_Bin,'.r')
addaxis(monthlyDataSexes.tbin,monthlyDataSexes.CHL,'g','LineWidth',3)
addaxislabel(1,'Proportion of hours per month (PM)')
addaxislabel(2, 'SST (C)')
addaxislabel(3, 'Percent Effort')
addaxislabel(4, 'Chl a (mg/m^3)')
legend('Sperm Whale','SST','Effort','Chl a');
xlim([min(monthlyData.tbin)-15 max(monthlyData.tbin)+15])
title(['Monthly Presence of Mid-Size Sperm whales in the ',titleNAME])
saveas(gcf,[saveDir,'\',siteabrev,'MonthlyPresence_MidSize_withEnviro.png']);

%Plot proportion of hours per month with female sperm whale presence
figure
bar(monthlyDataSexes.tbin, monthlyDataSexes.FeHoursProp,'k')
addaxis(monthlyDataSexes.tbin,monthlyDataSexes.SST,'b','LineWidth',3)
addaxis(monthlyDataSexes.tbin,monthlyDataSexes.NormEffort_Bin,'.r')
addaxis(monthlyDataSexes.tbin,monthlyDataSexes.CHL,'g','LineWidth',3)
addaxislabel(1,'Proportion of hours per month (PM)')
addaxislabel(2, 'SST (C)')
addaxislabel(3, 'Percent Effort')
addaxislabel(4, 'Chl a (mg/m^3)')
legend('Sperm Whale','SST','Effort','Chl a');
xlim([min(monthlyData.tbin)-15 max(monthlyData.tbin)+15])
title(['Monthly Presence of Female Sperm whales in the ',titleNAME])
saveas(gcf,[saveDir,'\',siteabrev,'MonthlyPresence_Females_withEnviro.png']);

%% Average yearly plots
%Average yearly presence of proportion of hours per DAY with sperm whale
%presence
figure
bar(meantab365.Day, meantab365.HoursProp)
xlim([0 366])
xlabel('Day')
ylim([0 max(meantab365.HoursProp)]);
ylabel('Average proportion of hours per day with sperm whales present')
title(['Average Daily Presence of Sperm Whales in the ',titleNAME]);
saveas(gcf,[saveDir,'\',siteabrev,'AverageDailyPresence.png']);

%Average yearly presence of proportion of hours per WEEK with sperm whale
%presence
%retime average table
if length(MD) > 365
meantab365.datetime = datetime(meantab365.Day, 'convertfrom','juliandate');
meantab365.Week = week(meantab365.datetime);
meantab365.Week = categorical(meantab365.Week);
[mean, sem, std, var, range] = grpstats(meantab365.HoursProp, meantab365.Week, {'mean','sem','std','var','range'}); %takes the mean of each day of the year
meantable = array2table(mean);
semtable = array2table(sem);
stdtable = array2table(std);
vartable = array2table(var);
rangetable = array2table(range);
newcol_mean = (1:length(mean))';
meanarray365 = [newcol_mean mean sem std var range];
WEEKmeantab365 = array2table(meanarray365);
WEEKmeantab365.Properties.VariableNames = {'Week' 'HoursProp' 'SEM' 'Std' 'Var' 'Range'};
%make figure
figure
bar(WEEKmeantab365.Week, WEEKmeantab365.HoursProp)
xlim([0 52])
xlabel('Week')
ylabel('Average proportion of hours per week with sperm whales present')
title(['Average Weekly Presence of Sperm Whales in the ',titleNAME]);
hold on
errorbar(WEEKmeantab365.Week,WEEKmeantab365.HoursProp, -(WEEKmeantab365.SEM),WEEKmeantab365.SEM)
saveas(gcf,[saveDir,'\',siteabrev,'AverageWeeklyPresence.png']);
else
end

%Average yearly presence of proportion of hours per DAY with presence from
%each group

%Average yearly presence of proportion of hours per WEEK with presence from
%each group

figure
subplot(3,1,1)
bar(binPresence.tbin,binPresence.FeHoursProp,'FaceColor','y','BarWidth',3)
title(['Daily Presence of Social Units in the ',titleNAME])
subplot(3,1,2)
bar(binPresence.tbin,binPresence.JuHoursProp,'FaceColor','b','BarWidth',3)
ylabel('Daily Presence (5-min bins)')
ylim([0 50])
title(['Daily Presence of Mid-Size Animals in the ',titleNAME])
subplot(3,1,3)
bar(binPresence.tbin,binPresence.MaHoursProp,'FaceColor','c','BarWidth',3)
title(['Daily Presence of Males in the ',titleNAME])
saveas(gcf,[saveDir,'\',siteabrev,'DailyPresence_AllClasses_Subplots130.png']);

%Plot daily presence in 5-min bins for all classes in one plot
figure
bar(binPresence.tbin,binPresence.MaleNormBin,'FaceColor','c','BarWidth',1)
ylabel('Daily Presence (5-min bins)')
title(['Daily Presence of Each Size Class at ',titleNAME])
hold on
bar(binPresence.tbin,binPresence.JuvenileNormBin,'FaceColor','b','BarWidth',1)
bar(binPresence.tbin,binPresence.FemaleNormBin,'FaceColor','y','BarWidth',1)
legend('Males','Mid-Size','Social Units')
saveas(gcf,[saveDir,'\',siteabrev,'DailyPresence_AllClasses130.png']);

%Plotting sperm whale presence with presence of each size class over it
dayBinTAB = readtable(dayBinCSV); %read general PM table with presence information
figure
bar(dayBinTAB.tbin,dayBinTAB.NormBin,'k')
hold on
bar(binPresence.tbin,binPresence.MaleNormBin,'FaceColor','c','BarWidth',1)
bar(binPresence.tbin,binPresence.JuvenileNormBin,'FaceColor','b','BarWidth',1)
bar(binPresence.tbin,binPresence.FemaleNormBin,'FaceColor','y','BarWidth',1)
ylabel('Daily Presence (5-min bins)')
title(['Daily Presence with Each Size Class at ',titleNAME])
legend('All','Males','Mid-Size','Social Units')
saveas(gcf,[saveDir,'\',siteabrev,'AllDailyPresence_with_SizeClasses130.png']);