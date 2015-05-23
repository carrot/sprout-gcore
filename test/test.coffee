rimraf = require 'rimraf'
path   = require 'path'
fs     = require 'fs'
Promise = require 'bluebird'
exec = Promise.promisify(require('child_process').exec)
S = require("underscore.string");
locals = require './fixtures/locals'

test_template_path = path.resolve(_path, '../../')
test_path          = path.join(__dirname, 'tmp')
tpl = 'test-sprout-gcore'
opts =
  config: path.join(_path, 'locals.json')
go_path = ''

before ->
  console.log 'before'
  sprout.add(tpl, test_template_path)
    .then -> rimraf.sync(test_path)
    .then -> sprout.init(tpl, test_path, opts)

after ->
  console.log 'after'
  sprout.remove(tpl)

describe 'init', ->
  console.log 'init-start'
  it 'checks if go runtime is installed', (done) ->
    exec('go version')
      .then( done() )
      .catch (e) ->
        done()
        throw new Error('go is either not installed or not added to PATH environment variable.')

  exec('echo $GOPATH')
    .then( (streams) =>
      stdout_stream = streams[0]
      go_path = S.trim(stdout_stream)
      console.log 'go_path=' + go_path
      #check if there a GOPATH value set 
      if go_path.length <= 0
        throw "Go path is either not set or empty"

      new_test_path = path.join(go_path, 'src', locals.project_base_dir, locals.user_id, locals.project_name)
      console.log 'new_test_path=' + new_test_path
      it 'creates new project from template', (done) ->
        tgt = path.join(new_test_path, 'README.md')
        exists = fs.existsSync(tgt)
        console.log 'create new proj - exists=' + exists
        console.log 'tgt=' + tgt
        fs.existsSync(tgt).should.be.ok
        contents = fs.readFileSync(tgt, 'utf8')
        contents.should.match /#gcore-api/
        done()

      it 'matches model in user_controller.go', (done) ->
        tgt = path.join(new_test_path, 'controllers', 'user_controller.go')
        fs.existsSync(tgt).should.be.ok
        contents = fs.readFileSync(tgt, 'utf8')
        contents.should.match /.*"github.com\/roideuniverse\/gcore-api\/models".*/
        done()

      #mathces package path in main.go
      it 'matched package path in main.go', (done) ->
        tgt = path.join(new_test_path, 'main.go')
        fs.existsSync(tgt).should.be.ok
        contents = fs.readFileSync(tgt, 'utf8')
        counts = contents.should.match /.*"github.com\/roideuniverse\/gcore-api\/controllers".*/
        done()

      #matched package_path in readme
      it 'matched package path in the readme', (done) ->
        tgt = path.join(new_test_path, 'README.md')
        fs.existsSync(tgt).should.be.ok
        contents = fs.readFileSync(tgt, 'utf8')
        counts = contents.should.match /go\sget\sgithub.com\/roideuniverse\/gcore-api/
        done()


      #matched project_name in readme
      it 'matched project_name in the readme', (done) ->
        tgt = path.join(new_test_path, 'README.md')
        fs.existsSync(tgt).should.be.ok
        contents = fs.readFileSync(tgt, 'utf8')
        counts = contents.should.match /gcore-api/
        done()
    )