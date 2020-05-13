FROM fnproject/node

RUN apk add --no-cache unzip
WORKDIR /function
COPY *.zip .
RUN unzip -oq fi-8-5-4-linux-x86-64.zip -d oit-fi

WORKDIR /function/oit-fi
RUN sh makedemo.sh


WORKDIR /function
ADD . /function/
RUN npm install
ENTRYPOINT ["node", "func.js"]
