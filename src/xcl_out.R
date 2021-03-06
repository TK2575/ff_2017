#' Prep weekly data to excel spreadsheet

library(XLConnect)
library(purrr)

write_week_to_xl <- function(week_num) {
  filename <- paste0('test/week',week_num,'.xlsx')
  wb <- loadWorkbook(filename, create=T)
  sht_nms <- list('Matches','Team Scoring Summary','Position Scoring Summary','Position Scoring Vs Projection','Roster','Player Scoring Summary', 'Player Scoring Summary - BETA', 'Roster - Expanded')
  map(sht_nms, .f = createSheet, object = wb)
  
  mtchs <- get_matches_data() %>% filter(Week == week_num)
  tm_scrng_smry <- get_matches_data() %>% team_summary()
  pstn_scrng_smry <- get_roster_data() %>% team_slot_summary()
  pstn_scrng_vs_prjctn <- get_roster_data() %>% team_slot_summary(mode='vs_proj')
  rstr <- get_roster_data() %>% filter(Week == week_num)
  plyr_scrng_smry <- get_expanded_roster_data() %>% ex_player_summary()
  plyr_scrng_smry2 <- get_expanded_roster_data() %>% player_scoring_summary()
  rstr_xpnd <- get_expanded_roster_data() %>% filter(Week == week_num)
  
  data <- list(mtchs, tm_scrng_smry, pstn_scrng_smry, pstn_scrng_vs_prjctn, rstr, plyr_scrng_smry, plyr_scrng_smry2, rstr_xpnd)
  
  map2(data, sht_nms, writeWorksheet, object = wb)
  saveWorkbook(wb)
}
