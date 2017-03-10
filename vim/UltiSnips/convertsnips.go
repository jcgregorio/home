package main

import "io/ioutil"
import "strings"
import "go.skia.org/infra/go/sklog"
import "encoding/json"
import "os"

/*
"name": {
		"prefix": "log",
		"body": [
			"console.log('$1');",
			"$2"
		],
		"description": "Log output to console"
	}

*/

type Snip struct {
	Prefix      string
	Body        []string
	Description string
}

func main() {
	out := map[string]*Snip{}

	b, err := ioutil.ReadFile("html.json")
	if err != nil {
		sklog.Fatalf("Failed to read: %s", err)
	}

	lines := strings.Split(string(b), "\n")
	var current *Snip
	name := ""
	for _, line := range lines {

		if strings.HasPrefix(line, "snippet") {
			parts := strings.Split(line, " ")
			name = parts[1]
			desc := strings.Replace(parts[2], "\"", "", -1)
			current = &Snip{
				Description: desc,
				Prefix:      name,
				Body:        []string{},
			}
			// Start a new snip
		} else if strings.HasPrefix(line, "endsnippet") {
			// Emit the snip
			out[name] = current
			current = nil
		} else {
			if current != nil {
				line = strings.Replace(line, "\t", "  ", -1)
				current.Body = append(current.Body, line)
			}
		}
	}
	// json encode all snippets
	b, err = json.MarshalIndent(out, "", "  ")
	if err != nil {
		sklog.Fatalf("Failed to encode: %s", err)
	}
	if _, err := os.Stdout.Write(b); err != nil {
		sklog.Fatalf("Failed to write: %s", err)
	}
}
