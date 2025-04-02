FROM mcr.microsoft.com/dotnet/sdk:7.0-alpine AS builder
WORKDIR /youtube-live-app
COPY . .
ENV ASPNETCORE_ENVIRONMENT Development
ENV URLS http://0.0.0.0:80
RUN dotnet publish -c Release -o build /youtube-live-app/YoutubeLiveApp.csproj

FROM mcr.microsoft.com/dotnet/aspnet:7.0-alpine AS runner
WORKDIR /youtube-live-app
COPY --from=builder /youtube-live-app/build /youtube-live-app/
EXPOSE 80
ENTRYPOINT ["dotnet", "/youtube-live-app/YoutubeLiveApp.dll"] 