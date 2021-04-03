FROM ruby:2.7.1-alpine

ARG RAILS_ENV

WORKDIR /tmp
RUN apk --update --no-cache add libxml2-dev libxslt-dev libstdc++ tzdata ca-certificates bash npm yarn \
    shadow sudo busybox-suid tzdata alpine-sdk libxml2-dev curl-dev postgresql-dev file file-dev vim

WORKDIR /usr/src/app
ADD Gemfile Gemfile.lock ./
RUN bundle update && \
    bundle install

ADD ./ /usr/src/app

RUN bundle exec rails assets:precompile RAILS_ENV=${RAILS_ENV}

EXPOSE 3000
CMD bundle exec rails s -p 3000 -b 0.0.0.0