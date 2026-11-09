# Usa a imagem oficial do Dart para o build
FROM dart:stable AS build

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia os ficheiros de dependências
COPY pubspec.yaml pubspec.lock ./
RUN dart pub get

# Copia todo o código fonte do projeto
COPY . .

# Compila o projeto em modo otimizado (release)
RUN dart compile exe bin/server.dart -o bin/server

# Cria a imagem final leve para produção
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/server

# Expõe a porta padrão que o Render vai utilizar
EXPOSE 8080

# Comando para iniciar a API
ENTRYPOINT ["/app/bin/server"]