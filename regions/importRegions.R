# import region shapefiles 

# load packages
library(raster)
library(sp)
library(rgdal)
library(rgeos)
library(dplyr)
library(ggplot2)
library(broom)
library(raster)

# --------- #
# --------- #
# HOW TO FIX R4 shapefile
# --------- #
# # import data to fix hole in region 4
# dir.shp = "U:/ORP Operations/Fisheries Program/E-Reporting/4.0 Pilot projects/Roving Monitor Pilot/county_shapefiles/"
# new_zip = shapefile(paste(dir.shp, "Chestertown_Kaycee", sep = ""))
# new_zip_df = broom::tidy(new_zip, region = "ZIPCODE1") %>% mutate(region = 4)
#
# # Create data to match r4 for zip that was left out
# x = as.data.frame(matrix(ncol=5,nrow=1,data = c("Kent",21620,"Chestertown","MD",4)))
# names(x) = names(r4@data)
# new_zip@data <- x
# 
# # join them together
# test = rbind(r4,new_zip)
#
# # Save
# td <- file.path(paste(dir.shp, "Region 4 - Upper Eastern Shore/", sep=""))
# rgdal::writeOGR(obj = test, dsn = td, layer = "Region4edited", driver="ESRI Shapefile", overwrite_layer=FALSE)
# --------- #
# --------- #

# state_with_water=shapefile("G:/1.0 Restoration and Monitoring/8.0 Habitat modeling/NFWF Habitat/rawdata/Maryland_Political_Boundaries__State_Boundary/Maryland_Political_Boundaries__State_Boundary")
#state = shapefile("G:/1.0 Restoration and Monitoring/8.0 Habitat modeling/NFWF Habitat/2.0 Data/rawdata/Maryland_Physical_Boundaries__County_Boundaries_Detailed/Maryland_Physical_Boundaries__County_Boundaries_Detailed")
# bathy = shapefile("G:/1.0 Restoration and Monitoring/8.0 Habitat modeling/NFWF Habitat/rawdata/Maryland_Bathymetry__Chesapeake_Bay_Contours/Maryland_Bathymetry__Chesapeake_Bay_Contours")

# path for all others
#dir.shp = "U:/ORP Operations/Fisheries Program/E-Reporting/4.0 Pilot projects/Pilot Projects/Roving Monitor Pilot/Roving Monitoring folder from Megan/monitoring regions (6) w zip codes/shapefiles of regions/"
#dir.shp = "U:/O365_NEW_ Operations/Sustainable Fisheries/E-Reporting/Pilot Projects/Roving Monitors/Regions/shapefiles of regions"
dir.shp = "~/Oyster Recovery Partnership, Inc/ORP - Operations/Sustainable Fisheries/E-Reporting/Pilot Projects/Roving Monitors/Regions/shapefiles of regions"
# import data
r1 = shapefile(paste(dir.shp, "Region 1 - Lower Western Shore", "Region1", sep = "/"))  
r2 = shapefile(paste(dir.shp, "Region 2 - Middle Western Shore", "Region2", sep = "/"))  
r3 = shapefile(paste(dir.shp, "Region 3 - Upper Western Shore", "Region3", sep = "/"))  
r4 = shapefile(paste(dir.shp, "Region 4 - Upper Eastern Shore", "Region4edited", sep = "/"))  
#r4 = shapefile(paste(dir.shp, "Region 4 - Upper Eastern Shore", "Region4", sep = "/"))   
r5 = shapefile(paste(dir.shp, "Region 5 - Middle Eastern Shore", "Region5", sep = "/"))  
r6 = shapefile(paste(dir.shp, "Region 6 - Lower Eastern Shore", "Region6", sep = "/")) 

# ggplot()+geom_polygon(data = r1, aes(x = long, y = lat, group = group), fill = "indianred1", col = "lightgrey")+
#   geom_polygon(data = r2, aes(x = long, y = lat, group = group), fill = "turquoise2", col = "lightgrey")+
#   geom_polygon(data = r3, aes(x = long, y = lat, group = group), fill = "indianred3", col = "lightgrey")+
#   geom_polygon(data = r4, aes(x = long, y = lat, group = group), fill = "turquoise1", col = "lightgrey")+
#   geom_polygon(data = r5, aes(x = long, y = lat, group = group), fill = "indianred2", col = "lightgrey")+
#   geom_polygon(data = r6, aes(x = long, y = lat, group = group), fill = "turquoise3", col = "lightgrey")

# # points where addresses of landing locations are locatied
# dir.shp = "U:/ORP Operations/Fisheries Program/E-Reporting/4.0 Pilot projects/Roving Monitor Pilot/Roving Monitoring folder from Megan/monitoring regions (6) w zip codes/All Regions w Waterman Names/"
# landingRegions = shapefile(paste(dir.shp, "Landings_Watermen_Regions", sep = "")) 
# landingRegionsData = as.data.frame(landingRegions@data)
# ggplot()+geom_point(data = landingRegionsData, aes(x = Longitude, y = Latitude, col = Zip_code_4))
                      
r1 = spTransform(r1, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
r2 = spTransform(r2, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
r3 = spTransform(r3, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
#r4 = spTransform(r4, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
r5 = spTransform(r5, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
r6 = spTransform(r6, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))

# Save one shapefile with all regions for distribution 
test = rbind(r1, r2, r3, r4, r5, r6)

# td <- file.path(dir.shp)
# rgdal::writeOGR(obj = test, dsn = td, layer = "RovingMonitorRegions", driver="ESRI Shapefile", overwrite_layer=FALSE)


# transform data
r1_df = broom::tidy(r1, region = "Zip_code_4") 
r2_df = broom::tidy(r2, region = "Zip_code_4")
r3_df = broom::tidy(r3, region = "Zip_code_4")
r4_df = broom::tidy(r4, region = "Zip_code_4") 
r5_df = broom::tidy(r5, region = "Zip_code_4")
r6_df = broom::tidy(r6, region = "Zip_code_4")

# create regions df
regions = bind_rows(r1_df, r2_df, r3_df, r4_df, r5_df, r6_df)

# zips
r1_df = broom::tidy(r1, region = "Tidal_Co_1") 
r2_df = broom::tidy(r2, region = "Tidal_Co_1")  
r3_df = broom::tidy(r3, region = "Tidal_Co_1")  
r4_df = broom::tidy(r4, region = "Tidal_Co_1")  
r5_df = broom::tidy(r5, region = "Tidal_Co_1")  
r6_df = broom::tidy(r6, region = "Tidal_Co_1")  

r1_df = r1_df %>% mutate(region = 1) 
r2_df = r2_df %>% mutate(region = 2)
r3_df = r3_df %>% mutate(region = 3)
r4_df = r4_df %>% mutate(region = 4)
r5_df = r5_df %>% mutate(region = 5)
r6_df = r6_df %>% mutate(region = 6)

zips = bind_rows(r1_df, r2_df, r3_df, r4_df, r5_df, r6_df)

zip_region_list = zips %>% rename(Zip = id) %>% dplyr::select(Zip, region) %>% group_by(region) %>% distinct(Zip) %>% ungroup() %>% 
  mutate(region = replace(region, Zip %in% "19975",6),
         region = replace(region, Zip %in% "20625",1),
         region = replace(region, Zip %in% "21052",2),
         region = replace(region, Zip %in% "21106",2),
         region = replace(region, Zip %in% "21624",5),
         region = replace(region, Zip %in% "21653",5),
         region = replace(region, Zip %in% "21664",6),
         region = replace(region, Zip %in% "21843",6),
         region = replace(region, Zip %in% "21914",3))

r1_df = broom::tidy(r1, region = "Tidal_Coun") 
r2_df = broom::tidy(r2, region = "Tidal_Coun")  
r3_df = broom::tidy(r3, region = "Tidal_Coun") 
r4_df = broom::tidy(r4, region = "Tidal_Coun")  
r5_df = broom::tidy(r5, region = "Tidal_Coun") 
r6_df = broom::tidy(r6, region = "Tidal_Coun") 

r1_df = r1_df %>% mutate(region = 1, county_region = paste(id,region,sep="_")) 
r2_df = r2_df %>% mutate(region = 2, county_region = paste(id,region,sep="_"))#,
                         #group = replace(group, group %in% "Anne Arundel.1","Anne Arundel.2"),
                         #group = replace(group, group %in% "Calvert.1","Calvert.2"),
                         #group = replace(group, group %in% "Prince George's.1","Prince George's.2"))
r3_df = r3_df %>% mutate(region = 3, county_region = paste(id,region,sep="_"))
r4_df = r4_df %>% mutate(region = 4, county_region = paste(id,region,sep="_"))
r5_df = r5_df %>% mutate(region = 5, county_region = paste(id,region,sep="_"))
r6_df = r6_df %>% mutate(region = 6, county_region = paste(id,region,sep="_"))

counties = bind_rows(r1_df, r2_df, r3_df, r4_df, r5_df, r6_df)

r1_df = broom::tidy(r1, region = "Tidal_Co_2") 
r2_df = broom::tidy(r2, region = "Tidal_Co_2")
r3_df = broom::tidy(r3, region = "Tidal_Co_2") 
r4_df = broom::tidy(r4, region = "Tidal_Co_2") 
r5_df = broom::tidy(r5, region = "Tidal_Co_2") 
r6_df = broom::tidy(r6, region = "Tidal_Co_2") 

lesser_counties = bind_rows(r1_df, r2_df, r3_df, r4_df, r5_df, r6_df)

rm(r1_df, r2_df, r3_df, r4_df, r5_df, r6_df)

# plots

# ggplot()+geom_polygon(data = regions, aes(x = long, y = lat, group = group, fill = id), color = "black")
# 
# ggplot()+geom_polygon(data = zips, aes(x = long, y = lat, group = group, fill = id), color = "black")+theme(legend.position = "none")
# 
# ggplot()+geom_polygon(data = counties, aes(x = long, y = lat, group = group, fill = id), color = "black")+theme(legend.position = "none")
# 
# ggplot()+geom_polygon(data = counties, aes(x = long, y = lat, group = group, fill = county_region), color = "black")
# 
# 
# ggplot()+geom_polygon(data = lesser_counties, aes(x = long, y = lat, group = group, fill = id), color = "black")+theme(legend.position = "none")

trueCentroids = as.data.frame(cbind(c(1,2,3,4,5,6), 
                      rbind(mean(as.data.frame(rgeos::gCentroid(r1,byid=TRUE))$x),
                            mean(as.data.frame(rgeos::gCentroid(r2,byid=TRUE))$x),
                            mean(as.data.frame(rgeos::gCentroid(r3,byid=TRUE))$x),
                            mean(as.data.frame(rgeos::gCentroid(r4,byid=TRUE))$x),
                            mean(as.data.frame(rgeos::gCentroid(r5,byid=TRUE))$x),
                            mean(as.data.frame(rgeos::gCentroid(r6,byid=TRUE))$x)),
                      rbind(mean(as.data.frame(rgeos::gCentroid(r1,byid=TRUE))$y),
                            mean(as.data.frame(rgeos::gCentroid(r2,byid=TRUE))$y),
                            mean(as.data.frame(rgeos::gCentroid(r3,byid=TRUE))$y),
                            mean(as.data.frame(rgeos::gCentroid(r4,byid=TRUE))$y),
                            mean(as.data.frame(rgeos::gCentroid(r5,byid=TRUE))$y),
                            mean(as.data.frame(rgeos::gCentroid(r6,byid=TRUE))$y))))
names(trueCentroids) = c("region","long","lat")

# path

#zips_new = bind_rows(zips, new_zip_df)
#rm(new_zip_df)

#----#
#chest_zip = shapefile(paste(dir.shp, "Chestertown", sep = ""))

#new_zip = shapefile(paste(dir.shp, "Maryland_Political_Boundaries__ZIP_Codes__5_Digit", sep = "/"))  

# # redefine new region 5
# new_r5 = new_zip[new_zip$ZIPCODE1 %in% c("21601","21607","21612","21617","21619","21623","21625",
#                                 "21629","21632","21636","21638","21639","21640","21644",
#                                 "21647","21649","21651","21652","21654","21655","21657",
#                                 "21658","21660","21662","21663","21665","21666","21668",
#                                 "21671","21673","21676","21679"),]
# 
# test = new_zip[new_zip$ZIPCODE1 %in% "21620",]
# 
# ggplot()+geom_polygon(data = new_r5, aes(long, lat, group = group))+
#   geom_polygon(data = r4, aes(x = long, y = lat, group = group), fill = "cornflowerblue")+
#   geom_polygon(data = test, aes(x = long, y = lat, group = group), fill = "gold")
# 
# ggplot()+ geom_polygon(data = test, aes(x = long, y = lat, group = group))
# 
# river = as.data.frame(rbind(c(-76.05, 39.15),
#                             c(-76.04, 39.175),
#                             c(-76.05, 39.182),
#                             c(-76.06, 39.185),
#                             c(-76.07, 39.19),
#                             c(-76.06, 39.209),
#                             c(-76.03, 39.226),
#                             c(-76.025, 39.226),
#                             c(-76.01, 39.238),
#                             c(-75.989, 39.2398),
#                             c(-75.9865, 39.2398),
#                             c(-75.9865, 39.2455),
#                             c(-75.986, 39.246),
#                             c(-75.98, 39.244),
#                             c(-75.97, 39.25),
#                             c(-75.9, 39.25),
#                             c(-75.9, 39.15),
#                             c(-76.05, 39.15)))
# names(river) = c("long","lat")
# riverPoly = Polygon(river)
# proj4string(riverPoly) = CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
#   
# ggplot()+ 
#   geom_polygon(data = riverPoly, aes(x = long, y = lat), fill = "red")+
#   geom_polygon(data = test, aes(x = long, y = lat, group = group))
# 
# 
# library(rgdal)
# library(dplyr)
# chest <-subset(test, test$long>(-76.7) & test$lat<39.25)
# writeOGR(obj = test, dsn = "U:/ORP Operations/Fisheries Program/E-Reporting/4.0 Pilot projects/Roving Monitor Pilot/county_shapefiles", layer = "Chestertown", driver="ESRI Shapefile") #al
# 
# Chest = shapefile(paste(dir.shp, "Chestertown", sep = "/"))  




# FAILED BITS THAT MIGHT BE USEFUL TO LEARN FROM 
#
#   # fix region 4
# r4_df = bind_rows(r4_df,
#                   rename(new_zip_df, Tidal_Co_1 = id) %>%
#                     dplyr::select(-region,-group) %>%
#                     mutate(group = as.factor(4.99), id = "4"), Zip_code_2= "MD", Tidal_Coun = "Chestertown")
#
#
# create regions shapefile
#r4 = Polygons(list(Polygon(dplyr::select(r4_df, long, lat))), ID = "4")

#x2 <- as(test, "SpatialPolygonsDataFrame")

# test = raster::union(r4,new_zip)
# test@data = rbind(r4@data, new_zip@data)


# x <- list(r4, new_zip)
# x$overwrite <- FALSE
# m <- do.call(merge, x)

# test12 = raster::union(r1,r2)
# test34 = raster::union(r3,test)
# test56 = raster::union(r5,r6)
# test1234 = raster::union(test12,test34)
# test123456 = raster::union(test1234,test56)

#test@area = test@polygons[[1]]@area

# Polys = SpatialPolygons(list(r4,test))
# test_df = rbind(r4@data, new_zip@data)

#testSP = SpatialPolygonsDataFrame(test, data.frame(N="1", row.names = "1"))
#testSP@data = rbind(r4@data, new_zip@data)
# 
# Polys = SpatialPolygons(list(r1,r2,r3,test,r5,r6))
# regions_shapefile = SpatialPolygonsDataFrame(Polys, data.frame(N = c("1","2","3","4","5","6"), row.names = c("1","2","3","4","5","6")))
# proj4string(regions_shapefile) = CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
# 

to.add = as.data.frame(rbind(c(20625, 1), c(21106, 2), c(21624, 5), c(21653, 5), c(21664, 6), c(21914, 3)))
names(to.add) = names(zip_region_list)
zip_region_list = rbind(zip_region_list, to.add)
rm(to.add)
