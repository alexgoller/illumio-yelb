FROM ruby:3.1-slim
MAINTAINER massimo@it20.info

################## BEGIN INSTALLATION ######################

# Set the working directory to /app
WORKDIR /app

COPY *.rb ./
COPY Gemfile Gemfile.lock ./
COPY modules modules

ENV LANG=en_us.UTF-8
ENV LC_ALL=C.UTF-8
ENV RACK_ENV=production

RUN apt-get update && apt-get install -y \
    libpq-dev \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN gem install bundler --no-document
RUN bundle install
RUN gem install sinatra --no-document
### this installs the AWS SDK for DynamoDB (so that appserver can talk to DDB Vs the default Postgres/Redis)
RUN gem install aws-sdk-dynamodb --no-document
# Set the working directory to /
WORKDIR /
ADD startup.sh startup.sh

# Lambda adapter
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.5.1 /lambda-adapter /lambda-adapter

# Setup Lambda RIE + RIC
RUN curl -L -o /usr/bin/lambda_rie https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/download/v1.9/aws-lambda-rie-x86_64 && \
    chmod +x /usr/bin/lambda_rie
RUN gem install aws_lambda_ric

##################### INSTALLATION END #####################

CMD ["./startup.sh"]


