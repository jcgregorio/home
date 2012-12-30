// Set dwm status bar message.
package main

import (
	"fmt"
	"os"
	"time"

	"code.google.com/p/x-go-binding/xgb"
)

func main() {
	c, err := xgb.Dial("")
	if err != nil {
		fmt.Println(err)
		return
	}
	defer c.Close()

  for {
    hostname, err := os.Hostname()
    if err != nil {
      hostname = "<hostname unavailable>"
    }

    t := time.Now().Format("03:04   2 Jan 2006")

    title := fmt.Sprintf("%s   %s                  ", hostname, t)
    c.ChangeProperty(
      xgb.PropModeReplace,
      c.DefaultScreen().Root,
      xgb.AtomWmName,
      xgb.AtomString,
      8,
      []byte(title))
    time.Sleep(time.Minute)
  }
}
