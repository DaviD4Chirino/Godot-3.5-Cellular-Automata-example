extends TileMap
tool
export (bool) var run = false setget run_code

func run_code(val):
	run = val
	if run:
		clear()
		var grid = generate_noise_grid(density)
		apply_cellular_automation(grid,iterations)
		draw_map(grid)
		run = false

export(Vector2) var map_size
export(float) var density
export(int) var iterations

var final_map_size : Vector2

enum {
	WALL, #0
	GROUND #1
}


func _ready():
	var grid = generate_noise_grid(density)
	apply_cellular_automation(grid,iterations)
	draw_map(grid)


func apply_cellular_automation(grid: Dictionary, iterations: int):
	var directions = [
		Vector2.UP,
		Vector2.DOWN,
		Vector2.LEFT,
		Vector2.RIGHT,
		
		Vector2.UP + Vector2.RIGHT,
		Vector2.UP + Vector2.LEFT,
		Vector2.DOWN + Vector2.RIGHT,
		Vector2.DOWN + Vector2.LEFT,
	]
	for i in iterations:
		var temp_grid = grid.duplicate()
		for y in map_size.y:
			for x in map_size.x:
				var wall_count := 0
				for dir in directions:
					var neighbour = temp_grid.get(
						Vector2(x,y) + dir
					)
					if neighbour:
						if neighbour == WALL:
							wall_count += 1
					else:
						wall_count+=1
				
				if wall_count > 4:
					grid[Vector2(x,y)] = WALL
				else:
					grid[Vector2(x,y)] = GROUND
					

func draw_map(noise_grid : Dictionary):
	for i in noise_grid.keys():
		set_cellv(i,noise_grid[i])

func generate_noise_grid(density : float):
	var noise_grid : Dictionary = {}
	for x in map_size.x:
		for y in map_size.y:
			var rand = randf()
			if rand > density:
				noise_grid[Vector2(x,y)] = WALL # 0
			else:
				noise_grid[Vector2(x,y)] = GROUND # 1
	return noise_grid

