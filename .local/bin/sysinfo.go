/*
 *Copyright (c) 2023 Ashlen <dev@anthes.is>
 *
 *Permission to use, copy, modify, and distribute this software for any
 *purpose with or without fee is hereby granted, provided that the above
 *copyright notice and this permission notice appear in all copies.
 *
 *THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

// TODO: write a man page for this program

package main

import (
	"fmt"
	"log"
	"os/exec"
	"strconv"
	"strings"
	"time"
)

const (
	missingBattery int = 4
	unknownBattery int = 255
)

/*
 *XXX: status bar will be refreshed three times initially due to the
 *three writes to refreshBar that happen before the select.
 *
 *TODO: add MPD functionality back in.
 */
func main() {
	resourceMap := make(map[string]string)
	refreshBar := make(chan bool)

	go func() {
		for {
			batteryString, err := getBatteryString()
			if err != nil {
				log.Fatal(err)
			}
			resourceMap["battery"] = batteryString
			refreshBar <- true
			time.Sleep(time.Second * 30)
		}
	}()

	go func() {
		for {
			temperatureString, err := getTemperature("hw.sensors.cpu0.temp0")
			if err != nil {
				log.Fatal(err)
			}
			resourceMap["temperature"] = temperatureString
			refreshBar <- true
			time.Sleep(time.Second * 2)
		}
	}()

	go func() {
		for {
			spaceFree, err := getRemainingPartitionSpace("/home")
			if err != nil {
				log.Fatal(err)
			}
			resourceMap["space"] = spaceFree
			refreshBar <- true
			time.Sleep(time.Minute * 30)
		}
	}()

	for {
		select {
		case <-refreshBar:
			fmt.Println(
				resourceMap["battery"],
				"+<",
				resourceMap["temperature"],
				"+|R +@fn=0;",
				resourceMap["space"])
		}
	}
}

func getTemperature(tempSysctl string) (string, error) {
	var (
		out          strings.Builder
		outString    string
		tempAsString string
		tempAsInt    int
	)
	cmd := exec.Command("sysctl", "-n", tempSysctl)
	cmd.Stdout = &out

	err := cmd.Run()
	if err != nil {
		return "", err
	}

	tempAsString, _, _ = strings.Cut(out.String(), ".")
	tempAsInt, err = strconv.Atoi(tempAsString)
	if err != nil {
		return "", err
	}

	outString = fmt.Sprintf("%s: %d °C", "temp", tempAsInt)
	return outString, nil
}

func getBatteryPercentage() (int, error) {
	var (
		out               strings.Builder
		batteryPercentage int
	)
	cmd := exec.Command("apm", "-l")
	cmd.Stdout = &out

	err := cmd.Run()
	if err != nil {
		return -1, err
	}

	batteryPercentage, err = strconv.Atoi(strings.TrimRight(out.String(), "\n"))
	if err != nil {
		return -1, err
	}

	return batteryPercentage, nil
}

func getBatteryHourAndMin() (int, int, error) {
	var (
		out                strings.Builder
		remainingMinString string
		remainingMinInt    int
	)
	cmd := exec.Command("apm", "-m")
	cmd.Stdout = &out

	err := cmd.Run()
	if err != nil {
		return -1, -1, err
	}

	remainingMinString = strings.TrimRight(out.String(), "\n")
	if remainingMinString == "unknown" {
		return 0, 0, nil
	}
	remainingMinInt, err = strconv.Atoi(remainingMinString)
	if err != nil {
		return -1, -1, err
	}

	hours := remainingMinInt / 60
	minutes := remainingMinInt % 60
	return hours, minutes, nil
}

func getBatteryStatus() (int, error) {
	var (
		out           strings.Builder
		batteryStatus int
	)
	cmd := exec.Command("apm", "-b")
	cmd.Stdout = &out

	err := cmd.Run()
	if err != nil {
		return -1, err
	}

	batteryStatus, err = strconv.Atoi(strings.TrimRight(out.String(), "\n"))
	if err != nil {
		return -1, err
	}

	return batteryStatus, nil
}

func getAdapterStatus() (int, error) {
	var (
		out           strings.Builder
		adapterStatus int
	)
	cmd := exec.Command("apm", "-a")
	cmd.Stdout = &out

	err := cmd.Run()
	if err != nil {
		return -1, err
	}

	adapterStatus, err = strconv.Atoi(strings.TrimRight(out.String(), "\n"))
	if err != nil {
		return -1, err
	}

	return adapterStatus, nil
}

func getBatteryString() (string, error) {
	var (
		batteryString      string
		adapterStatusLabel string
	)

	batteryLifetime, err := getBatteryPercentage()
	if err != nil {
		return "", err
	}

	batteryHours, batteryMins, err := getBatteryHourAndMin()
	if err != nil {
		return "", err
	}

	adapterStatus, err := getAdapterStatus()
	if err != nil {
		return "", err
	}

	batteryStatus, err := getBatteryStatus()
	if err != nil {
		return "", err
	}
	if batteryStatus == missingBattery || batteryStatus == unknownBattery {
		return "", err
	}

	if adapterStatus == 0 {
		adapterStatusLabel = "bat: "
	} else if adapterStatus == 1 {
		adapterStatusLabel = "chr: "
	} else if adapterStatus == 2 {
		adapterStatusLabel = "bkup: "
	} else {
		adapterStatusLabel = "unkn: "
	}

	batteryString = fmt.Sprintf("%s~%dh and %dm, at %d%%",
		adapterStatusLabel,
		batteryHours,
		batteryMins,
		batteryLifetime)

	return batteryString, nil
}

func getRemainingPartitionSpace(partition string) (string, error) {
	var (
		spaceFreeString string
		out             strings.Builder
	)
	cmd := exec.Command("df", "-h", partition)
	cmd.Stdout = &out

	err := cmd.Run()
	if err != nil {
		return "", err
	}

	dfLines := strings.Split(out.String(), "\n")
	dfLineFields := strings.Fields(dfLines[1])
	spaceFreeString = partition + ": " + dfLineFields[3]
	return spaceFreeString, nil
}

// XXX: this function fails with exit code 1 if mpd daemon isn't running
func getMPDStatus() (string, error) {
	var (
		mpdString string
		out       strings.Builder
	)
	cmd := exec.Command("pgrep", "-q", "mpd")
	err := cmd.Run()
	if err != nil {
		return "", err
	}

	cmd = exec.Command("mpc", "status")
	cmd.Stdout = &out
	err = cmd.Run()
	if err != nil {
		return "", err
	}

	mpcLines := strings.Split(out.String(), "\n")
	if len(mpcLines) == 4 {
		mpdString = mpcLines[0]
	}
	return mpdString, nil
}
