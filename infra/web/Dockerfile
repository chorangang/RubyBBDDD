FROM ruby:3.2.2

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000

CMD bundle exec puma -C config/puma.rb