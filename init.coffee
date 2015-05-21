exports.configure = [
  {
    name: 'name'
    message: 'What is the name of your project?'
  }
]

exports.before = (utils, config) ->
  # check that the go runtime is installed
  exec('go version')
    .catch(e) ->
      throw new Error('go is either not installed or not added to PATH environment variable.')

exports.beforeRender = (utils, config) ->
  # before_render hook

exports.after = (utils, config) ->
  # after hook
