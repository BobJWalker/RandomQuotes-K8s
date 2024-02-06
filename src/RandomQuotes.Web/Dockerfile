#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
EXPOSE 8080

FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG TARGETARCH
ARG APP_VERSION="0.0.1"
WORKDIR /src
COPY ["RandomQuotes.Web/RandomQuotes.Web.csproj", "RandomQuotes.Web/"]
RUN dotnet restore "RandomQuotes.Web/RandomQuotes.Web.csproj" -a $TARGETARCH
COPY . .
WORKDIR "/src/RandomQuotes.Web"
RUN dotnet build "RandomQuotes.Web.csproj" -c Release -o /app/build /p:Version=$APP_VERSION -a $TARGETARCH

FROM build AS publish
RUN dotnet publish "RandomQuotes.Web.csproj" -c Release -o /app/publish /p:UseAppHost=false /p:Version=$APP_VERSION -a $TARGETARCH

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "RandomQuotes.Web.dll"]
ENV RANDOM_SECRET_PHRASE=blah
ENV ASPNETCORE_URLS="http://+:8080"
ENV ASPNETCORE_ENVIRONMENT="Production"