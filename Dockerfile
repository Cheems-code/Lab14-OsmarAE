# ---- Etapa 1: Build (Construcción) ----
# Usamos la imagen del SDK de .NET 9 para compilar la aplicación
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

COPY ["Lab14-OsmarAE/Lab14-OsmarAE.csproj", "Lab14-OsmarAE/"]
RUN dotnet restore "Lab14-OsmarAE/Lab14-OsmarAE.csproj"

# Copia el resto del código fuente
COPY . .
WORKDIR "/src/Lab14-OsmarAE"

RUN dotnet publish "Lab14-OsmarAE.csproj" -c Release -o /app/publish

# ---- Etapa 2: Final (Ejecución) ----
# Usamos la imagen de runtime de ASP.NET, que es mucho más ligera que la del SDK
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app

# Copia SOLAMENTE los archivos publicados de la etapa de build
COPY --from=build /app/publish .

# El comando para iniciar la aplicación cuando el contenedor se ejecute
ENTRYPOINT ["dotnet", "Lab14-OsmarAE.dll"]