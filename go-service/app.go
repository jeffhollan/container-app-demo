package main

import (
	"context"
	"log"
	"net/http"

	dapr "github.com/dapr/go-sdk/client"
	"github.com/gorilla/mux"
)

type App struct {
	Router     *mux.Router
	daprClient dapr.Client
	pythonFqdn string
}

func (a *App) Initialize(client dapr.Client, pythonFqdn string) {
	a.daprClient = client
	a.pythonFqdn = pythonFqdn
	a.Router = mux.NewRouter()

	a.Router.HandleFunc("/", a.Hello).Methods("GET")
	a.Router.HandleFunc("/inventory", a.GetInventory).Methods("GET")
	a.Router.HandleFunc("/ping", a.Ping).Methods("GET")
}

func (a *App) Hello(w http.ResponseWriter, r *http.Request) {
	// Dapr version
	ctx := context.Background()
	resp, err := a.daprClient.InvokeMethod(ctx, "python-app", "hello", "get")
	// resp, err := http.Get(fmt.Sprintf("http://%s/hello", a.pythonFqdn))
	// if err != nil {
	// 	log.Println(err)
	// 	http.Error(w, err.Error(), http.StatusInternalServerError)
	// }
	// body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Println(err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
	w.Write(resp)
}

func (a *App) GetInventory(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Inventory in stock"))
}

func (a *App) Ping(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("< roger roger >"))
}

func (a *App) Run(addr string) {
	log.Fatal(http.ListenAndServe(addr, a.Router))
}
