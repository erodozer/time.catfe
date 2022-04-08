extends Node

var guest = null

var bodies = 0
var capacity = 2 # allow up to 2 guests at a time

var locations = {
	"center": {
		"capacity": 3,
		"balance": 0,
	},
	"table_1": {
		"capacity": 3,
		"balance": 0,
	},
	"table_2": {
		"capacity": 3,
		"balance": 0,
	},
	"kitchen": {
		"capacity": 1,
		"balance": 0,
	},
	"outside": {
		"capacity": 999,
		"balance": 0,
	},
	"catbed": {
		"capacity": 1,
		"balance": 0,
	},
}

func reset():
	for l in locations.values():
		l.balance = 0
