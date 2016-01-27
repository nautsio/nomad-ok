package main

import (
	"fmt"
	"net/http"
	"os"
)

func handleHello(w http.ResponseWriter, r *http.Request, message string) {
	fmt.Fprintf(w, "Hello %s", message)
}

func main() {
	message := os.Args[1]
  
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		handleHello(w, r, message)
	})

	http.ListenAndServe(":8080", nil)
}
