Promise = require 'bluebird'
fs      = require 'fs'
exec    = Promise.promisify(require('child_process').exec)
path    = require 'path'
chalk   = require 'chalk'
mkdirp  = require 'mkdirp'

exports.configure = [
  {
    name: 'name'
    message: 'what is the name of your project?'
    default: 'gcore-api'
  },
  {
    name: 'username'
    message: 'what is your github username?'
    default: 'carrot'
  }
]

exports.before = (utils) ->
  _check_go_installed()

exports.beforeRender = (utils, config) ->
  pkg = path.join('github.com', config.username, config.name)
  config.package_path = pkg
  exec('echo $GOPATH').then (streams) ->
    config.dest = path.join(streams[0].trim(), pkg)

exports.after = (utils, config) ->
  mkdirp config.dest, (err) ->
    fs.rename(utils._target, config.dest)

# private
_check_go_installed = ->
  exec('go version').catch (err) ->
    str = "Please ensure GO is installed and in your PATH."
    warning = chalk.bgYellow('WARN: ') + chalk.yellow(str)
    console.log warning
