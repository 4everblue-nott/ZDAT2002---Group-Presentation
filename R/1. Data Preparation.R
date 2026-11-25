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

