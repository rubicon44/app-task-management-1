FROM ruby:2.7.7

RUN apt-get update && \
    apt-get install -y build-essential \
                       libmariadb-dev-compat

RUN mkdir /app-task-management-1
ENV APP_ROOT /app-task-management-1
WORKDIR $APP_ROOT

ADD Gemfile $APP_ROOT/
ADD Gemfile.lock $APP_ROOT/
RUN bundle install

COPY . $APP_ROOT

RUN mkdir -p tmp/sockets tmp/pids
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["sh", "entrypoint.sh"]