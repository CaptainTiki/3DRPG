extends Resource
class_name CharacterStats

class Ability:
	var min_modifier: float
	var max_modifier: float
	
	var ability_score: int = 25:
		set(value): ability_score = clamp(value, 0, 100)
	
	func _init(minvalue:float, maxvalue:float) -> void:
		min_modifier = minvalue
		max_modifier = maxvalue
	
	func percentile_lerp(min_boundary: float, max_boundary: float)-> float:
		return lerp(min_boundary, max_boundary, ability_score / 100.0)
	
	func get_modifer() -> float:
		return percentile_lerp(min_modifier, max_modifier)
	
	func increase() -> void:
		ability_score += randi_range(2, 5)

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

func get_damage_modifier() -> float:
	return strength.get_modifer()

func get_crit_chance() -> float:
	return agility.get_modifer()

func level_up() -> void:
		level += 1
		strength.increase()
		agility.increase()
		speed.increase()
		endurance.increase()
		printt(strength.ability_score, agility.ability_score, speed.ability_score, endurance.ability_score)
