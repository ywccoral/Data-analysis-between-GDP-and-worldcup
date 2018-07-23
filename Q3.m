clear all;clc;close all;
% GDP_Data = readtable('w_gdp.xls','Sheet','Data');
% Worldcup_Data = readtable('WorldCupMatches.csv');
%%
load('GDP_Data.mat');
load('Worldcup_Data.mat');

country_2014 = GDP_Data(4:end,59);
idx_no_2014 = find(strcmp('',table2cell(country_2014)));
num_total = size(country_2014,1);
idx_total = (1:num_total)';
idx_2014 = setdiff(idx_total,idx_no_2014);
GDP_country_2014 = str2double(table2cell(country_2014(idx_2014,1)));
GDP_country_name = GDP_Data.DataSource(idx_2014+3,1);
GDP_1962to2014 = GDP_Data(idx_2014+3,7:59);
[~,idx_2014_des] = sort(GDP_country_2014,'descend');
GDP_select = GDP_country_name(idx_2014_des(1:40));
GDP_select_1962to2014 = GDP_1962to2014(idx_2014_des(1:40),:);

worldcup_1962to2014 = Worldcup_Data(137:852,:);
worldcup_country_1 = worldcup_1962to2014.HomeTeamName;
worldcup_country_2 = worldcup_1962to2014.AwayTeamName;
worldcup_country = [worldcup_country_1;worldcup_country_2];
worldcup_country_tbl = tabulate(worldcup_country);
worldcup_select = sortrows(worldcup_country_tbl,-2);

[country,ia,ib] = intersect(GDP_select,worldcup_select(1:40,1));
country_gdp = GDP_select_1962to2014(ia,:);
country_gdp = str2double(table2cell(country_gdp));
% country_worldcup = GDP_select_1962to2014(ib,:);

country_num = size(country,1);

country_year = zeros(country_num,7*13);
year_increase = 1962:2014;

for i=1:country_num
    idx_country_1 = find(strcmp(country(i),worldcup_country_1));
    idx_country_2 = find(strcmp(country(i),worldcup_country_2));
    idx_country = [idx_country_1;idx_country_2];
    country_year(i,1:size(idx_country,1)) = worldcup_1962to2014.Year(idx_country)';
end

country_times = zeros(country_num,length(year_increase));

for i=1:country_num
    year = country_year(i,:);
    year_tbl = tabulate(year);
    for j=1:length(year_increase)
        yearn=year_increase(j);
        idx_year = find(year_tbl(:,1)==yearn);
        if (idx_year~=0)
            country_times(i,j) = year_tbl(idx_year,2);
        end
    end
end

country_times_total = sum(country_times,2);
country_gdp_total = mean(country_gdp,2);
gdp_increase = (country_gdp(:,2:end)-country_gdp(:,1:end-1))./country_gdp(:,2:end);
gdp_increase_toal = mean(gdp_increase,2);

select_country_idx = [1:8 10:14 16 17];
select_country = country(select_country_idx);
select_gdp = country_gdp_total(select_country_idx);
select_gdp_increase = gdp_increase_toal(select_country_idx);
select_times = country_times_total(select_country_idx);
%%
figure
plot(select_gdp(1), select_times(1), 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 7)
hold on;
plot(select_gdp(2), select_times(2), 'ko', 'MarkerFaceColor', 'y', 'MarkerSize', 7)
hold on;
plot(select_gdp(3), select_times(3), 'ko', 'MarkerFaceColor', 'm', 'MarkerSize', 7)
hold on;
plot(select_gdp(4), select_times(4), 'ko', 'MarkerFaceColor', 'c', 'MarkerSize', 7)
hold on;
plot(select_gdp(5), select_times(5), 'ko', 'MarkerFaceColor', 'r', 'MarkerSize', 7)
hold on;
plot(select_gdp(6), select_times(6), 'ko', 'MarkerFaceColor', 'g', 'MarkerSize', 7)
hold on;
plot(select_gdp(7), select_times(7), 'ko', 'MarkerFaceColor', 'b', 'MarkerSize', 7)
hold on;
plot(select_gdp(8), select_times(8), 'kd', 'MarkerFaceColor', 'k', 'MarkerSize', 7)
hold on;
plot(select_gdp(9), select_times(9), 'kd', 'MarkerFaceColor', 'y', 'MarkerSize', 7)
hold on;
plot(select_gdp(10), select_times(10), 'kd', 'MarkerFaceColor', 'm', 'MarkerSize', 7)
hold on;
plot(select_gdp(11), select_times(11), 'kd', 'MarkerFaceColor', 'c', 'MarkerSize', 7)
hold on;
plot(select_gdp(12), select_times(12), 'kd', 'MarkerFaceColor', 'r', 'MarkerSize', 7)
hold on;
plot(select_gdp(13), select_times(13), 'kd', 'MarkerFaceColor', 'b', 'MarkerSize', 7)
hold on;
plot(select_gdp(14), select_times(14), 'ks', 'MarkerFaceColor', 'k', 'MarkerSize', 7)
hold on;
plot(select_gdp(15), select_times(15), 'ks', 'MarkerFaceColor', 'y', 'MarkerSize', 7)
xt = get(gca, 'XTick');
set(gca, 'FontSize', 16);
title('{\fontsize{16} The average GDP vs The number of the worldcup games between 1962 and 2014}');
xlabel('\fontsize{16} The average GDP (1962-2014)');
ylabel('\fontsize{16} The total number of the worldcup games');
h=legend('Argentina','Australia','Austria','Belgium','Brazil','Colombia','Denmark',...
'France','Italy','Japan','Mexico','Netherlands','Nigeria','Spain','Sweden');
set(h,'FontSize',12);
hold off;
%%
figure
plot(select_gdp_increase(1), select_times(1), 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 7)
hold on;
plot(select_gdp_increase(2), select_times(2), 'ko', 'MarkerFaceColor', 'y', 'MarkerSize', 7)
hold on;
plot(select_gdp_increase(3), select_times(3), 'ko', 'MarkerFaceColor', 'm', 'MarkerSize', 7)
hold on;
plot(select_gdp_increase(4), select_times(4), 'ko', 'MarkerFaceColor', 'c', 'MarkerSize', 7)
hold on;
plot(select_gdp_increase(5), select_times(5), 'ko', 'MarkerFaceColor', 'r', 'MarkerSize', 7)
hold on;
plot(select_gdp_increase(6), select_times(6), 'ko', 'MarkerFaceColor', 'g', 'MarkerSize', 7)
hold on;
plot(select_gdp_increase(7), select_times(7), 'ko', 'MarkerFaceColor', 'b', 'MarkerSize', 7)
hold on;
plot(select_gdp_increase(8), select_times(8), 'kd', 'MarkerFaceColor', 'k', 'MarkerSize', 7)
hold on;
plot(select_gdp_increase(9), select_times(9), 'kd', 'MarkerFaceColor', 'y', 'MarkerSize', 7)
hold on;
plot(select_gdp_increase(10), select_times(10), 'kd', 'MarkerFaceColor', 'm', 'MarkerSize', 7)
hold on;
plot(select_gdp_increase(11), select_times(11), 'kd', 'MarkerFaceColor', 'c', 'MarkerSize', 7)
hold on;
plot(select_gdp_increase(12), select_times(12), 'kd', 'MarkerFaceColor', 'r', 'MarkerSize', 7)
hold on;
plot(select_gdp_increase(13), select_times(13), 'kd', 'MarkerFaceColor', 'b', 'MarkerSize', 7)
hold on;
plot(select_gdp_increase(14), select_times(14), 'ks', 'MarkerFaceColor', 'k', 'MarkerSize', 7)
hold on;
plot(select_gdp_increase(15), select_times(15), 'ks', 'MarkerFaceColor', 'y', 'MarkerSize', 7)
xt = get(gca, 'XTick');
set(gca, 'FontSize', 16);
title('{\fontsize{16} The average GDP increase vs The number of the worldcup games between 1962 and 2014}');
xlabel('\fontsize{16} The average GDP increase (1962-2014)');
ylabel('\fontsize{16} The total number of the worldcup games');
h=legend('Argentina','Australia','Austria','Belgium','Brazil','Colombia','Denmark',...
'France','Italy','Japan','Mexico','Netherlands','Nigeria','Spain','Sweden');
set(h,'FontSize',12);
hold off;