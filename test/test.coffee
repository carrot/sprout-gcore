Promise = require 'bluebird'
rimraf = require 'rimraf'
path   = require 'path'
fs      = require 'fs'
exec    = Promise.promisify(require('child_process').exec)

test_template_path = path.resolve(_path, '../../')
test_path          = path.join(__dirname, 'tmp')
tpl = 'test-sprout-gcore'
opts =
  config: path.join(_path, 'locals.json')

before ->
  sprout.add(tpl, test_template_path)
    .then -> rimraf.sync(test_path)
    .then -> sprout.init(tpl, test_path, opts)

after ->
  sprout.remove(tpl)

describe 'init', ->

  it 'creates new project from template', (done) ->
    tgt = path.join(test_path, 'README.md')
    exists = fs.existsSync(tgt)
    fs.existsSync(tgt).should.be.ok
    contents = fs.readFileSync(tgt, 'utf8')
    contents.should.match /#gcore-api/
    done()

  # it 'matches model in user_controller.go', (done) ->
  #   tgt = path.join(new_test_path, 'controllers', 'user_controller.go')
  #   fs.existsSync(tgt).should.be.ok
  #   contents = fs.readFileSync(tgt, 'utf8')
  #   contents.should.match /.*"github.com\/roideuniverse\/gcore-api\/models".*/
  #   done()
  #
  # #mathces package path in main.go
  # it 'matched package path in main.go', (done) ->
  #   tgt = path.join(new_test_path, 'main.go')
  #   fs.existsSync(tgt).should.be.ok
  #   contents = fs.readFileSync(tgt, 'utf8')
  #   counts = contents.should.match /.*"github.com\/roideuniverse\/gcore-api\/controllers".*/
  #   done()
  #
  # #matched package_path in readme
  # it 'matched package path in the readme', (done) ->
  #   tgt = path.join(new_test_path, 'README.md')
  #   fs.existsSync(tgt).should.be.ok
  #   contents = fs.readFileSync(tgt, 'utf8')
  #   counts = contents.should.match /go\sget\sgithub.com\/roideuniverse\/gcore-api/
  #   done()
  #
  #
  # #matched project_name in readme
  # it 'matched project_name in the readme', (done) ->
  #   tgt = path.join(new_test_path, 'README.md')
  #   fs.existsSync(tgt).should.be.ok
  #   contents = fs.readFileSync(tgt, 'utf8')
  #   counts = contents.should.match /gcore-api/
  #   done()
