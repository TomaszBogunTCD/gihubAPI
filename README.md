# Visualisation

This project's web application is built with flutter and the server from which data is retreived is built from python, flask and uses the github API.

To run the app, first provide your github API access token in the Dockerfile on line 30 by replacing "TOKEN":
```
ENV GITHUB_API_TOKEN=TOKEN
```
This will allow you to increase the API call limit and gather more information.

Once this is done, we can build the docker image by navigating to the folder in the terminal or command prompt and typing:
```
docker build -t visualisation .
```

Then, we can run the image by typing
```
docker run -p 5000:5000 -p 55555:55555 -t visualisation
```

The server web application is located on port 55555.
The python github api gathering server is located on port 5000.

To access and use the visualisation web application type either of the following addressess into your browser address bar:

```
127.0.0.1:55555
```
```
localhost:55555
```

I have included a example/tutorial video in the project folder that demonstrates the visualisation called
```
example.mp4
```
