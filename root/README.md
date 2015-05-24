#<%= name %>

<%= name %> is a super minimalist scaffolding for writing a REST API in Go.

## Why should you care?

If you're not entirely sold on an entire Go framework, you're probably the type of person that wants to pick and choose your own middleware depending on what your project calls for.  This scaffolding is as unopinionated as it can be in terms of middleware.

This is a starting point for those who don't want to write scaffolding over and over again, but also want the full flexibility of picking their own middleware.

## User model/controller

You'll note that included is a user model + controller.  This is simply to express a model / controller pattern that I have found works very well.

## Getting started

### Setting up

Before you start, make sure you have [gom](https://github.com/mattn/gom) installed.

You will also need to set an environment variable named `PORT` to the port you would like <%= name %> to run on.

After that, run these commands:

```sh
go get <%= package_path %>
cd "$GOPATH/src/<%= package_path %>/"
gom install
gom build
```

Now <%= name %> should be ready to run, so just run:

```sh
./<%= name %>
```

Head over to `http://localhost:$PORT/users/1` in a browser.  If you get a 200 response, you're all set up.

## License

[MIT](license.txt)
