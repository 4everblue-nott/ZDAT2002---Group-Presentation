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


 
