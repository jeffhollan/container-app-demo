package main

import (
	"os"

	dapr "github.com/dapr/go-sdk/client"
)

func main() {
	a := App{}

	client, err := dapr.NewClient()
	if err != nil {
		panic(err)
	}
	a.Initialize(
		client,
		os.Getenv("PYTHON_APP_FQDN"),
	)

	a.Run(":8050")
	defer client.Close()
}
