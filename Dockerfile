FROM ruby:2.6.2
RUN apt-get update -qq && apt-get install -y build-essential
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN gem install bundler
RUN bundle install
EXPOSE 8080
COPY . /myapp