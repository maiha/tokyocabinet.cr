FROM crystallang/crystal:0.27.0

RUN apt-get update -qq && apt-get install -y --no-install-recommends curl file libtokyocabinet-dev tokyocabinet-bin

CMD ["crystal", "--version"]
