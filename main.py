import csv
import io
from github import Github
import token
from flask import Flask, make_response
from flask_cors import CORS, cross_origin
from githubGather import *
import json

app = Flask(__name__)
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'

@app.route("/<userName>/<repoName>/")
@cross_origin()
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
