FROM ruby:2.7-alpine
RUN apk update \
    && apk add build-base libxslt-dev libxml2-dev tzdata git sqlite sqlite-dev postgresql-dev postgresql-client shared-mime-info vim
ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/
RUN gem install bundler
RUN bundle install
ADD . $APP_HOME