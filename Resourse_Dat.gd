extends Resource
# This Script contains the default vales of Player Status
# and  all level Status 
export (Vector2) var player_pos = Vector2.ZERO #position of planc
export(float) var hours = 0.0
export (int) var Asteros_limit = 35.0 
export (bool) var red_Shield = false

## zone doors oopen 
export(Dictionary) var Demo_data = {
	"1_Door_open": false,
	"2_Door_open": false,
	"is_Shield": true, 
	"key1_used": false,
	"key2_used": false,
}

