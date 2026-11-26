 # ZDAT2002 - Group Presentation
 ## Weekly Log
 ### wc 09/11/2026
 Initial thinking on what data to use and what questions.

 | Idea  | Joint Distributions | Markov Chains |
| ------------- |-------------|---|
| ⚽ Football match states and outcomes      | Goals scored vs conceded, shots vs goals, home vs away   | Win/Draw/Loss or score states transitioning between matches  |
| 🌦️ UK weather: how today's weather predicts tomorrow's      | Temperature, rainfall, pressure, wind   | Dry/Wet/Cold/Hot states → tomorrow's state  |
| 🏥 Hospital demand / A&E pressure      | Attendances, admissions, waiting measures   | Low/Medium/High demand states → next period  |

Had a Teams call to discuss datasets and how to divide the work. We agreed to use football data, as it is familiar and should require minimal background explanation in the presentation.

We considered splitting the project by technical role, such as data preparation, Joint Distributions and Markov Chains. However, feeling was that this could create dependencies between team members.

Instead, each person will develop their own question using both Joint Distributions and Markov Chains, complete their analysis independently, and contribute their findings to the presentation. This allows everyone to work in parallel and demonstrate both technical areas.

We also set up a weekly progress call and agreed to share proposed questions beforehand to avoid duplication and reduce overlap.


 ### wc 16/11/2026
 Settled on question I'm going to investigate:

 > **How does playing at home affect match outcomes and transitions between consecutive results?**

 Abdi has already sourced a dataset (copy of raw data added to my repo), preliminary EDA shows no issues with missing data or duplicate entries and the fields I need to answer the question are available; Date, home and away teams, and Full Time Result (FTR).

One issue I identified is the 2020/21 season, which was heavily affected by COVID restrictions, with many matches played with no or limited crowds. As my question specifically investigates home advantage, including this season could influence the results because one of the usual advantages of playing at home, crowd support, was substantially reduced.

I therefore need to decide whether to exclude 2020/21 from the main analysis or compare it separately as a useful sensitivity check.

### wc 23/11/2026

This week I prepared the football data for my analysis in R. I selected the five completed seasons from 2021/22 to 2025/26, giving 1,900 matches. I excluded 2020/21 from the main analysis because COVID restrictions significantly reduced crowd attendance, which could distort an investigation focused on home advantage.

I validated the selected data by checking for missing values, duplicate matches, valid result codes and consistency between the recorded Full Time Result and the final score. I then transformed each match into two team-level observations, representing the home and away teams separately. Each observation was assigned a venue and a Win, Draw or Loss result.

Finally, I arranged the matches by season, team and date and created consecutive-result variables for the Markov analysis. Transitions were kept within individual seasons to avoid linking matches across summer breaks, when squads, managers and league membership may change. This produced 3,800 team-level observations and 3,700 valid transitions.
I also used a separate Git branch and pull request to practise version control before merging the completed preparation work into the main repository.

## AI Use

Microsoft Copilot was used to support the development of this project by helping to brainstorm and refine the research question, review the proposed analytical scope, and structure the weekly work plan. It was also used to explain R and Git concepts, provide example base R code for data preparation, suggest validation checks, and refine the wording of weekly contribution logs.

The suggested code and methodology were reviewed, adapted and run independently. Dataset selection, methodological decisions, validation of outputs, interpretation of results and conclusions remain my responsibility. Copilot outputs were treated as guidance rather than accepted without verification.
 
