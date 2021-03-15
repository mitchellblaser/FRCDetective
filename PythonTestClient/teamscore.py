import scipy.stats
import numpy

class Round:
	def __init__(self, alliance1, alliance2):
		self.al1 = alliance1
		self.al2 = alliance2
		self.all_teams = alliance1 + alliance2




########[ OPTIONS ]#########
CONSISTENCY_WEIGHT = 0.2
TEAMS = {'5584': [23, 32, 12, 46],
		 '1234': [8, 10, 23, 5],
		 '2345': [8, 6, 7, 9],
		 '3456': [30, 27, 25, 34], 
		 '4567': [28, 24, 12, 35],
		 '5678': [6, 23, 25, 18]}
ROUNDS = [Round([5584, 1234, 2345], [3456, 4567, 5678])]

#####[ compute scores ]#####
TEAM_SCORES = {}
for team in TEAMS:
	TEAM = TEAMS[team]
	TEAM_AVG = numpy.mean(TEAM)
	TEAM_IQR = scipy.stats.iqr(TEAM)
	TEAM_RNG = numpy.amax(TEAM) - numpy.amin(TEAM)
	TEAM_CONSISTENCY = (TEAM_RNG - TEAM_IQR)*CONSISTENCY_WEIGHT
	TEAM_SCORE = TEAM_AVG-TEAM_CONSISTENCY
	TEAM_SCORES[team] = TEAM_SCORE

FINAL_SCORES = {}
for team in TEAMS:
	FINAL_SCORES[team] = 0
	for match in ROUNDS:
		if int(team) in match.al1:
			for alliance_member in match.al1:
				if str(alliance_member) != str(team):
					if TEAM_SCORES[str(alliance_member)] < TEAM_SCORES[str(team)]:
						FINAL_SCORES[str(team)] = FINAL_SCORES[str(team)] + ((TEAM_SCORES[str(alliance_member)] / TEAM_SCORES[str(team)])*CONSISTENCY_WEIGHT)
					elif TEAM_SCORES[str(alliance_member)] > TEAM_SCORES[str(team)]:
						FINAL_SCORES[str(team)] = FINAL_SCORES[str(team)] - ((TEAM_SCORES[str(team)] / TEAM_SCORES[str(alliance_member)])*CONSISTENCY_WEIGHT)
			for opponent_team in match.al2:
				if TEAM_SCORES[str(opponent_team)] > TEAM_SCORES[str(team)]:
					FINAL_SCORES[str(team)] = FINAL_SCORES[str(team)] + ((TEAM_SCORES[str(opponent_team)] / TEAM_SCORES[str(team)])*CONSISTENCY_WEIGHT)
				elif TEAM_SCORES[str(opponent_team)] < TEAM_SCORES[str(team)]:
					FINAL_SCORES[str(team)] = FINAL_SCORES[str(team)] - ((TEAM_SCORES[str(opponent_team)] / TEAM_SCORES[str(team)])*CONSISTENCY_WEIGHT)
		if int(team) in match.al2:
			for alliance_member in match.al2:
				if str(alliance_member) != str(team):
					if TEAM_SCORES[str(alliance_member)] < TEAM_SCORES[str(team)]:
						FINAL_SCORES[str(team)] = FINAL_SCORES[str(team)] + ((TEAM_SCORES[str(alliance_member)] / TEAM_SCORES[str(team)])*CONSISTENCY_WEIGHT)
					elif TEAM_SCORES[str(alliance_member)] > TEAM_SCORES[str(team)]:
						FINAL_SCORES[str(team)] = FINAL_SCORES[str(team)] - ((TEAM_SCORES[str(team)] / TEAM_SCORES[str(alliance_member)])*CONSISTENCY_WEIGHT)
			for opponent_team in match.al1:
				if TEAM_SCORES[str(opponent_team)] > TEAM_SCORES[str(team)]:
					FINAL_SCORES[str(team)] = FINAL_SCORES[str(team)] + ((TEAM_SCORES[str(opponent_team)] / TEAM_SCORES[str(team)])*CONSISTENCY_WEIGHT)
				elif TEAM_SCORES[str(opponent_team)] < TEAM_SCORES[str(team)]:
					FINAL_SCORES[str(team)] = FINAL_SCORES[str(team)] - ((TEAM_SCORES[str(opponent_team)] / TEAM_SCORES[str(team)])*CONSISTENCY_WEIGHT)
	FINAL_SCORES[str(team)] = FINAL_SCORES[str(team)] + TEAM_SCORES[str(team)]
############################

def ScaleTeamScore(score, smallestValue, largestValue, minScale, maxScale):
	if smallestValue != largestValue:
		return ((maxScale-minScale)*((score-smallestValue)/(largestValue-smallestValue)))+minScale
	else:
		return 10

BestTeamScore = numpy.amax(list(FINAL_SCORES.values()))
WorstTeamScore = numpy.amin(list(FINAL_SCORES.values()))	
for team in TEAM_SCORES:
	print("Team " + str(team) + ": " + str(ScaleTeamScore(FINAL_SCORES[team], WorstTeamScore, BestTeamScore, 0, 10)))