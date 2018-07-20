FROM ruby:2.6-rc

ENV LANG C.UTF-8

# RUN bundle config --global frozen 1

WORKDIR /app

# ADD flashcards.gemspec Gemfile bin lib ./
# ADD Gemfile.lock $DIR
# RUN apk --update add --virtual build-dependencies ruby-dev build-base && \
#     gem install bundler --no-ri --no-rdoc && \
#     cd /app ; bundle install --without development test && \
#     apk del build-dependencies
# RUN chown -R nobody:nogroup /app
# USER nobody
# ENV RACK_ENV production
# EXPOSE 9292
COPY flashcards.gemspec Gemfile Gemfile.lock ./
RUN bundle install
# RUN bundle install --deployment --jobs=3

COPY . .

CMD bundle exec bin/flashcards
