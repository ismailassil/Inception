FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y	\
	&& apt-get install nginx openssl vim netcat -y		\
	&& apt-get clean -y && apt-get autoremove -y

## CREATE A DEFAULT SSL DIRECTORY TO STORE ALL THE FILES
RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -new -newkey rsa:4096 -nodes	\
				-keyout /etc/nginx/ssl/cert.key	\
				-out /etc/nginx/ssl/cert.crt		\
				-sha256 -days 365					\
				-subj "/C=MA/ST=KH/L=KH/O=SELF/OU=IT/CN=iassil.42.f"

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
ENTRYPOINT ["nginx", "-g", "daemon off;"]