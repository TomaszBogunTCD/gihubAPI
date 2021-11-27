import numpy as np
from github import Github
import token
import matplotlib.pyplot as plt
from flask import Flask
from githubGather import *

app = Flask(__name__)

@app.route("/<userName>/<repoName>/")
def index(userName, repoName):
    repoLink = "https://github.com/" + userName + "/" + repoName
    print("request arrived for repoLink: " + repoLink)
    commits = getCommitsByRepo(repoLink)
    return str(len(commits))


if __name__ == "__main__":
    app.run(debug=True)
