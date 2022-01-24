# Development Dockerfile

FROM ruby:3.1-alpine3.15

# TODO: Pass args
ARG USER_ID=1000
ARG GROUP_ID=1000

ARG USER=user
ARG GROUP=user
ARG APP_PATH=/knowledge

RUN apk add --update --no-cache tzdata bash less && \
  apk add --no-cache --virtual .base build-base && \
  apk add --no-cache postgresql14-client postgresql14-dev

RUN addgroup -g $GROUP_ID -S $GROUP && \
  adduser -s /sbin/nologin -u $USER_ID -G $GROUP $USER -S

ENV APP_PATH $APP_PATH

COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

RUN mkdir -p $APP_PATH/vendor/bundle && chown $USER:$GROUP -R $APP_PATH

VOLUME $APP_PATH/vendor

USER $USER

WORKDIR $APP_PATH

COPY --chown=$USER_ID:$GROUP_ID Gemfile Gemfile.lock $APP_PATH/

RUN bundle config path "vendor/bundle" && \
  bundle install --retry 3

COPY --chown=$USER:$GROUP . $APP_PATH/

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
