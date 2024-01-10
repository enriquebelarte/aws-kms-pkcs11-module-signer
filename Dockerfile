FROM archlinux:latest as build
MAINTAINER Enrique Belarte Luque <ebelarte@redhat.com>
# Update the repositories
RUN pacman -Syy
# Install AWS SDK C++ and other needed packages
RUN pacman -Sy --noconfirm aws-sdk-cpp git base-devel aws-sdk-cpp libp11 && \
    find /var/cache/pacman/ -type f -delete
# Clone PKCS11 implementation to use AWS KMS as backend
RUN git clone https://github.com/JackOfMostTrades/aws-kms-pkcs11.git && \
    cd aws-kms-pkcs11 && \
    make install

FROM archlinux:latest
# Set enviroment variables for AWS auth
ENV AWS_ACCESS_KEY_ID=your_access_key_id
ENV AWS_SECRET_ACCESS_KEY=your_secret_access_key
ENV AWS_DEFAULT_REGION=eu-west-3
ENV AWS_KMS_TOKEN=xxxxxxx-xxxx-xxxxxx-xxxxx
# Copy the library from previous build step
COPY --from=build /usr/lib/pkcs11/aws_kms_pkcs11.so /usr/lib/pkcs11/aws_kms_pkcs11.so
# Copy configuration files for aws-kms-pkcs11 library
COPY config.json x509.genkey openssl-pkcs11.conf /etc/aws-kms-pkcs11/
# Copy aws-sdk needed libraries
COPY --from=build /usr/lib/libaws* /usr/lib/libs2n.so /usr/lib/
# Copy shell script to update config
COPY configure_pkcs.sh /bin/
# Update the repositories
RUN pacman -Syy
# Install linux-headers to get sign-file script, AWS client and pkcs11 lib
RUN pacman -Sy --noconfirm linux-headers aws-cli libp11 && \
    find /var/cache/pacman/ -type f -delete
