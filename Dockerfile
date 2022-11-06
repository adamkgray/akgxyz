
FROM dpokidov/imagemagick AS img-compression
WORKDIR /build
COPY images/*.jpg images/
WORKDIR /build/images
RUN for IMG in $(ls); do \
    convert \
    "$IMG" \
    -resize \
    -350x350 \
    "$IMG"; \
    done;

FROM python:3.11 as build
WORKDIR /build
COPY --from=img-compression /build/images /build/book/images
COPY . .
RUN pip install -r book/requirements.txt
RUN jb clean book
RUN jb build book

FROM nginx:1.23.2
COPY --from=build /build/book/_build/html /usr/share/nginx/html

