# coding=utf-8

import os
from github import Github


class CommitData:
    def __init__(self, linesAdded, linesDeleted, date):
        self.linesAdded = linesAdded
        self.linesDeleted = linesDeleted
        self.date = date
        self.sum = linesDeleted + linesAdded
        self.difference = linesAdded - linesDeleted
        self.daysSinceLastCommit = 0


def getCommitsByRepo(repoLink):
    g = Github(os.getenv("GITHUB_API_TOKEN"))
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
                contributorsCommitsDict[login].append(
                    CommitData(commit.stats.additions, commit.stats.deletions, commit.commit.committer.date))
            else:
                contributorsCommitsDict[login] = [
                    CommitData(commit.stats.additions, commit.stats.deletions, commit.commit.committer.date)]
            count += 1
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
            commit.daysSinceLastCommit = dateDifferenceDays.days + (dateDifferenceDays.seconds / 86400)
            newCommits.append(commit)
        oldCommit = commit
    return newCommits


def getCsvFromCommits(commits):
    data = []
    data.append(["days", "linesAdded", "linesDeleted"])
    for commit in commits:
        data.append([commit.daysSinceLastCommit, commit.linesAdded, commit.linesDeleted])

    return data
