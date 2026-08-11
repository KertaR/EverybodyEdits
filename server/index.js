/**
 * Main Entry Point for Everybody Edits Private Server
 */

const Server = require('./src/Server');
const config = require('./config.json');

const server = new Server(config);
server.start();
