FROM rope
EXPOSE 8000
COPY ./ /titan/
WORKDIR /titan
RUN swift build -c release
CMD [".build/release/ToDo-Titan"]

