import csv
import io
from github import Github
import token
from flask import Flask, make_response
from githubGather import *

app = Flask(__name__)

@app.route("/<userName>/<repoName>/")
def index(userName, repoName):
    repoLink = "https://github.com/" + userName + "/" + repoName
    print("request arrived for repoLink: " + repoLink)

    si = io.StringIO()
    cw = csv.writer(si)

    commits = getCommitsByRepo(repoLink)
    csvList = getCsvFromCommits(commits)
    cw.writerows(csvList)

    output = make_response(si.getvalue())
    output.headers["Content-Disposition"] = "attachment; filename=export.csv"
    output.headers["Content-type"] = "text/csv"
    return output


if __name__ == "__main__":
    app.run(debug=True)
