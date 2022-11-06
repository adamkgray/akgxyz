FROM python:3.11 as build
WORKDIR /build
COPY . .
RUN pip install -r book/requirements.txt
RUN jb clean book
RUN jb build

FROM nginx:1.23.2
COPY --from=build /build/book/_build/html /usr/share/nginx/

