# FROM fnproject/node

# RUN apk add --no-cache unzip
# WORKDIR /function
# COPY *.zip .
# RUN unzip -oq fi-8-5-4-linux-x86-64.zip -d oit-fi

# WORKDIR /function/oit-fi
# RUN sh makedemo.sh


# WORKDIR /function
# ADD . /function/
# RUN 
# ENTRYPOINT ["node", "func.js"]


FROM fnproject/python:3.6-dev as build-stage
WORKDIR /function
ADD requirements.txt /function/

			RUN pip3 install --target /python/  --no-cache --no-cache-dir -r requirements.txt &&\
			 rm -fr ~/.cache/pip /tmp* requirements.txt func.yaml Dockerfile .venv
ADD . /function/
RUN rm -fr /function/.pip_cache
FROM fnproject/python:3.6
RUN apt install unzip

WORKDIR /function
COPY *.zip .
RUN unzip -oq fi-8-5-4-linux-x86-64.zip -d oit-fi
WORKDIR /function/oit-fi
RUN /bin/sh makedemo.sh

WORKDIR /function
COPY --from=build-stage /python /python
COPY --from=build-stage /function /function
RUN chmod -R o+r /python /function
ENV PYTHONPATH=/function:/python
ENTRYPOINT ["/python/bin/fdk", "/function/func.py", "handler"]