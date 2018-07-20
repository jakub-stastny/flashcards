FROM ruby:2.6-rc

ENV LANG C.UTF-8

# RUN bundle config --global frozen 1
WORKDIR /app

# RUN apk --update add --virtual build-dependencies ruby-dev build-base && \
#     gem install bundler --no-ri --no-rdoc && \
#     cd /app ; bundle install --without development test && \
#     apk del build-dependencies
COPY flashcards.gemspec Gemfile Gemfile.lock ./
RUN bundle install --deployment --jobs=3

COPY . .

ENTRYPOINT ["bundle", "exec", "bin/flashcards"]
CMD ["es"]
