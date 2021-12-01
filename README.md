[![CI](https://github.com/tstaetter/event-bin-microservice/actions/workflows/spec.yml/badge.svg?branch=main)](https://github.com/tstaetter/event-bin-microservice/actions/workflows/spec.yml)

# EventSourced

Micro service receiving and validating events

## Results

| Code   |      Description
|----------|:-------------
| 202 | Event successfully queued
| 400 | No schema found or tenant invalid
| 422 | Request payload couldn't be validated successfully
| 500 | Unknown error occurred

## Schema stores

Currently, only FileStore is supported (RedisStore to be implemented next)

### Configuration

```bash
# sample .env
SCHEMAS_PATH=<your-path-to-schemas>
```

## Run service

```
bundle exec falcon --port 3000 # port defaults to 9292
```
