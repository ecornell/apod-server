config = {}
config.redis = {}
config.web = {}

config.redis.host = 'localhost'
config.redis.port = 6379
config.web.port = process.env.WEB_PORT || 9999

module.exports = config