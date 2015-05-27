rimraf = require 'rimraf'
path   = require 'path'
fs     = require 'fs'
Promise = require 'bluebird'
exec = Promise.promisify(require('child_process').exec)
locals = require './fixtures/locals'

test_template_path = path.resolve(_path, '../../')
test_path          = path.join(__dirname, 'tmp')
tpl = 'test-sprout-gcore'
opts =
  config: path.join(_path, 'locals.json')
go_path = ''
temp_test_path =''

before ->
  sprout.add(tpl, test_template_path)
    .then -> rimraf.sync(test_path)
    .then -> sprout.init(tpl, test_path, opts)
    .then ->
      exec('echo $GOPATH')
        .then (streams) ->
          go_path = streams[0].trim()
          if go_path.length > 0
            temp_test_path = path.join(go_path, 'src', locals.project_base_dir, locals.user_id, locals.project_name)
            Promise.resolve()
          else
            Promise.reject();

after ->
  sprout.remove(tpl)
  rimraf.sync temp_test_path

describe 'init', ->
  it 'creates new project from template', (done) ->
    tgt = path.join(temp_test_path, 'README.md')
    exists = fs.existsSync(tgt)
    fs.existsSync(tgt).should.be.ok
    contents = fs.readFileSync(tgt, 'utf8')
    contents.should.match /#gcore-api/
    contents.should.match /go\sget\sgithub.com\/roideuniverse\/gcore-api/
    done()

  it 'matches model in user_controller.go', (done) ->
    tgt = path.join(temp_test_path, 'controllers', 'user_controller.go')
    fs.existsSync(tgt).should.be.ok
    contents = fs.readFileSync(tgt, 'utf8')
    contents.should.match /.*"github.com\/roideuniverse\/gcore-api\/models".*/
    done()

  #mathces package path in main.go
  it 'matched package path in main.go', (done) ->
    tgt = path.join(temp_test_path, 'main.go')
    fs.existsSync(tgt).should.be.ok
    contents = fs.readFileSync(tgt, 'utf8')
    counts = contents.should.match /.*"github.com\/roideuniverse\/gcore-api\/controllers".*/
    done()
