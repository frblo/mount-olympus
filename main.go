package main

import (
	"bufio"
	_ "embed"
	"html/template"
	"os"

	"gopkg.in/yaml.v3"
)

type page struct {
	Links []link
	Css   template.CSS
}

type link struct {
	Name        string
	Description string
	URL         string
	Color       string
	Icon        string
	IconStyle   template.CSS
}

//go:embed static/index.css
var cssFile string

//go:embed links.yml
var linksData []byte

//go:embed template.html
var indexFile string

func getPage() page {
	var p page
	err := yaml.Unmarshal(linksData, &p)
	if err != nil {
		panic(err)
	}

	p.Css = template.CSS(cssFile)

	return p
}

func main() {
	page := getPage()

	indexTemplate, err := template.New("index.html").Parse(indexFile)
	if err != nil {
		panic(err)
	}

	f, err := os.Create("index.html")
	if err != nil {
		panic(err)
	}
	defer f.Close()

	w := bufio.NewWriter(f)
	if err := indexTemplate.Execute(w, page); err != nil {
		panic(err)
	}
}
