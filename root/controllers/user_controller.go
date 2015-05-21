package controllers

import (
	"github.com/carrot/gcore/models"
	"github.com/julienschmidt/httprouter"
	"net/http"
	"strconv"
)

type UserController struct{}

func (c *UserController) ReadSingle(writer http.ResponseWriter, request *http.Request, params httprouter.Params) {
	// Prepping response
	response := new(models.Response).Init()
	defer response.Output(writer)

	// Parsing out params
	id, err := strconv.ParseUint(params.ByName("id"), 0, 64)
	if err != nil {
		response.Success = false
		response.Message = "The id parameter must be a uint64"
		response.StatusCode = 403
		return
	}

	// Loading User
	user := new(models.User)
	user.Load(id)

	// Prepping success response
	response.Content = user
	response.Success = true
}
