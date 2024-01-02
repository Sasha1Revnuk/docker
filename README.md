#  Laravel  with Docker Compose

## Begin to develop
- Download zip docker and extract to work directory and rename for project name
- create /src
- git clone project to src folder
- change ports and containers names
- make env and configure .env file in src folder


### package.json
"scripts": {
"dev": "vite --host --port 8090",
"build": "vite build"
},

### vite.config.js
server: {
hmr: {
host: '127.0.0.1',
},
},

- configure make file 
- make init
- do not forget about git stash on Linux

