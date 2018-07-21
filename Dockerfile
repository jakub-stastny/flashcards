FROM ruby:2.6-rc-alpine

# Configuration.
ENV LANG C.UTF-8
RUN bundle config --global frozen 1
WORKDIR /app

# Installation.
COPY flashcards.gemspec Gemfile Gemfile.lock ./
RUN apk --update add --virtual build-dependencies ruby-dev build-base ncurses-dev && \
    bundle install --without development test --jobs=3 && \
    apk del build-dependencies ruby-dev build-base ncurses-dev
COPY . .

# The entry point.
ENTRYPOINT ["bundle", "exec", "bin/runner"]
CMD ["--help"]
