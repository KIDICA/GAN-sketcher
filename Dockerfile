FROM ubuntu:18.04

RUN apt-get update && apt-get upgrade -y

RUN apt-get install python3.7 python3-pip curl dirmngr apt-transport-https lsb-release ca-certificates -y
RUN python3.7 -m pip install --upgrade pip --trusted-host pypi.org --trusted-host files.pythonhosted.org
RUN python3.7 -m pip install wheel

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install gcc g++ make
RUN apt-get update && apt-get install nodejs -y

RUN mkdir -p /usr/src

COPY . /usr/src
WORKDIR /usr/src/client
RUN npm install
RUN npm run build

WORKDIR /usr/src/server
RUN python3.7 -m pip install --upgrade pip --trusted-host pypi.org --trusted-host files.pythonhosted.org
RUN python3.7 -m pip install -r requirements.txt --trusted-host pypi.org --trusted-host files.pythonhosted.org

WORKDIR /usr/src
EXPOSE 80
CMD ["python3.7", "server/main.py"]