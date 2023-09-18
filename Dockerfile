FROM python:3.11.5-alpine3.18 AS base
WORKDIR /app
EXPOSE 5000
EXPOSE 443

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
COPY . .

# Create a new user and change directory ownership
ENV USER minik8suser
RUN adduser --disabled-password \
    --home /app \
    --gecos '' $USER && chown -R $USER /app

#Impersonate into the new user
USER ${USER}
WORKDIR /app

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]
