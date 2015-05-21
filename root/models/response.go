// This is the general response that will
// encompass all other responses
package models

import (
	"encoding/json"
	"fmt"
	"net/http"
)

type Response struct {
	Success    bool        `json:"success"`
	StatusCode int         `json:"status_code"`
	Message    string      `json:"message"`
	Content    interface{} `json:"content"`
}

func (response *Response) Init() *Response {
	response.StatusCode = 200
	return response
}

func (response *Response) Output(writer http.ResponseWriter) {
	if response.StatusCode != 200 {
		http.Error(writer, "", response.StatusCode)
	}
	fmt.Fprintln(writer, ToJSON(response))
}

func ToJSON(i interface{}) string {
	json, err := json.Marshal(i)
	if err != nil {
		return "Error converting response to JSON"
	}
	return string(json)
}
