# docker run -it -p 15151:15151 -v /var/snap/lxd/common/lxd/unix.socket:/var/snap/lxd/common/lxd/unix.socket phenonymous/lxdui

FROM jfloff/alpine-python:3.6 as BUILDER

RUN mkdir install
WORKDIR /install

RUN apk --update add git libffi-dev openssl-dev
RUN git clone https://github.com/AdaptiveScale/lxdui.git /app
RUN pip install --install-option="--prefix=/install" -r /app/requirements.txt

FROM jfloff/alpine-python:3.6-slim
RUN /entrypoint.sh \
 -a openssl \
&& echo

COPY --from=BUILDER /install /usr
COPY --from=BUILDER /app/run.py /app/run.py
COPY --from=BUILDER /app/app /app/app
COPY --from=BUILDER /app/conf /app/conf
COPY --from=BUILDER /app/logs /app/logs

WORKDIR /app

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
EXPOSE 15151

ENTRYPOINT ["python", "run.py", "start"]
