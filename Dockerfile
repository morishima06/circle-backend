FROM ruby:3.2.3

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      libvips \
      postgresql-client && \
    rm -rf /var/lib/apt/lists/*
    
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 5001

CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "5001"]