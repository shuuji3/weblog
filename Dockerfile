FROM peaceiris/hugo AS builder
COPY . .
RUN git submodule update --recursive
RUN hugo --minify --buildFuture

FROM nginx:alpine
COPY --from=builder /src/public/ /usr/share/nginx/html/
