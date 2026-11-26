# ===IMPORT THE DATA===

library(readxl)

raw_matches <- read_excel(
  "data/95-96_25-26.xlsx",
  sheet = "in"
)

head(raw_matches)



# ===SELECT THE REQUIRED SEASONS===

selected_files <- c(
  "season-2122.csv",
  "season-2223.csv",
  "season-2324.csv",
  "season-2425.csv",
  "season-2526.csv"
)

matches <- raw_matches[
  raw_matches$source_file %in% selected_files,
]


# Keep required columns
matches <- matches[
  ,
  c(
    "Date",
    "HomeTeam",
    "AwayTeam",
    "FTHG",
    "FTAG",
    "FTR",
    "source_file"
  )
]

# Rename kept columns for consistency
names(matches) <- c(
  "date",
  "home_team",
  "away_team",
  "home_goals",
  "away_goals",
  "full_time_result",
  "source_file"
)

# Create season variable
matches$season <- substr(
  matches$source_file,
  8,
  11
)

matches$date <- as.Date(matches$date)


# ===VALIDATE MATCH DATA===

# Number of matches
nrow(matches)

# Match count by season
table(matches$season)

# Missing values by column
colSums(is.na(matches))

# Available result codes
table(matches$full_time_result)

# Duplicate matches
duplicate_check <- duplicated(
  matches[
    ,
    c("season", "date", "home_team", "away_team")
  ]
)

sum(duplicate_check)


# ===CREATE HOME TEAM DATASET===

home_results <- data.frame(
  season = matches$season,
  date = matches$date,
  team = matches$home_team,
  opponent = matches$away_team,
  venue = "Home",
  result = ifelse(
    matches$full_time_result == "H",
    "Win",
    ifelse(
      matches$full_time_result == "D",
      "Draw",
      "Loss"
    )
  )
)


# ===CREATE AWAY TEAM DATASET===

away_results <- data.frame(
  season = matches$season,
  date = matches$date,
  team = matches$away_team,
  opponent = matches$home_team,
  venue = "Away",
  result = ifelse(
    matches$full_time_result == "A",
    "Win",
    ifelse(
      matches$full_time_result == "D",
      "Draw",
      "Loss"
    )
  )
)


# ===COMBINE, FACTOR AND SORT DATASETS

team_results <- rbind(
  home_results,
  away_results
)

team_results$venue <- factor(
  team_results$venue,
  levels = c("Home", "Away")
)

team_results$result <- factor(
  team_results$result,
  levels = c("Win", "Draw", "Loss")
)

team_results <- team_results[
  order(
    team_results$season,
    team_results$team,
    team_results$date
  ),
]


# ===VALIDAT TEAM DATASET

# Expected: 3,800
nrow(team_results)

# Check matches per team per season is 38 or 0 (for teams not in epl that season))
team_match_counts <- with(
  team_results,
  table(season, team)
)

# should be no values at 0 or 38
team_match_counts[
  team_match_counts != 0 &
    team_match_counts != 38
]

# check each team has 19 Home and 19 away per season (or zero for teams not in epl that season)
venue_counts <- with(
  team_results,
  table(season, team, venue)
)
# should be no values at 0 or 19
venue_counts[
  venue_counts != 0 &
    venue_counts != 19
]

# ===ADD NEXT RESULT AND VENUE TO THE DATASET===

# create distinct groups for each team/season
team_group <- interaction(
  team_results$season,
  team_results$team,
  drop = TRUE
)

# assign match number to each game in team/season group
team_results$match_number <- ave(
  seq_len(nrow(team_results)),
  team_group,
  FUN = seq_along
)

# for each result get the next result and venue (Home or Away) 
# last match of each season shows next result/venue as NA, this is used to prevent transitions being carried over to the following season
team_results$next_result <- ave(
  as.character(team_results$result),
  team_group,
  FUN = function(x){
    shifted_results <- x[-1]
    next_results <- c(shifted_results, NA)
    return(next_results)
  }
)

team_results$next_venue <- ave(
  as.character(team_results$venue),
  team_group,
  FUN = function(x) {
    shifted_venue <- x[-1]
    next_results <- c(shifted_venue, NA)
    return(next_venue)
  }
)

# ===CREATE TRANSITION DATASET===

transition_data <- team_results[
  # exclude last match of the season (no transition for this game)
  !is.na(team_results$next_result),
  c(
    "season",
    "date",
    "team",
    "result",
    "venue",
    "next_result",
    "next_venue"
  )
]

# rename current result & venue fields for clarity
names(transition_data)[
  names(transition_data) == "result"
] <- "current_result"

names(transition_data)[
  names(transition_data) == "venue"
] <- "current_venue"

# Check for correct number of total rows, expected: 3,700 (20 teams x 37 transitions x 5 seasons )
nrow(transition_data)

# ===SAVE THE DATASETS===

dir.create("output", showWarnings = FALSE)

write.csv(
  team_results,
  "output/team_results.csv",
  row.names = FALSE
)

write.csv(
  transition_data,
  "output/transition_data.csv",
  row.names = FALSE
)
