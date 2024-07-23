FROM python:3.7-alpine

ENTRYPOINT [ "/entrypoint" ]

RUN adduser -D -u 54000 radio && \
	apk add git gcc g++ musl-dev make && \
        pip install --upgrade pip && \
        pip cache purge && \
	pip install puresnmp==1.10.2 && \
        pip install importlib-metadata && \
	pip install hytera-homebrew-bridge && \
	cd /opt	 && \
	git clone https://github.com/g4klx/DMRGateway.git && \
	cd DMRGateway && \
	git reset --hard 6e89e4922f8c5eb7ec3797729a82137d70bc8940 && \
	make && \
	apk del git gcc musl-dev make && \
	chown 54000 /opt/* -R && \
	chmod 777 /opt/ -R 

COPY entrypoint /entrypoint
COPY config /opt/
RUN chmod 777 /opt/ -R

USER radio
