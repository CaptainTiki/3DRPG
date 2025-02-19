extends Resource
class_name CharacterStats

class Ability:
	var min_modifier: float
	var max_modifier: float
	
	var ability_score: int = 25:
		set(value): ability_score = clamp(value, 0, 100)
	
	func _init(min:float, max:float) -> void:
		min_modifier = min
		max_modifier = max
	
	func percentile_lerp(min_boundary: float, max_boundary: float)-> float:
		return lerp(min_boundary, max_boundary, ability_score / 100.0)
	
	func get_modifer() -> float:
		return percentile_lerp(min_modifier, max_modifier)



var level : int = 1
var xp : int = 1

#damage bonus on attack
var strength := Ability.new(2.0, 12.0)
#movement speed in m/s
var speed := Ability.new(3.0, 7.0)
#extra hitpoints per level
var endurance := Ability.new(5.0, 25.0)
#crit chance
var agility := Ability.new(0.05, 0.25)

func get_base_speed() -> float:
	return speed.get_modifier()
