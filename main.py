import numpy as np
from github import Github
from github import *
import token
import matplotlib.pyplot as plt

minCommitSize = 10

# access token should be placed in a file called "token" in the same directory
def getTokenFromFile():
    f = open("token", "r")
    token = f.read()
    f.close()
    return token

class CommitData:
    def __init__(self, userName, linesAdded, linesDeleted, date):
        self.userName = userName
        self.linesAdded = linesAdded
        self.linesDeleted = linesDeleted
        self.date = date
        self.sum = linesDeleted + linesAdded
        self.difference = linesAdded - linesDeleted
        self.daysSinceLastCommit = 0


def getCommitsByRepo(repoLink):
    repoName = repoLink[19:]
    repo = g.get_repo(repoName)
    contributorsCommitsDict = {}

    commits = repo.get_commits()

    commitsLength = commits.totalCount
    count = 0
    for commit in commits:
        try:
            print(f"analysing commits {count}/{commitsLength} in repo {repoName}")
            login = commit.author.login
            if login in contributorsCommitsDict:
                contributorsCommitsDict[login].append(CommitData(login, commit.stats.additions, commit.stats.deletions, commit.commit.committer.date))
            else:
                contributorsCommitsDict[login] = [CommitData(login, commit.stats.additions, commit.stats.deletions, commit.commit.committer.date)]
            count+=1
        except:
            pass

    contributorsCommitsList = getCommitDataListFromDict(contributorsCommitsDict)

    return contributorsCommitsList


def getCommitDataListFromDict(contributorsCommitsDict):
    allCommitsList = []
    for key in contributorsCommitsDict.keys():
        if len(contributorsCommitsDict[key]) > 1:
            contributorsCommitsList = contributorsCommitsDict[key]
            contributorsCommitsList = getCommitsTime(contributorsCommitsList)
            allCommitsList.extend(contributorsCommitsList)
    return allCommitsList

def getCommitsTime(commits):
    newCommits = []
    oldCommit = None
    commits.reverse()
    for commit in commits:
        if oldCommit is not None:
            dateDifferenceDays = commit.date - oldCommit.date
            commit.daysSinceLastCommit = dateDifferenceDays.days + (dateDifferenceDays.seconds/86400)
            newCommits.append(commit)
        oldCommit = commit
    return newCommits

def getFilteredCommits(commits, percent, attribute):
    commits.sort(key=lambda x: x.daysSinceLastCommit, reverse=False)
    filteredDateCommits = commits[int(percent*len(commits) / 100):int((100-percent) * len(commits) / 100)]

    xs = []
    ys = []

    if attribute == "linesAdded":
        commits.sort(key=lambda x: x.linesAdded, reverse=False)
        filteredSizeCommits = commits[int(percent*len(commits) / 100):int((100-percent) * len(commits) / 100)]
    elif attribute == "linesDeleted":
        commits.sort(key=lambda x: x.linesDeleted, reverse=False)
        filteredSizeCommits = commits[int(percent * len(commits) / 100):int((100 - percent) * len(commits) / 100)]
    elif attribute == "sum":
        commits.sort(key=lambda x: x.sum, reverse=False)
        filteredSizeCommits = commits[int(percent * len(commits) / 100):int((100 - percent) * len(commits) / 100)]
    elif attribute == "difference":
        commits.sort(key=lambda x: x.difference, reverse=False)
        filteredSizeCommits = commits[int(percent * len(commits) / 100):int((100 - percent) * len(commits) / 100)]
    else:
        print(f"Invalid attribute {attribute}, should be linesAdded, linesDeleted, sum or difference")
        return xs, ys

    filteredCommitsData = list(set(filteredDateCommits).intersection(set(filteredSizeCommits)))

    for commit in filteredCommitsData:
        xs.append(commit.daysSinceLastCommit)
        if attribute == "linesAdded":
            ys.append(commit.linesAdded)
        elif attribute == "linesDeleted":
            ys.append(commit.linesDeleted)
        elif attribute == "sum":
            ys.append(commit.sum)
        elif attribute == "difference":
            ys.append(commit.difference)
    return xs, ys



g = Github(getTokenFromFile())
if __name__ == "__main__":

    rawCommitsData = getCommitsByRepo("https://github.com/observablehq/runtime")

    plt.subplot(3, 4, 1)
    x, y = getFilteredCommits(rawCommitsData, 5, "linesAdded")
    plt.scatter(x,y)
    plt.title("5% outliers removed")
    plt.ylabel("lines added")
    plt.xlabel("time difference")
    plt.plot(np.unique(x), np.poly1d(np.polyfit(x, y, 1))(np.unique(x)))

    plt.subplot(3, 4, 2)
    x, y = getFilteredCommits(rawCommitsData, 5, "linesDeleted")
    plt.scatter(x, y)
    plt.title("5% outliers removed")
    plt.ylabel("lines deleted")
    plt.xlabel("time difference")
    plt.plot(np.unique(x), np.poly1d(np.polyfit(x, y, 1))(np.unique(x)))

    plt.subplot(3, 4, 3)
    x, y = getFilteredCommits(rawCommitsData, 5, "sum")
    plt.scatter(x, y)
    plt.title("5% outliers removed")
    plt.ylabel("lines sum")
    plt.xlabel("time difference")
    plt.plot(np.unique(x), np.poly1d(np.polyfit(x, y, 1))(np.unique(x)))

    plt.subplot(3, 4, 4)
    x, y = getFilteredCommits(rawCommitsData, 5, "difference")
    plt.scatter(x, y)
    plt.title("5% outliers removed")
    plt.ylabel("line difference")
    plt.xlabel("time difference")
    plt.plot(np.unique(x), np.poly1d(np.polyfit(x, y, 1))(np.unique(x)))

    #########################################################################################

    plt.subplot(3, 4, 5)
    x, y = getFilteredCommits(rawCommitsData, 10, "linesAdded")
    plt.scatter(x, y)
    plt.title("10% outliers removed")
    plt.ylabel("lines added")
    plt.xlabel("time difference")
    plt.plot(np.unique(x), np.poly1d(np.polyfit(x, y, 1))(np.unique(x)))

    plt.subplot(3, 4, 6)
    x, y = getFilteredCommits(rawCommitsData, 10, "linesDeleted")
    plt.scatter(x, y)
    plt.title("10% outliers removed")
    plt.ylabel("lines deleted")
    plt.xlabel("time difference")
    plt.plot(np.unique(x), np.poly1d(np.polyfit(x, y, 1))(np.unique(x)))

    plt.subplot(3, 4, 7)
    x, y = getFilteredCommits(rawCommitsData, 10, "sum")
    plt.scatter(x, y)
    plt.title("10% outliers removed")
    plt.ylabel("lines sum")
    plt.xlabel("time difference")
    plt.plot(np.unique(x), np.poly1d(np.polyfit(x, y, 1))(np.unique(x)))

    plt.subplot(3, 4, 8)
    x, y = getFilteredCommits(rawCommitsData, 10, "difference")
    plt.scatter(x, y)
    plt.title("10% outliers removed")
    plt.ylabel("line difference")
    plt.xlabel("time difference")
    plt.plot(np.unique(x), np.poly1d(np.polyfit(x, y, 1))(np.unique(x)))

    ##########################################################################################

    plt.subplot(3, 4, 9)
    x, y = getFilteredCommits(rawCommitsData, 20, "linesAdded")
    plt.scatter(x, y)
    plt.title("20% outliers removed")
    plt.ylabel("lines added")
    plt.xlabel("time difference")
    plt.plot(np.unique(x), np.poly1d(np.polyfit(x, y, 1))(np.unique(x)))

    plt.subplot(3, 4, 10)
    x, y = getFilteredCommits(rawCommitsData, 20, "linesDeleted")
    plt.scatter(x, y)
    plt.title("20% outliers removed")
    plt.ylabel("lines deleted")
    plt.xlabel("time difference")
    plt.plot(np.unique(x), np.poly1d(np.polyfit(x, y, 1))(np.unique(x)))

    plt.subplot(3, 4, 11)
    x, y = getFilteredCommits(rawCommitsData, 20, "sum")
    plt.scatter(x, y)
    plt.title("20% outliers removed")
    plt.ylabel("lines sum")
    plt.xlabel("time difference")
    plt.plot(np.unique(x), np.poly1d(np.polyfit(x, y, 1))(np.unique(x)))

    plt.subplot(3, 4, 12)
    x, y = getFilteredCommits(rawCommitsData, 20, "difference")
    plt.scatter(x, y)
    plt.title("20% outliers removed")
    plt.ylabel("line difference")
    plt.xlabel("time difference")
    plt.plot(np.unique(x), np.poly1d(np.polyfit(x, y, 1))(np.unique(x)))

    plt.show()