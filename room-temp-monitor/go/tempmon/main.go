package main

import (
	"bytes"
	"flag"
	"fmt"
	"os/exec"
	"os/user"
	"strconv"
	"time"

	"github.com/rcrowley/go-metrics"
	"github.com/skia-dev/glog"
	"skia.googlesource.com/buildbot.git/go/common"
)

var (
	graphiteServer = flag.String("graphite_server", "skia-monitoring:2003", "Where is Graphite metrics ingestion server running.")
)

func main() {
	common.InitWithMetrics("tempmon", graphiteServer)

	usr, err := user.Current()
	if err != nil {
		glog.Fatalf("Failed to find the user: %s", err)
	}

	tempGauge := metrics.NewRegisteredGaugeFloat64("temp."+usr.Username+".desk", metrics.DefaultRegistry)

	for _ = range time.Tick(time.Second) {
		f, err := readTemp()
		if err != nil {
			glog.Errorf("Failed to read temp: %s", err)
			continue
		}
		tempGauge.Update(f)
	}
}

func readTemp() (float64, error) {
	cmd := exec.Command("/usr/local/bin/temper")
	var out bytes.Buffer
	cmd.Stdout = &out
	err := cmd.Run()
	if err != nil {
		return 0.0, fmt.Errorf("Failed to read from device: %s", err)
	}
	s := out.String()
	if len(s) == 0 {
		return 0.0, fmt.Errorf("Failed to read meaningful data from device")
	}
	s = s[:len(s)-2]
	return strconv.ParseFloat(s, 64)
}
