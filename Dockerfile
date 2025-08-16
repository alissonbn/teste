# 1. Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy project files and restore dependencies
COPY ["ecs.csproj", "./"]
RUN dotnet restore "./ecs.csproj"

# Copy all remaining source code and build/publish
COPY . .
RUN dotnet publish "./ecs.csproj" -c Release -o /app/publish

# 2. Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

# Optionally expose port if needed
EXPOSE 8080

# Launch the app
ENTRYPOINT ["dotnet", "ecs.dll"]
