extends Node

var guest = null

var bodies = 0
var capacity = 4

var locations = {
	"center": {
		"capacity": 2,
		"balance": 0,
	},
	"table_1": {
		"capacity": 2,
		"balance": 0,
	},
	"table_2": {
		"capacity": 2,
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
	}
}
