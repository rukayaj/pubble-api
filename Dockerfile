FROM ruby:2.5.1-alpine3.7

# Alpine uses apk to install apps
RUN apk add --update build-base postgresql-dev tzdata

# This creates an app directory in the docker container and sets the working directory
RUN mkdir -p /app 
WORKDIR /app

# Copies the Gemfile & lock file and then runs gem install bundler. It's separate step so that the RUN command can be cached by Docker
# See https://medium.com/magnetis-backstage/how-to-cache-bundle-install-with-docker-7bed453a5800 for more info
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5

# Copy the rest of the application over
COPY . ./

# This command will be prepended to all of the commands we run subsequently 
ENTRYPOINT ["bundle", "exec"]

# The main command which runs when the container starts
CMD ["rails", "server", "-b", "0.0.0.0"]
