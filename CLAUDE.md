# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Application Overview

Yelb is a 4-tier restaurant voting web application designed for experimenting with different deployment technologies and cloud abstractions. It consists of:

- **yelb-ui**: Angular 2 frontend with VMware Clarity UI framework
- **yelb-appserver**: Ruby/Sinatra REST API backend  
- **redis-server**: Redis cache for page view tracking
- **yelb-db**: PostgreSQL database for vote persistence

The application supports deployment across multiple compute abstractions from bare metal to serverless (Lambda + DynamoDB).

## Common Development Commands

### Local Development Setup
```bash
# Prerequisites: git, Docker, Ruby, Angular CLI
cd deployments/localdevelopment
chmod +x setupdevenv.sh
./setupdevenv.sh
# Access: http://localhost:4200
```

### Local Testing (Full Containerized)
```bash
# Using original images
cd deployments/localtest
docker-compose up
# Access: http://localhost:8080

# Using Illumio-branded images
cd deployments/localtest
docker-compose -f docker-compose-illumio.yml up
# Access: http://localhost:8080
```

### Docker Image Building

Images are automatically built and published via GitHub Actions:
- **Triggers**: Push to main/master, tags, pull requests
- **Registry**: GitHub Container Registry (ghcr.io)
- **Images**: `ghcr.io/alexgoller/illumio-yelb/yelb-ui`, `yelb-appserver`, `yelb-db`, `redis-server`
- **Tags**: `latest`, version tags (v1.0.0), branch names, commit SHAs

### Manual Container Commands
```bash
# Start backend services
docker network create yelb-network 
docker run --name redis-server -p 6379:6379 --network=yelb-network -d redis:4.0.2
docker run --name yelb-db -p 5432:5432 --network=yelb-network -d mreferre/yelb-db:0.6
docker run --name yelb-appserver --network=yelb-network -d -p 4567:4567 -e RACK_ENV=test mreferre/yelb-appserver:0.7
docker run --name yelb-ui --network=yelb-network -d -p 8080:80 -e UI_ENV=test mreferre/yelb-ui:0.10
```

### Frontend Development (yelb-ui)
```bash
cd yelb-ui/clarity-seed-newfiles
npm install
ng serve --port 4200 --environment=dev  # Development
ng serve --port 4200 --environment=test # Testing
ng build --environment=prod             # Production build
npm run lint                            # TypeScript linting
npm run test                            # Run tests
```

### Backend Development (yelb-appserver)
```bash
cd yelb-appserver
export RACK_ENV=development  # or test/production
gem install bundler
bundle install
ruby yelb-appserver.rb
```

## Architecture Details

### API Endpoints (yelb-appserver)
- `GET /api/hostname` - Returns serving instance hostname
- `GET /api/pageviews` - Retrieves page view count from Redis
- `GET /api/getstats` - Returns application statistics
- `GET /api/getvotes` - Retrieves voting results from PostgreSQL
- `POST /api/{restaurant}` - Vote endpoints (ihop, chipotle, outback, bucadibeppo)

### Environment Configuration
- **Development**: `RACK_ENV=development`, `ng serve --environment=dev`
- **Test**: `RACK_ENV=test`, `UI_ENV=test` 
- **Production**: `RACK_ENV=production`, `UI_ENV=prod`

### Backend Support
The application supports dual backend modes:
- **Traditional**: PostgreSQL + Redis (default)
- **Serverless**: DynamoDB (AWS Lambda deployments)

## Component Structure

### yelb-ui Component Files
- `src/app/app.component.ts` - Main application component
- `src/environments/` - Environment-specific configurations
- `clarity-seed-newfiles/` - Customized VMware Clarity seed files

### yelb-appserver Modules
- `modules/getstats.rb` - Statistics retrieval logic
- `modules/getvotes.rb` - Vote retrieval from database
- `modules/hostname.rb` - Instance hostname display
- `modules/pageviews.rb` - Page view tracking with Redis
- `modules/restaurant.rb` - Vote processing logic
- `modules/restaurantsdbread.rb` - Database read operations
- `modules/restaurantsdbupdate.rb` - Database write operations

## Deployment Options

The `/deployments/platformdeployment/` directory contains configurations for:
- **AWS**: EC2, ECS, Lambda, Step Functions (CloudFormation, Terraform, CDK)
- **Kubernetes**: YAML manifests, Helm charts, CDK8s
- **Docker**: Compose files and Swarm stacks
- **Linux**: Direct installation scripts

## Development Notes

- Local development runs yelb-ui and yelb-appserver as background processes
- Backend services (Redis, PostgreSQL) run in containers during development
- The application uses VMware Clarity seed as the Angular 2 base framework
- Service discovery uses localhost in development, DNS names in containerized deployments
- The frontend serves compiled JavaScript to browsers with dynamic chart visualization using ngx-charts