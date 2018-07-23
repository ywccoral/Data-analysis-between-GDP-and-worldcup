clear all;clc;close all;
% data_CCRB = readtable('ccrb_datatransparencyinitiative_20170207.xlsx','Sheet','Complaints_Allegations');
%%
load('data_CCRB.mat');
%%
id = {'NA' '' NaN};
%id = {'NA' 'Other/NA' '' NaN};
mis = ismissing(data_CCRB,id);
logical_miss = logical(sum(double(mis),2));
index_miss = find(logical_miss==1);
index_complete = find(logical_miss~=1);
data = data_CCRB(index_complete,:);
% clear data_CCRB;
[UniqueComplaint, Unique_index, ic] = unique(data.UniqueComplaintId);
UniqueComplaint_num = size(UniqueComplaint,1);
data_Unique = data(Unique_index,:);
fprintf('Number of unique complaints is %d\n', UniqueComplaint_num);
%%
BoroughOfOccurrence = data_Unique.BoroughOfOccurrence;
Borough_tbl = tabulate(BoroughOfOccurrence);
[Borough_max, max_index] = max(cell2mat(Borough_tbl(:,3)));
Borough_maxp = Borough_max/100;
fprintf('The proportion of the largest complaints is %10.10f\n', Borough_maxp);
%%
Brooklin_num = 2629150;
IncidentYear = data_Unique.IncidentYear;
idx_2016 = find(IncidentYear==2016);
Borough_2016 = BoroughOfOccurrence(idx_2016);
Borough_2016_tbl = tabulate(Borough_2016);
Brooklin_complaints_2016 = (max(cell2mat(Borough_2016_tbl(:,2)))/Brooklin_num)*100000;
fprintf('The complaints per 100k residents is %10.10f\n', Brooklin_complaints_2016);
%%
CloseYear = data_Unique.CloseYear;
ReceivedYear = data_Unique.ReceivedYear;
average_Year = mean(CloseYear-ReceivedYear);
fprintf('The average number of years is %10.10f\n', average_Year);
%%
AllegationDescription = data.AllegationDescription;
idx_stop = find(strcmp('Stop',AllegationDescription));
idx_frisk = find(strcmp('Frisk',AllegationDescription));
ComplaintId_stop = data.UniqueComplaintId(idx_stop);
ComplaintId_frisk = data.UniqueComplaintId(idx_frisk);
ComplaintId_stopandfrisk = intersect(ComplaintId_stop,ComplaintId_frisk);
[~,idx_stopandfrisk]=ismember(ComplaintId_stopandfrisk,data_Unique.UniqueComplaintId);
Year_stopandfrisk = num2str(data_Unique.IncidentYear(idx_stopandfrisk));
Year_stopandfrisk_tbl = sortrows(tabulate(Year_stopandfrisk));
[Complaints_max, idx_peaked] = max(cell2mat(Year_stopandfrisk_tbl(:,2)));
idx_2016 = find(strcmp('2016',Year_stopandfrisk_tbl(:,1)));
X = str2num(cell2mat(Year_stopandfrisk_tbl(idx_peaked:idx_2016,1)));
y = cell2mat(Year_stopandfrisk_tbl(idx_peaked:idx_2016,2));
mdl = fitlm(X,y);
% plot(mdl);
Complaint_2018=uint32(predict(mdl,2018));
fprintf('The Complaints in 2018 is %d\n', Complaint_2018);
%%
Investigation=data_Unique.IsFullInvestigation;
Video=data_Unique.ComplaintHasVideoEvidence;
% Observed data
n1 = sum(logical(Investigation.*Video));
N1 = sum(Video);
n2 = sum(logical(Investigation.*not(Video)));
N2 = size(Video,1)-sum(Video);
% Pooled estimate of proportion
p0 = (n1+n2) / (N1+N2);
% Expected counts under H0 (null hypothesis)
n10 = N1 * p0;
n20 = N2 * p0;
% Chi-square test, by hand
observed = [n1 N1-n1 n2 N2-n2];
expected = [n10 N1-n10 n20 N2-n20];
[h,p,stats] = chi2gof([1 2 3 4],'freq',observed,'expected',expected,'ctrs',[1 2 3 4],'nparams',2);
fprintf('The chisquare test statistic is %10.10f\n', stats.chi2stat);
%%
AllegationFADOType = data.AllegationFADOType;
idx_Abuse = find(strcmp('Abuse of Authority',AllegationFADOType));
idx_Discourtesy = find(strcmp('Discourtesy',AllegationFADOType));
idx_Force = find(strcmp('Force',AllegationFADOType));
idx_Offensive = find(strcmp('Offensive Language',AllegationFADOType));
Table_Abuse = tabulate(data.UniqueComplaintId(idx_Abuse));
Table_Discourtesy = tabulate(data.UniqueComplaintId(idx_Discourtesy));
Table_Force = tabulate(data.UniqueComplaintId(idx_Force));
Table_Offensive = tabulate(data.UniqueComplaintId(idx_Offensive));

[UniqueComplaint_CCRB, Unique_index_CCRB, ic] = unique(data_CCRB.UniqueComplaintId);

AllegationFADOType_Abuse = (1:length(UniqueComplaint_CCRB))';
AllegationFADOType_Discourtesy = (1:length(UniqueComplaint_CCRB))';
AllegationFADOType_Force = (1:length(UniqueComplaint_CCRB))';
AllegationFADOType_Offensive = (1:length(UniqueComplaint_CCRB))';
AllegationFADOType_Abuse(:,2) = zeros(length(UniqueComplaint_CCRB),1);
AllegationFADOType_Discourtesy(:,2) = zeros(length(UniqueComplaint_CCRB),1);
AllegationFADOType_Force(:,2) = zeros(length(UniqueComplaint_CCRB),1);
AllegationFADOType_Offensive(:,2) = zeros(length(UniqueComplaint_CCRB),1);

AllegationFADOType_Abuse(1:size(Table_Abuse,1),1:2) = Table_Abuse(:,1:2);
AllegationFADOType_Discourtesy(1:size(Table_Discourtesy,1),1:2) = Table_Discourtesy(:,1:2);
AllegationFADOType_Force(1:size(Table_Force,1),1:2) = Table_Force(:,1:2);
AllegationFADOType_Offensive(1:size(Table_Offensive,1),1:2) = Table_Offensive(:,1:2);

[Abuse,ia,idx_2_Abuse] = intersect(UniqueComplaint,AllegationFADOType_Abuse(:,1));
X_Abuse = AllegationFADOType_Abuse(idx_2_Abuse,2);

[Discourtesy,ia,idx_2_Discourtesy] = intersect(UniqueComplaint,AllegationFADOType_Discourtesy(:,1));
X_Discourtesy = AllegationFADOType_Discourtesy(idx_2_Discourtesy,2);

[Force,ia,idx_2_Force] = intersect(UniqueComplaint,AllegationFADOType_Force(:,1));
X_Force = AllegationFADOType_Force(idx_2_Force,2);

[Offensive,ia,idx_2_Offensive] = intersect(UniqueComplaint,AllegationFADOType_Offensive(:,1));
X_Offensive = AllegationFADOType_Offensive(idx_2_Offensive,2);

X = double(logical([X_Abuse X_Discourtesy X_Force X_Offensive]));

%y
UniqueAllegation_tbl = tabulate(data.UniqueComplaintId);
% idx_zero = find(logical(UniqueAllegation_tbl(:,2))==0);
idx_nozero = find(logical(UniqueAllegation_tbl(:,2))~=0);
UniqueAllegation = UniqueAllegation_tbl(idx_nozero,:);

y = UniqueAllegation(:,2);
mdl = fitlm(X,y);
[maxcoeff,idx_indicator] = max(table2array(mdl.Coefficients(2:5,1)));
fprintf('Abuse of Authority will contain multiple allegations\n');
fprintf('The maximum coefficient of the linear regression is %10.10f\n', maxcoeff);
%%
NY_police_num = 36000;
BoroughOfOccurrence_CCRB = data_CCRB.BoroughOfOccurrence(Unique_index_CCRB);
Borough_CCRB_tbl = tabulate(BoroughOfOccurrence_CCRB);
Complaints_Borough = cell2mat(Borough_CCRB_tbl(1:6,2));
Complaints_num = sum(Complaints_Borough);
Police_Borough = (Complaints_Borough/Complaints_num)*NY_police_num;
Police_Precinct = [12;22;23;16;4];
Police_Average = Police_Borough(1:5)./Police_Precinct;
ratio_Precinct = max(Police_Average)/min(Police_Average);
fprintf('The ratio is %10.10f\n', ratio_Precinct);