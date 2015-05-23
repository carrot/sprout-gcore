Promise = require 'bluebird'
path = require 'path'
exec = Promise.promisify(require('child_process').exec)
fs = require 'fs'
S = require("underscore.string");
mkdirp = require('mkdirp');

exports.configure = [
  {
    name: 'user_id'
    message: 'What is your Github id?'
    default: 'carrot'
  },
  {
    name: 'project_name'
    message: 'What is the name of your project?'
    default: 'gcore-api'
  },
  {
    name: 'project_base_dir'
    message: 'Use github.com as base directory?'
    default: 'github.com'
  }
]

exports.before = (utils) ->
  _check_go_installed()

exports.beforeRender = (utils, config) ->
  package_name = path.join(config.project_base_dir, config.user_id, config.project_name)
  config.package_path = package_name

  _get_go_path()
    .then( (go_path) =>
      #Check if the target path already exists
      config.go_path = go_path
      target_path = path.join(config.go_path, 'src', config.package_path)
      exists = fs.existsSync(target_path)
      console.log target_path + '::exists=' + exists
      if fs.existsSync(target_path) is on
        throw 'target path already exists: ' + target_path
    )

exports.after = (utils, config) ->
  _rename_pkg_dir(utils, config)

#private functions
_rename_pkg_dir = (utils, config) ->
  target_path = path.join(config.go_path, 'src', config.package_path)
  mkdirp target_path, (err) ->
    if err
      console.error err
    else
      fs.rename(utils._target, target_path)
      console.log 'The Go template has been initialized at ' + target_path

_check_go_installed = () ->
  exec('go version')
    .catch (e) ->
      throw new Error('go is either not installed or not added to PATH environment variable.')

_get_go_path = () ->
  exec('echo $GOPATH')
  .then( (streams) =>
    stdout_stream = streams[0]
    stderr_stream = streams[1]
    go_path = S.trim(stdout_stream)

    #check if there a GOPATH value set
    if go_path.length <= 0
      throw "Go path is either not set or empty"
    return go_path
  )