package main

import (
	"github.com/carrot/gcore/controllers"
	"github.com/julienschmidt/httprouter"
	"net/http"
	"os"
)

func buildRouter() *httprouter.Router {
	// Creating a router
	router := httprouter.New()

	// User Controller
	userController := new(controllers.UserController)
	router.GET("/users/:id", userController.ReadSingle)

	// Returning the router
	return router
}

func main() {
	// Setting up router + server
	router := buildRouter()
	http.ListenAndServe(":"+os.Getenv("PORT"), router)
}
