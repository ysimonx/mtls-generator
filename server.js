// Require the framework and instantiate it
const fs = require('fs');

const fastify = require('fastify')({ logger: true,

  https: {
    requestCert: true,
    rejectUnauthorized: true,
    key: fs.readFileSync("./certificates/server/serverKey.pem"),
    cert: fs.readFileSync("./certificates/server/serverCrt.pem") ,
    ca: [fs.readFileSync("./certificates/ca/caCrt.pem")]
   
  }


 })

// Declare a route
fastify.get('/', async (request, reply) => {
  return { hello: 'world' }
})

// Run the server!
const start = async () => {
  try {
    await fastify.listen({ port: 3000, host:'0.0.0.0' })
  } catch (err) {
    fastify.log.error(err)
    process.exit(1)
  }
}
start()
