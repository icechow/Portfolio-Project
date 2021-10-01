# Mobile Games A/B Testing

## Description
This kaggle dataset is csv file format. The data we have is from 90,189 players that installed the game while the AB-test was running.
Initially the first gate was placed at level 30, but in this notebook I will going to analyze an AB-test where we moved the first gate in Cookie Cats from level 30 to level 40. I will look at the impact on player retention.

The variables are:

* userid - a unique number that identifies each player.
* version - whether the player was put in the control group (gate_30 - a gate at level 30) or the group with the moved gate (gate_40 - a gate at level 40).
* sum_gamerounds - the number of game rounds played by the player during the first 14 days after install.
* retention_1 - did the player come back and play 1 day after installing?
* retention_7 - did the player come back and play 7 days after installing?

## Result
1-day and 7-day retention is higher when the gate is at level 30 
We should not move the gate from level 30 to level 40
