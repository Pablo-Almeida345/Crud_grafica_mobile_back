# Usa a imagem oficial do Dart
FROM dart:stable AS build

WORKDIR /app

# Instala o CLI do Dart Frog globalmente
RUN dart pub global activate dart_frog_cli

# Copia os arquivos de dependência
COPY pubspec.yaml ./
RUN dart pub get

# Copia todo o código fonte do projeto
COPY . .

# Executa o build de produção do Dart Frog
RUN dart pub global run dart_frog_cli:dart_frog build

# Compila o binário gerado pelo Dart Frog a partir do diretório correto de build
RUN mkdir -p bin && dart compile exe build/bin/server.dart -o bin/server

# Imagem final de produção
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/server
COPY --from=build /app/public /app/public

EXPOSE 8080

ENTRYPOINT ["/app/bin/server"]