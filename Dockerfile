FROM python:3.11.5-alpine3.18 AS base
WORKDIR /app
EXPOSE 5000
EXPOSE 443

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY . .

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]
