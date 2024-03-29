# -------------------- # 
# This script is for the roving monitor final report tables and figures
# -------------------- # 

# -------------------- # 
# load packages
# -------------------- # 
require(dplyr)
require(ggplot2)
library(readxl)
library(tidyr)
library(lubridate)
library(utf8) #unsure whats up with this
library(htmlTable)
library(tableHTML)
# -------------------- # 

# -------------------- #
# set directories
# -------------------- # 
dir.in = "Oyster Recovery Partnership, Inc/ORP - Operations/Sustainable Fisheries/E-Reporting/Data/FACTSdata/rawdata/"
dir.in2 = "Oyster Recovery Partnership, Inc/ORP - Operations/Sustainable Fisheries/E-Reporting/Pilot Projects/Pilot Projects/Roving Monitors/Documentation/Resources for RMs/RM scheduling and priority lists/"
dir.in3 = "Oyster Recovery Partnership, Inc/ORP - Operations/Sustainable Fisheries/E-Reporting/Data/temp/"
dir.out = "Oyster Recovery Partnership, Inc/ORP - Operations/Sustainable Fisheries/E-Reporting/Data/FACTSdata/output/final_report_2019/"
# -------------------- # 

# -------------------- #
# load data
# -------------------- # 
# regions
source("U:/ORP Operations/Fisheries Program/E-Reporting/4.0 Pilot projects/Pilot Projects/Roving Monitor Pilot/code/importRegions.R")

# load fishing data
RM <- read_excel(paste(dir.in,"FACTSMD-684.xlsx", sep=""), sheet = 1)
WM <- read_excel(paste(dir.in,"FACTSMD-684.xlsx", sep=""), sheet = 2)

# rename
names(RM) = c("TripID","DNRID","MonitorReportNum","AssignedMonitor",
              "ReportedBy","SpeciesGrade","Quantity","Unit", "Count",          
              "Comments","Result","Scheduled","CrewCount","Time")
names(WM) = c("TripID","DNRID","WatermenName","License","Date",           
              "SH","EH","SHSubmittedTime","EHSubmittedTime","SHLandingTime",  
              "EHLandingTime","SHAddress","SHZip","EHAddress","EHZip",         
              "CrewCount","Fishery","Gear","SpeciesGrade","Quantity",
              "Unit", "Count")

# take spaces out of names
#names(WM) = gsub(" ", "", names(WM), fixed = TRUE)

# needs to be changed in the data
RM = RM %>% mutate(AssignedMonitor = replace(AssignedMonitor, TripID %in% c(565820, 569269, 569582, 574640, 
                                                                            578963, 569640, 569665, 579730,
                                                                            566638, 584714, 584748, 584813, 
                                                                            588244), "Becky Rusteberg K"),
                   AssignedMonitor = replace(AssignedMonitor, TripID %in% c(582379, 582924, 583278, 585968), "Steve Harris Womack"))
# correct data
RM$Quantity[RM$TripID %in% 596007 & RM$SpeciesGrade %in% "FEMALES"] = 16
RM$Quantity[RM$TripID %in% 596007 & RM$SpeciesGrade %in% "MIXED MALES"] = 2

# likely an error but same on the paper report so leaving as is
#RM$Quantity[RM$TripID %in% 606012 & RM$SpeciesGrade %in% "PEELERS"] = 20
#RM$Quantity[RM$TripID %in% 606012 & RM$SpeciesGrade %in% "SOFT SHELL"] = 2
# -------------------- #


# -------------------- #
# manipulate data
# -------------------- # 
# join fishery and name to RM based on trip ID
RM = left_join(RM, dplyr::select(WM, TripID, Fishery, WatermenName, Date) %>% distinct, by = "TripID")

# add regions
WM = left_join(WM, mutate(zip_region_list, Zip = as.numeric(Zip)), by = c("EHZip" = "Zip")) %>% 
  mutate(region = replace(region, is.na(region), "undefined"))
RM = left_join(RM, dplyr::select(WM, TripID, region) %>% distinct, by = "TripID")

# attr(WM$Date, "tzone") <- "EST"
# attr(RM$Date, "tzone") <- "EST"
RM = mutate(RM, Date = as.Date(as.character(Date), format = "%Y-%m-%d"))
WM = mutate(WM, Date = as.Date(as.character(Date), format = "%Y-%m-%d"))

WM = WM %>% filter(Date <= "2019-12-15")
# -------------------- #



# -------------------- #
# best reporting practices summary
# -------------------- #
source("U:/ORP Operations/Fisheries Program/E-Reporting/4.0 Pilot projects/Data/FACTSdata/code/BRP_final_report.R")
# -------------------- #


# -------------------- #
# basic stats
# -------------------- #
# any turtle trips?
length(unique(WM$TripID[!WM$Fishery %in% c("Blue Crab","Finfish")]))

# number of RM trips
length(unique(RM$TripID))

# number of WM trips
length(unique(WM$TripID))

# portion of trips monitored
(length(unique(RM$TripID))/length(unique(WM$TripID)))*100

# portion of trips monitored for FF
(length(unique(RM$TripID[RM$Fishery %in% "Finfish"]))/length(unique(WM$TripID[WM$Fishery %in% "Finfish"])))*100
length(unique(WM$TripID[WM$Fishery %in% "Finfish"]))
length(unique(RM$TripID[RM$Fishery %in% "Finfish"]))
length(unique(RM$TripID[RM$Fishery %in% "Finfish" & RM$Result %in% c("MONITORED","MONITORED (on paper)")]))/ length(unique(RM$TripID[RM$Fishery %in% "Finfish"]))


# portion of trips monitored for BC
(length(unique(RM$TripID[RM$Fishery %in% "Blue Crab"]))/length(unique(WM$TripID[WM$Fishery %in% "Blue Crab"])))*100
length(unique(WM$TripID[WM$Fishery %in% "Blue Crab"]))
length(unique(RM$TripID[RM$Fishery %in% "Blue Crab"]))
length(unique(RM$TripID[RM$Fishery %in% "Blue Crab" & RM$Result %in% c("MONITORED","MONITORED (on paper)")]))/ length(unique(RM$TripID[RM$Fishery %in% "Blue Crab"]))


# successfully monitored
# be careful of reports where they were edited but show both results in data
SuccessTbl = RM %>% dplyr::select(Result, TripID) %>% distinct 
x = RM[RM$TripID %in% SuccessTbl$TripID[duplicated(SuccessTbl$TripID)],]

SuccessTblSum = RM %>% dplyr::select(Result, TripID, MonitorReportNum) %>% distinct %>% 
  mutate(TripNum = paste(TripID, MonitorReportNum, sep="_")) %>%
  filter(!TripNum %in% paste(x$TripID, 1, sep="_")) %>% 
  mutate(Success = ifelse(Result %in% c("MONITORED","MONITORED (on paper)"),"Success","Fail")) %>% 
  group_by(Success) %>% summarize(n=n()) %>%
  mutate(perc = (n/(length(unique(RM$TripID))))*100)
SuccessTblSum 

# how many people made reports
# how many people were attempted to be monitored
# how many people were successfully monitored
length(unique(WM$DNRID))

length(unique(RM$DNRID))
(length(unique(RM$DNRID))/length(unique(WM$DNRID)))*100

length(unique(RM$DNRID[RM$Result %in% c("MONITORED (on paper)","MONITORED")]))
(length(unique(RM$DNRID[RM$Result %in% c("MONITORED (on paper)","MONITORED")]))/length(unique(WM$DNRID)))*100


# by region
# Region	
# Total Available Trips	
# Attempted Trips Monitored	
# Successful Trips Monitored	
# Number of Available Watermen	
# Number of Individual Watermen Monitored	
# % High, % Medium. % Low Priority Ind. Attempted Monitored


# ************************************************* #
#####        CHECK MISSING REGION ZIPS        #######
# ************************************************* #
sort(unique(WM$EHZip[WM$region %in% "undefined"]))
## added
# 20625 - region 1
# 21106 - region 2
# 21624 - region 5
# 21653 - region 5
# 21664 - region 6
# 21914 - region 3 
# 19975 (DE)
# 23423 (VA) 
# 23427 (VA)
# 22630 (VA)
# 
## unknown
# 0 
# 11111 
# 11661 
# 20600 
# 21260 
# 21428 
# 29764

# Figure 5. Trips per month per region
source("U:/ORP Operations/Fisheries Program/E-Reporting/4.0 Pilot projects/Data/FACTSdata/code/Figure4_tripsPerMonthPerRegion.R")

# Table 2. create summary table
source("//orp-dc01/Users/ORP Operations/Fisheries Program/E-Reporting/4.0 Pilot projects/Data/FACTSdata/Table2")
# -------------------- #


# -------------------- #
# trips available in time block when RM was working
# -------------------- #
source("//orp-dc01/Users/ORP Operations/Fisheries Program/E-Reporting/4.0 Pilot projects/Data/FACTSdata/Table3")
# -------------------- #


# -------------------- #
# composed of __ % high, ___% medium, ___% low priority watermen.
# -------------------- #
BCP_OctDec <- read_excel(paste(dir.in2,"ECrabPriority Oct-Dec.xlsx", sep="")) %>% 
  dplyr::select(License, Priority) %>% mutate(startMo = 10, endMo = 12, Fishery = "Blue Crab")
FFP_OctDec <- read_excel(paste(dir.in2,"EFishPriority Oct- Dec.xlsx", sep="")) %>% 
  dplyr::select(License, Priority) %>% mutate(startMo = 10, endMo = 12, Fishery = "Finfish")
R1P1 <- read_excel(paste(dir.in3,"Roving_Monitor_Priority_All_Lists_Region1_MaySept.xlsx", sep=""), sheet1) %>% 
  dplyr::select(DNRid, Monitoring) %>% mutate(startMo = 5, endMo = 6, Fishery = "Finfish")
R1P2 <- read_excel(paste(dir.in3,"Roving_Monitor_Priority_All_Lists_Region1_MaySept.xlsx", sep=""), sheet2) %>% 
  dplyr::select(DNRid, Monitoring) %>% mutate(startMo = 7, endMo = 9, Fishery = "Finfish")
R1P3 <- read_excel(paste(dir.in3,"Roving_Monitor_Priority_All_Lists_Region1_MaySept.xlsx", sep=""), sheet3) %>% 
  dplyr::select(DNRid, Monitoring) %>% mutate(startMo = 4, endMo = 6, Fishery = "Blue Crab")
R1P4 <- read_excel(paste(dir.in3,"Roving_Monitor_Priority_All_Lists_Region1_MaySept.xlsx", sep=""), sheet4) %>% 
  dplyr::select(DNRid, Monitoring) %>% mutate(startMo = 7, endMo = 9, Fishery = "Blue Crab")


R2P <- read_excel(paste(dir.in3,"Roving_Monitor_Priority_All_Lists_Region2_MaySept.xlsx", sep=""))
R3P <- read_excel(paste(dir.in3,"Roving_Monitor_Priority_All_Lists_Region3_MaySept.xlsx", sep=""))
R4P <- read_excel(paste(dir.in3,"Roving_Monitor_Priority_All_Lists_Region4_MaySept.xlsx", sep=""))
R5P <- read_excel(paste(dir.in3,"Roving_Monitor_Priority_All_Lists_Region5_MaySept.xlsx", sep=""))
R6P <- read_excel(paste(dir.in3,"Roving_Monitor_Priority_All_Lists_Region6_MaySept.xlsx", sep=""))


# -------------------- #
# catch comparison
# -------------------- #
# Crab only first since it should be less complicated
# fish can have mult. rows for same species due to different dispositions 
finalEH = WM %>% filter(Fishery %in% "Blue Crab") %>% 
  dplyr::select(TripID, EH, SpeciesGrade, Quantity, Unit) %>% 
  distinct() %>% 
  group_by(TripID) %>%
  mutate(lastH = ifelse(EH %in% max(EH), "yes","no")) %>%
  filter(lastH %in% "yes") %>% ungroup() %>% 
  dplyr::select(-EH, -lastH) %>% 
  rename(WM_spp = SpeciesGrade, WM_quant = Quantity, WM_unit = Unit)

cc = RM %>% filter(Fishery %in% "Blue Crab") %>% 
  dplyr::select(TripID, AssignedMonitor, SpeciesGrade, Quantity, Unit, Result, MonitorReportNum) %>%
  filter(Result %in% c("MONITORED", "MONITORED (on paper)")) %>%
  group_by(TripID) %>%
  mutate(lastR = ifelse(MonitorReportNum %in% max(MonitorReportNum), "yes","no")) %>%
  filter(lastR %in% "yes") %>% ungroup() %>% 
  dplyr::select(-MonitorReportNum, -lastR) %>%
  distinct() %>%
  inner_join(., finalEH, by=c('TripID'='TripID','SpeciesGrade'='WM_spp')) %>% 
  filter(as.character(Unit) == as.character(WM_unit)) %>%
  mutate(QuantDiff = Quantity - WM_quant)

# ggplot() + geom_histogram(data = filter(cc, Unit %in% "BUSHELS"), aes(x = QuantDiff), stat = "count")
# 
# ggplot() + geom_histogram(data = filter(cc, Unit %in% "EACH"), aes(x = QuantDiff), stat = "count")
# 
# ggplot() + geom_histogram(data = filter(cc, Unit %in% "POUNDS"), aes(x = QuantDiff), stat = "count")
# 
# p = ggplot() + geom_boxplot(data = cc, aes(x = SpeciesGrade, y = QuantDiff)) +
#   theme_bw() + 
#   labs(x = "Blue Crab Grade", y = "Roving Monitor Quantity - Waterman Quantity Reported")
# p
# ggsave(paste(dir.out, "BC_cc.png", sep=""), p)

p = ggplot() + geom_boxplot(data = filter(cc, QuantDiff < 100 & QuantDiff > (-49)), aes(x = SpeciesGrade, y = QuantDiff)) +
  theme_bw() + 
  labs(x = "Blue Crab Grade", y = "Roving Monitor Quantity - Waterman Quantity Reported")
p
ggsave(paste(dir.out, "BC_cc.png", sep=""), p)

# ---------- #
# fish
# ---------- #

# ------ #
# quantity
# ------ #

# load comments so filter out those that are half reported
# currently loading comments through google spreadsheet
names(comments) = gsub(" ", "", as.character(unlist(as.list(comments[1,]))), fixed = TRUE)
comments = comments[-1,]
harvest_com_tripID = sort(unique(comments$TripID))

finalEH = WM %>% filter(Fishery %in% "Finfish") %>% 
  dplyr::select(TripID, EH, SpeciesGrade, Quantity, Unit) %>% 
  distinct() %>% 
  group_by(TripID) %>%
  mutate(lastH = ifelse(EH %in% max(EH), "yes","no")) %>%
  filter(lastH %in% "yes") %>% ungroup() %>% 
  dplyr::select(-EH, -lastH) %>% 
  rename(WM_spp = SpeciesGrade, WM_quant = Quantity, WM_unit = Unit) %>% 
  group_by(TripID, WM_spp) %>%
  summarise(WM_quant = sum(WM_quant), WM_unit = first(WM_unit), WM_nd = n_distinct(WM_unit))

cc = RM %>% filter(Fishery %in% "Finfish",
                   !AssignedMonitor %in% "Max Ruehrmund") %>% 
  dplyr::select(TripID, AssignedMonitor, SpeciesGrade, Quantity, Unit, Result, MonitorReportNum) %>%
  filter(Result %in% c("MONITORED", "MONITORED (on paper)")) %>%
  group_by(TripID) %>%
  mutate(lastR = ifelse(MonitorReportNum %in% max(MonitorReportNum), "yes","no")) %>%
  filter(lastR %in% "yes") %>% ungroup() %>% 
  dplyr::select(-MonitorReportNum, -lastR) %>%
  group_by(TripID, SpeciesGrade) %>%
  summarise(Quantity = sum(Quantity), Unit = first(Unit), nd = n_distinct(Unit)) %>%
  inner_join(., finalEH, by=c('TripID'='TripID','SpeciesGrade'='WM_spp')) %>% 
  #filter(as.character(Unit) == as.character(WM_unit)) %>%
  mutate(QuantDiff = Quantity - WM_quant)

x = cc[cc$TripID %in% harvest_com_tripID,] %>% 
  left_join(., mutate(comments, TripID = as.integer(TripID)) %>% dplyr::select(TripID, Comments), by = "TripID")

cc = filter(cc, !TripID %in% c(533729, 534206, 534750, 535203, 535245))

p = ggplot() + geom_boxplot(data = cc, aes(x = SpeciesGrade, y = QuantDiff)) +
  theme_bw() + 
  theme(text = element_text(size=12),
        axis.text.x = element_text(angle = 45, hjust = 1))+
  labs(x = "Species", y = "Roving Monitor Quantity - Waterman Quantity Reported")
p
ggsave(paste(dir.out, "FF_cc.png", sep=""), p)


# ------ #
# count
# ------ #
finalEH = WM %>% filter(Fishery %in% "Finfish") %>% 
  dplyr::select(TripID, EH, SpeciesGrade, Count) %>% 
  distinct() %>% 
  group_by(TripID) %>%
  mutate(lastH = ifelse(EH %in% max(EH), "yes","no")) %>%
  filter(lastH %in% "yes") %>% ungroup() %>% 
  dplyr::select(-EH, -lastH) %>% 
  rename(WM_spp = SpeciesGrade, WM_count = Count, WM_unit = Unit) %>% 
  group_by(TripID, WM_spp) %>%
  summarise(WM_count = sum(WM_count))

cc = RM %>% filter(Fishery %in% "Finfish",
                   !AssignedMonitor %in% "Max Ruehrmund") %>% 
  dplyr::select(TripID, AssignedMonitor, SpeciesGrade, Count, Result, MonitorReportNum) %>%
  filter(Result %in% c("MONITORED", "MONITORED (on paper)")) %>%
  group_by(TripID) %>%
  mutate(lastR = ifelse(MonitorReportNum %in% max(MonitorReportNum), "yes","no")) %>%
  filter(lastR %in% "yes") %>% ungroup() %>% 
  dplyr::select(-MonitorReportNum, -lastR) %>%
  group_by(TripID, SpeciesGrade) %>%
  summarise(Count = sum(Count)) %>%
  inner_join(., finalEH, by=c('TripID'='TripID','SpeciesGrade'='WM_spp')) %>% 
  mutate(CountDiff = Count - WM_count) %>%
  filter(!is.na(CountDiff))

cc = filter(cc, !TripID %in% c(533992, 534123))

p = ggplot() + geom_boxplot(data = cc, aes(x = SpeciesGrade, y = CountDiff)) +
  theme_bw() + 
  theme(text = element_text(size=15))+
  labs(x = "Species", y = "Roving Monitor Count - Waterman Count Reported")
p
ggsave(paste(dir.out, "FF_count_cc.png", sep=""), p)
# -------------------- #


# -------------------- #
# effort comparisson
# -------------------- #
finalEH = WM %>% dplyr::select(TripID, EH, CrewCount) %>% 
  distinct() %>% 
  group_by(TripID) %>%
  mutate(lastH = ifelse(EH %in% max(EH), "yes","no")) %>%
  filter(lastH %in% "yes") %>% ungroup() %>% 
  dplyr::select(-EH, -lastH) %>%
  distinct() 

ec = RM %>% dplyr::select(TripID, AssignedMonitor,CrewCount, MonitorReportNum, Result) %>%
  filter(Result %in% c("MONITORED", "MONITORED (on paper)")) %>%
  group_by(TripID) %>%
  mutate(lastR = ifelse(MonitorReportNum %in% max(MonitorReportNum), "yes","no")) %>%
  filter(lastR %in% "yes") %>% ungroup() %>% 
  dplyr::select(-MonitorReportNum, -lastR) %>%
  distinct() %>%
  inner_join(., finalEH, by="TripID") %>%
  mutate(crewdiff = CrewCount.x - CrewCount.y)

ec %>% group_by(crewdiff) %>% summarise(n=n())

ec %>% mutate(crewdiff = ifelse(crewdiff > 0 | crewdiff < 0, "wrong", crewdiff)) %>% group_by(crewdiff) %>% summarise(n=n())

ec %>% mutate(crewdiff = ifelse(crewdiff > 0, "over", crewdiff),
              crewdiff = ifelse(crewdiff < 0, "under", crewdiff)) %>% 
  group_by(crewdiff) %>% summarise(n=n())

any(duplicated(ec$TripID))
# -------------------- #
