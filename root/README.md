#<%= project_name %>

## Getting started

Before you start, make sure you have [gom](https://github.com/mattn/gom) installed.

You will also need to set an environment variable named `PORT` to the port you would like <%= project_name %> to run on.

After that, run these commands:

```sh
cd "$GOPATH/src/<%= package_path %>/"
gom install
gom build
```

Now <%= project_name %> should be ready to run, so just run:

```sh
./<%= project_name %>
```

or if you have not set the PORT environment variable yet:

```
PORT=8001 ./<%= project_name %>
```

Head over to `http://localhost:$PORT/users/1` in a browser.  If you get a 200 response, you're all set up.

## License

[MIT](license.txt)
