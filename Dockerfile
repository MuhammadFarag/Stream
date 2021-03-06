FROM ruby:2.3
# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install


COPY . /usr/src/app/


CMD ["bundle", "exec", "rspec", "./task_stream_spec.rb"]
