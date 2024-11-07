ARG CLEAR="&& apt-get clean -y && apt-get autoremove -y"
ARG SSL_DIR_PATH="/etc/nginx/ssl"

FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y	\
	&& apt-get install nginx openssl -y		\
	${CLEAR}

## CREATE A DEFAULT SSL DIRECTORY TO STORE ALL THE FILES
RUN mkdir -p ${SSL_DIR_PATH}

RUN openssl req -x509 -new -newkey rsa:4096 -nodes	\
				-keyout ${SSL_DIR_PATH}/cert.key	\
				-out ${SSL_DIR_PATH}/cert.crt		\
				-sha256 -days 365					\
				-subj "/C=MA/ST=KH/L=KH/O=SELF/OU=IT/CN=${DOMAIN_NAME}"

## --DETAILS-- 
# openssl	req='Request' -x509='Directly creates a self-signed certificate' \
#			-sha256='Hashing Algorithm' \
#			-nodes="The private key is stored in unencrypted plaintext in the file." \
#			-new="Creates a new certificate and key"
#			-'newkey rsa:2048'="Generates a 2048-bit RSA private key along with the certificate"
#			-keyout="Specifies the output file for the private key"
#			-out="Specifies the output file for the self-signed certificate"
#			-days="Sets the certificate to be valid for 365 days"
#			-subj="Specifies the certificate details for non-interactive"

COPY tools/nginx.conf /etc/nginx/nginx.conf

## RUN THE NGINX IN THE FORGROUND
ENTRYPOINT ["nginx", "-g", "'deamon off;'"]