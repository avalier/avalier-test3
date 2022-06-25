## BUILD ##
FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY entrypoint.sh .
COPY Avalier.Test3/*.csproj ./Avalier.Test3/
RUN dotnet restore

# copy everything else and build app
COPY Avalier.Test3/ ./Avalier.Test3/
WORKDIR /app/Avalier.Test3
RUN dotnet publish -c Release -o out -r linux-musl-x64 --self-contained /p:PublishSingleFile=true /p:PublishTrimmed=true

## RUNTIME ##
FROM mcr.microsoft.com/dotnet/runtime-deps:6.0-alpine AS runtime
WORKDIR /app
ENV HOME=/app
ENV ASPNETCORE_URLS="http://*:5000;https://*:5001"

ENV DOMAIN=localhost
# ENV AzureAd__Instance=https://login.microsoftonline.com/
# ENV AzureAd__CallbackPath=/signin-oidc
# ENV AzureAd__Domain=$DOMAIN:5001
# ENV AzureAd__TenantId=
# ENV AzureAd__ClientId=

ENV Kestrel__Endpoints__HttpsFromPem__Url=https://*:5001
ENV Kestrel__Endpoints__HttpsFromPem__Certificate__Path=/app/https/cert.pem
ENV Kestrel__Endpoints__HttpsFromPem__Certificate__KeyPath=/app/https/key.pem

RUN apk add curl openssl \
    && addgroup -S app && adduser -S -G app --home "/app" --no-create-home --disabled-password  app \
    && mkdir -p /app/https && chown app:app /app/https && chmod 755 /app/https
COPY --from=build --chown=app:app /app/Avalier.Test3/out /app/bin
COPY --from=build --chown=app:app /app/entrypoint.sh /app/
RUN chmod 755 /app/entrypoint.sh

USER app
EXPOSE 5000
EXPOSE 5001
ENTRYPOINT /app/entrypoint.sh
# ENTRYPOINT /app/Avalier.Test3.Host
# ENTRYPOINT \
#     echo "TenantId: $AzureAd__TenantId" \
#     && echo "ClientId: $AzureAd__ClientId" \
#     && ./setup-certificate.sh $DOMAIN \
#     && cd /app/bin && ./Avalier.Test3.Host



