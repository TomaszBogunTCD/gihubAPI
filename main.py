from github import Github
import token


def getTokenFromFile():
    f = open("token", "r")
    token = f.read()
    f.close()
    return token


#prints name of repo of contributors of project
if __name__ == "__main__":
    g = Github(getTokenFromFile())

    for repo in g.get_user().get_repos():
        for user in repo.get_contributors():
            for repo in user.get_repos():
                print(repo.name)