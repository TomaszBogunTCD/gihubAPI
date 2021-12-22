# coding=utf-8

import csv
import io
from flask import Flask, make_response
from flask_cors import CORS, cross_origin
from githubGather import *

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

    try:
        commits = getCommitsByRepo(repoLink)
    except Exception as e:
        if e.args[0] == 404:
            print("repo not found")
            return "NotFoundError"
        elif e.args[0] == 403:
            print("API rate limit exceeded")
            return "LimitExceededError"
        elif e.args[1] == 401:
            print("Bad API token")
            return "TokenError"
        else:
            print(e.args)
            print("unknown error")
            return "UnknownError"
    csvList = getCsvFromCommits(commits)
    cw.writerows(csvList)

    output = make_response(si.getvalue())
    output.headers["Content-Disposition"] = "attachment; filename=export.csv"
    output.headers["Content-type"] = "text/csv"
    return output


@app.errorhandler(404)
@cross_origin()
def page_not_found(e):
    return "NotFoundError"


if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
