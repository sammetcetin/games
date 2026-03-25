# PROTOTYPE - NOT FOR PRODUCTION
# Question: Is wave resolution satisfying with 2-3 light player decisions?
#           Does the dual-purpose building mechanic read clearly to a new player?
# Date: 2026-03-26

extends Node2D

# ─────────────────────────────────────────────────────────────────────────────
#  CONSTANTS
# ─────────────────────────────────────────────────────────────────────────────

const TILE_SIZE: int = 60
const GRID_W: int = 9
const GRID_H: int = 8
const GRID_OFFSET: Vector2 = Vector2(30, 50)

# ─────────────────────────────────────────────────────────────────────────────
#  BUILDING DEFINITIONS (hardcoded — prototype only)
# ─────────────────────────────────────────────────────────────────────────────

const BUILDING_DEFS: Array = [
	{
		"cell": Vector2i(2, 2),
		"name": "Solar Array",
		"abbrev": "SOL",
		"color": Color(0.95, 0.85, 0.1),
		"econ": "15 energy/s",
		"defense_passive": "EM pulse (radius 2) fires at wave start — 2 dmg",
		"defense_active": "TRIGGER PULSE: all arrays fire together — 3 dmg to all",
	},
	{
		"cell": Vector2i(5, 2),
		"name": "Fuel Refinery",
		"abbrev": "REF",
		"color": Color(0.95, 0.45, 0.1),
		"econ": "10 fuel/s",
		"defense_passive": "Barrier: absorbs 1 incoming hit passively",
		"defense_active": "DETONATE: sacrifice building — area blast, 5 dmg north lane",
	},
	{
		"cell": Vector2i(3, 5),
		"name": "Ore Processor",
		"abbrev": "ORE",
		"color": Color(0.4, 0.85, 0.4),
		"econ": "8 ore/s",
		"defense_passive": "Blast barrier: blocks 1 hit, then recharges over 30s",
		"defense_active": "(No active ability — purely passive)",
	},
	{
		"cell": Vector2i(6, 5),
		"name": "Power Core",
		"abbrev": "PWR",
		"color": Color(0.3, 0.65, 1.0),
		"econ": "20 energy/s",
		"defense_passive": "Passive: reduces incoming damage to adjacent buildings by 1",
		"defense_active": "REINFORCE: shield pulse — deflects all east-lane hostiles this wave",
	},
]

# ─────────────────────────────────────────────────────────────────────────────
#  STATE
# ─────────────────────────────────────────────────────────────────────────────

enum Phase { BUILD, WAVE_ACTIVE, POST_WAVE }
var phase: Phase = Phase.BUILD

var enemies: Array[Dictionary] = []
var enemy_display_nodes: Array[Node] = []

var abilities_used: Array[bool] = [false, false, false]
var ability_buttons: Array[Button] = []

var passive_kills: int = 0
var ability_kills: int = 0
var enemies_reached: int = 0
var refinery_destroyed: bool = false

# ─────────────────────────────────────────────────────────────────────────────
#  UI REFERENCES
# ─────────────────────────────────────────────────────────────────────────────

var log_panel: RichTextLabel
var sidebar_panel: RichTextLabel
var start_wave_btn: Button
var abilities_label: Label
var building_info_label: RichTextLabel

# ─────────────────────────────────────────────────────────────────────────────
#  INIT
# ─────────────────────────────────────────────────────────────────────────────

func _ready() -> void:
	_draw_background()
	_draw_grid()
	_place_buildings()
	_draw_spawn_indicators()
	_setup_ui()
	_show_build_info()


# ─────────────────────────────────────────────────────────────────────────────
#  SCENE CONSTRUCTION
# ─────────────────────────────────────────────────────────────────────────────

func _draw_background() -> void:
	var bg := ColorRect.new()
	bg.size = Vector2(1100, 700)
	bg.color = Color(0.04, 0.04, 0.07)
	add_child(bg)

	# Title bar
	var title := Label.new()
	title.text = "EXTRACTION PROTOCOL  //  Wave Resolution Prototype  //  Godot 4.6"
	title.position = Vector2(10, 8)
	title.add_theme_font_size_override("font_size", 13)
	title.add_theme_color_override("font_color", Color(0.4, 0.4, 0.5))
	add_child(title)


func _draw_grid() -> void:
	for x in range(GRID_W):
		for y in range(GRID_H):
			var tile := ColorRect.new()
			tile.size = Vector2(TILE_SIZE - 2, TILE_SIZE - 2)
			tile.position = GRID_OFFSET + Vector2(x * TILE_SIZE + 1, y * TILE_SIZE + 1)
			tile.color = Color(0.09, 0.11, 0.14)
			add_child(tile)

	# Grid border
	var border := ColorRect.new()
	border.position = GRID_OFFSET - Vector2(2, 2)
	border.size = Vector2(GRID_W * TILE_SIZE + 4, GRID_H * TILE_SIZE + 4)
	border.color = Color(0.2, 0.25, 0.3, 0.4)
	border.z_index = -1
	add_child(border)


func _place_buildings() -> void:
	for b in BUILDING_DEFS:
		var c: Vector2i = b["cell"]
		var pos: Vector2 = GRID_OFFSET + Vector2(c.x * TILE_SIZE + 3, c.y * TILE_SIZE + 3)

		# Building tile
		var rect := ColorRect.new()
		rect.size = Vector2(TILE_SIZE - 6, TILE_SIZE - 6)
		rect.position = pos
		rect.color = (b["color"] as Color) * 0.55
		rect.name = "Bld_%d_%d" % [c.x, c.y]
		add_child(rect)

		# Glow border
		var glow := ColorRect.new()
		glow.size = Vector2(TILE_SIZE - 2, TILE_SIZE - 2)
		glow.position = GRID_OFFSET + Vector2(c.x * TILE_SIZE + 1, c.y * TILE_SIZE + 1)
		glow.color = (b["color"] as Color) * Color(1, 1, 1, 0.15)
		glow.z_index = 1
		add_child(glow)

		# Abbreviation label
		var abbrev := Label.new()
		abbrev.text = b["abbrev"]
		abbrev.position = pos + Vector2(8, 8)
		abbrev.add_theme_font_size_override("font_size", 15)
		abbrev.add_theme_color_override("font_color", b["color"])
		abbrev.z_index = 2
		add_child(abbrev)

		# Defense icon
		var icon := Label.new()
		icon.text = "⚙"
		icon.position = pos + Vector2(34, 8)
		icon.add_theme_font_size_override("font_size", 13)
		icon.add_theme_color_override("font_color", Color(0.6, 0.6, 0.7))
		icon.z_index = 2
		add_child(icon)


func _draw_spawn_indicators() -> void:
	# North lane spawn arrows (columns 1, 3, 5)
	for col in [1, 3, 5]:
		var arrow := Label.new()
		arrow.text = "▼"
		arrow.position = GRID_OFFSET + Vector2(col * TILE_SIZE + 18, -28)
		arrow.add_theme_color_override("font_color", Color(1.0, 0.25, 0.25))
		arrow.add_theme_font_size_override("font_size", 20)
		add_child(arrow)

	# East lane spawn arrows (rows 2, 4)
	for row in [2, 4]:
		var arrow := Label.new()
		arrow.text = "◄"
		arrow.position = GRID_OFFSET + Vector2(GRID_W * TILE_SIZE + 8, row * TILE_SIZE + 16)
		arrow.add_theme_color_override("font_color", Color(1.0, 0.25, 0.25))
		arrow.add_theme_font_size_override("font_size", 20)
		add_child(arrow)

	# Lane labels
	var north_lbl := Label.new()
	north_lbl.text = "NORTH LANE"
	north_lbl.position = GRID_OFFSET + Vector2(1 * TILE_SIZE, -48)
	north_lbl.add_theme_font_size_override("font_size", 11)
	north_lbl.add_theme_color_override("font_color", Color(0.7, 0.3, 0.3))
	add_child(north_lbl)

	var east_lbl := Label.new()
	east_lbl.text = "EAST"
	east_lbl.position = GRID_OFFSET + Vector2(GRID_W * TILE_SIZE + 6, 1 * TILE_SIZE + 16)
	east_lbl.add_theme_font_size_override("font_size", 11)
	east_lbl.add_theme_color_override("font_color", Color(0.7, 0.3, 0.3))
	add_child(east_lbl)


# ─────────────────────────────────────────────────────────────────────────────
#  UI SETUP
# ─────────────────────────────────────────────────────────────────────────────

func _setup_ui() -> void:
	var panel_x: float = GRID_OFFSET.x + GRID_W * TILE_SIZE + 50

	# ── ABILITY BUTTONS ──────────────────────────────────────────────────────

	var ability_defs: Array[Dictionary] = [
		{ "label": "⚡  TRIGGER PULSE", "sub": "All Solar Arrays fire — 3 dmg to all enemies", "color": Color(0.95, 0.85, 0.1) },
		{ "label": "💥  DETONATE REFINERY", "sub": "Sacrifice refinery — area blast, north lane", "color": Color(0.95, 0.45, 0.1) },
		{ "label": "🛡  REINFORCE SECTOR", "sub": "Power Core shields — deflects east lane", "color": Color(0.3, 0.65, 1.0) },
	]

	for i in range(3):
		var btn := Button.new()
		btn.text = ability_defs[i]["label"] + "\n" + ability_defs[i]["sub"]
		btn.position = Vector2(panel_x, 60 + i * 75)
		btn.size = Vector2(255, 65)
		btn.visible = false
		btn.disabled = false
		var idx := i
		btn.pressed.connect(func() -> void: _use_ability(idx))
		add_child(btn)
		ability_buttons.append(btn)

	# ── ABILITIES REMAINING LABEL ─────────────────────────────────────────────

	abilities_label = Label.new()
	abilities_label.position = Vector2(panel_x, 290)
	abilities_label.text = ""
	abilities_label.add_theme_font_size_override("font_size", 13)
	abilities_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.8))
	add_child(abilities_label)

	# ── START WAVE BUTTON ─────────────────────────────────────────────────────

	start_wave_btn = Button.new()
	start_wave_btn.text = "▶  START WAVE"
	start_wave_btn.position = Vector2(panel_x, 60)
	start_wave_btn.size = Vector2(255, 55)
	start_wave_btn.pressed.connect(_start_wave)
	add_child(start_wave_btn)

	# ── WAVE LOG ──────────────────────────────────────────────────────────────

	var log_bg := ColorRect.new()
	log_bg.position = Vector2(panel_x - 5, 310)
	log_bg.size = Vector2(265, 330)
	log_bg.color = Color(0.07, 0.07, 0.1)
	add_child(log_bg)

	log_panel = RichTextLabel.new()
	log_panel.position = Vector2(panel_x, 315)
	log_panel.size = Vector2(255, 320)
	log_panel.bbcode_enabled = true
	log_panel.scroll_following = true
	add_child(log_panel)

	# ── BUILDING INFO SIDEBAR ─────────────────────────────────────────────────

	var info_bg := ColorRect.new()
	info_bg.position = Vector2(GRID_OFFSET.x - 5, GRID_OFFSET.y + GRID_H * TILE_SIZE + 15)
	info_bg.size = Vector2(GRID_W * TILE_SIZE + 10, 140)
	info_bg.color = Color(0.07, 0.07, 0.1)
	add_child(info_bg)

	building_info_label = RichTextLabel.new()
	building_info_label.position = Vector2(GRID_OFFSET.x, GRID_OFFSET.y + GRID_H * TILE_SIZE + 20)
	building_info_label.size = Vector2(GRID_W * TILE_SIZE, 130)
	building_info_label.bbcode_enabled = true
	add_child(building_info_label)


# ─────────────────────────────────────────────────────────────────────────────
#  BUILD PHASE INFO
# ─────────────────────────────────────────────────────────────────────────────

func _show_build_info() -> void:
	building_info_label.clear()
	building_info_label.append_text("[color=gray]BUILDING LEGEND[/color]\n")
	for b in BUILDING_DEFS:
		building_info_label.append_text(
			"[color=%s][b]%s[/b][/color] %s  |  Econ: %s  |  Defense: %s\n" % [
				b["color"].to_html(false),
				b["abbrev"],
				b["name"],
				b["econ"],
				b["defense_passive"],
			]
		)


# ─────────────────────────────────────────────────────────────────────────────
#  WAVE START
# ─────────────────────────────────────────────────────────────────────────────

func _start_wave() -> void:
	phase = Phase.WAVE_ACTIVE
	start_wave_btn.visible = false
	abilities_used = [false, false, false]
	passive_kills = 0
	ability_kills = 0
	enemies_reached = 0
	refinery_destroyed = false

	enemies = [
		{ "id": 1, "health": 3, "max": 3, "lane": "north", "col": 1, "dead": false },
		{ "id": 2, "health": 3, "max": 3, "lane": "north", "col": 3, "dead": false },
		{ "id": 3, "health": 4, "max": 4, "lane": "north", "col": 5, "dead": false },
		{ "id": 4, "health": 3, "max": 3, "lane": "east",  "row": 2, "dead": false },
		{ "id": 5, "health": 2, "max": 2, "lane": "east",  "row": 4, "dead": false },
	]

	log_panel.clear()
	_log("[color=red][b]⚠  HOSTILE WAVE DETECTED[/b][/color]")
	_log("5 units inbound: 3 north, 2 east.\n")
	_log("[color=gray]Your colony's defenses are activating...[/color]\n")

	for btn in ability_buttons:
		btn.visible = true
		btn.disabled = false
	_refresh_abilities_label()
	_draw_enemies()

	await get_tree().create_timer(0.6).timeout
	_fire_passive_defenses()


# ─────────────────────────────────────────────────────────────────────────────
#  PASSIVE DEFENSES
# ─────────────────────────────────────────────────────────────────────────────

func _fire_passive_defenses() -> void:
	_log("[color=gray]── PASSIVE DEFENSES ──[/color]")

	# Ore Processor: blast barrier absorbs lead north hit
	_log("[color=green]Ore Processor[/color] barrier activates.")
	_log("  North E1: incoming hit [b]absorbed[/b]. (0 dmg taken)")

	# Power Core: reduces adjacent building damage by 1 (passive, no log needed — already shown in legend)

	# Solar Array: EM pulse hits north enemies in radius
	await get_tree().create_timer(0.4).timeout
	_log("\n[color=yellow]Solar Array[/color] EM pulse radiates...")

	var pulse_hits: int = 0
	for e in enemies:
		if not e["dead"] and e["lane"] == "north" and e["col"] <= 3:
			e["health"] -= 2
			pulse_hits += 1
			if e["health"] <= 0:
				e["dead"] = true
				passive_kills += 1

	if passive_kills > 0:
		_log("  [color=yellow]%d enemy(s) destroyed by pulse![/color]" % passive_kills)
	else:
		_log("  2 dmg dealt to E1, E2 in radius.")

	_draw_enemies()

	# Update info panel to show active abilities
	building_info_label.clear()
	building_info_label.append_text("[color=gray]ACTIVE ABILITIES (3 available — choose wisely)[/color]\n")
	for b in BUILDING_DEFS:
		building_info_label.append_text(
			"[color=%s][b]%s[/b][/color]: %s\n" % [
				b["color"].to_html(false),
				b["abbrev"],
				b["defense_active"],
			]
		)


# ─────────────────────────────────────────────────────────────────────────────
#  ACTIVE ABILITIES
# ─────────────────────────────────────────────────────────────────────────────

func _use_ability(idx: int) -> void:
	if abilities_used[idx] or phase != Phase.WAVE_ACTIVE:
		return

	abilities_used[idx] = true
	ability_buttons[idx].disabled = true
	_refresh_abilities_label()

	match idx:
		0:
			_ability_trigger_pulse()
		1:
			_ability_detonate_refinery()
		2:
			_ability_reinforce_sector()

	_draw_enemies()

	# Auto-end if all abilities used or no enemies remain
	if _all_abilities_used() or _all_dead():
		await get_tree().create_timer(1.2).timeout
		_end_wave()


func _ability_trigger_pulse() -> void:
	_log("\n[color=yellow][b]⚡ PULSE TRIGGERED[/b][/color]")
	_log("All Solar Arrays discharge simultaneously...")

	var killed: int = 0
	for e in enemies:
		if not e["dead"]:
			e["health"] -= 3
			if e["health"] <= 0:
				e["dead"] = true
				killed += 1

	ability_kills += killed
	if killed > 0:
		_log("  [color=yellow]%d hostile(s) eliminated.[/color]" % killed)
	else:
		_log("  Heavy damage dealt — enemies weakened.")
	_log("  [color=gray](Solar Arrays overheat: 30s recharge)[/color]")


func _ability_detonate_refinery() -> void:
	_log("\n[color=orange][b]💥 REFINERY DETONATED[/b][/color]")
	_log("Fuel Refinery ignites — chain explosion!")
	refinery_destroyed = true

	var killed: int = 0
	for e in enemies:
		if not e["dead"] and e["lane"] == "north":
			e["health"] -= 5
			if e["health"] <= 0:
				e["dead"] = true
				killed += 1

	ability_kills += killed
	_log("  North lane: [color=orange]%d hostile(s) destroyed.[/color]" % killed)
	_log("  [color=red]⚠ Refinery lost — fuel output gone this run.[/color]")

	# Visually mark refinery destroyed
	var c: Vector2i = BUILDING_DEFS[1]["cell"]
	var bld := get_node_or_null("Bld_%d_%d" % [c.x, c.y])
	if bld:
		(bld as ColorRect).color = Color(0.3, 0.1, 0.1)


func _ability_reinforce_sector() -> void:
	_log("\n[color=cyan][b]🛡 SECTOR REINFORCED[/b][/color]")
	_log("Power Core projects shield over east lane.")

	var deflected: int = 0
	for e in enemies:
		if not e["dead"] and e["lane"] == "east":
			e["dead"] = true
			deflected += 1

	ability_kills += deflected
	_log("  [color=cyan]%d east-lane unit(s) deflected.[/color]" % deflected)
	_log("  [color=gray](Power Core drains: no passive output next wave)[/color]")


# ─────────────────────────────────────────────────────────────────────────────
#  WAVE END
# ─────────────────────────────────────────────────────────────────────────────

func _end_wave() -> void:
	phase = Phase.POST_WAVE

	for btn in ability_buttons:
		btn.visible = false
	abilities_label.text = ""

	enemies_reached = 0
	for e in enemies:
		if not e["dead"]:
			enemies_reached += 1

	_log("\n[color=white][b]═══ WAVE COMPLETE ═══[/b][/color]")

	if enemies_reached == 0:
		_log("[color=green][b]Colony intact. All hostiles neutralized.[/b][/color]")
	else:
		_log("[color=red]%d hostile(s) reached the core.[/color]" % enemies_reached)

	_log("\n[color=gray]── DAMAGE REPORT ──[/color]")
	_log("[color=yellow]Solar Array[/color]: EM pulse fired passively ✓")

	if refinery_destroyed:
		_log("[color=red]Fuel Refinery[/color]: SACRIFICED — blast cleared north lane ✓")
	else:
		_log("[color=orange]Fuel Refinery[/color]: Barrier active. Intact.")

	_log("[color=green]Ore Processor[/color]: Blast barrier absorbed 1 hit ✓")

	if abilities_used[2]:
		_log("[color=cyan]Power Core[/color]: Shield pulse deflected east lane ✓")
	else:
		_log("[color=cyan]Power Core[/color]: Passive output only.")

	_log("\nPassive kills: [color=yellow]%d[/color]" % passive_kills)
	_log("Ability kills: [color=cyan]%d[/color]" % ability_kills)

	# Post-wave prompt for playtester
	building_info_label.clear()
	building_info_label.append_text(
		"[color=white][b]PLAYTESTER: Answer these questions now[/b][/color]\n"
		+ "1. Did it feel like [b]your factory[/b] was fighting — or like YOU were fighting?\n"
		+ "2. Were 3 decisions [b]too few, about right, or too many[/b]?\n"
		+ "3. Was the damage report [b]clear enough[/b] to understand what happened and why?\n"
		+ "[color=gray]Restart Godot to test again with different ability choices.[/color]"
	)


# ─────────────────────────────────────────────────────────────────────────────
#  ENEMY DISPLAY
# ─────────────────────────────────────────────────────────────────────────────

func _draw_enemies() -> void:
	for n in enemy_display_nodes:
		if is_instance_valid(n):
			n.queue_free()
	enemy_display_nodes.clear()

	for e in enemies:
		if e["dead"]:
			continue

		var pos: Vector2
		if e["lane"] == "north":
			pos = GRID_OFFSET + Vector2(e["col"] * TILE_SIZE + 15, -38)
		else:
			pos = GRID_OFFSET + Vector2(GRID_W * TILE_SIZE + 12, e["row"] * TILE_SIZE + 12)

		var dot := ColorRect.new()
		dot.size = Vector2(28, 28)
		dot.color = Color(0.9, 0.15, 0.15)
		dot.position = pos
		add_child(dot)
		enemy_display_nodes.append(dot)

		var lbl := Label.new()
		lbl.text = "E%d\n❤%d" % [e["id"], e["health"]]
		lbl.position = pos + Vector2(-2, 30)
		lbl.add_theme_font_size_override("font_size", 10)
		lbl.add_theme_color_override("font_color", Color(1.0, 0.5, 0.5))
		add_child(lbl)
		enemy_display_nodes.append(lbl)


# ─────────────────────────────────────────────────────────────────────────────
#  HELPERS
# ─────────────────────────────────────────────────────────────────────────────

func _all_dead() -> bool:
	for e in enemies:
		if not e["dead"]:
			return false
	return true


func _all_abilities_used() -> bool:
	return abilities_used[0] and abilities_used[1] and abilities_used[2]


func _refresh_abilities_label() -> void:
	var remaining: int = abilities_used.count(false)
	abilities_label.text = "%d abilit%s remaining" % [
		remaining, "y" if remaining == 1 else "ies"
	]


func _log(msg: String) -> void:
	log_panel.append_text(msg + "\n")
