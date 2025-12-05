extends PanelContainer

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel
@onready var progress_bar = $%ProgressBar
@onready var purchase_button = $%PurchaseButton
@onready var progress_label = %ProgressLabel
@onready var count_label = $%CountLabel
@onready var loadout_button = $%LoadoutButton


var upgrade: MetaUpgrade


func _ready():
	purchase_button.pressed.connect(on_purchase_pressed)
	if loadout_button:
		loadout_button.pressed.connect(on_loadout_pressed)


func set_meta_upgrade(meta_upgrade: MetaUpgrade):
	upgrade = meta_upgrade
	name_label.text = upgrade.title
	description_label.text = upgrade.description
	update_progress()
	update_loadout_button()


func update_progress():
	var current_quantity = 0
	if MetaProgression.save_data[Constants.SAVE_KEY_META_UPGRADES].has(upgrade.id):
		current_quantity = MetaProgression.save_data[Constants.SAVE_KEY_META_UPGRADES][upgrade.id][Constants.SAVE_KEY_QUANTITY]

	var is_maxed = current_quantity >= upgrade.max_quantity
	var currency = MetaProgression.save_data[Constants.SAVE_KEY_META_UPGRADE_CURRENCY]
	var percent = currency / upgrade.experience_cost
	percent = min(percent, 1)
	progress_bar.value = percent
	purchase_button.disabled = percent < 1 || is_maxed
	purchase_button.visible = !is_maxed
	if is_maxed:
		progress_label.text = "Max Level"
	else:
		progress_label.text = str(currency) + "/" + str(upgrade.experience_cost)
	count_label.text = "x%d" % current_quantity
	
	update_loadout_button()


func update_loadout_button():
	if !loadout_button or !upgrade:
		return
	
	loadout_button.visible = true
	var current_quantity = MetaProgression.get_upgrade_count(upgrade.id)
	var is_in_loadout = MetaProgression.is_upgrade_in_loadout(upgrade.id)
	var loadout_count = MetaProgression.save_data[Constants.SAVE_KEY_ACTIVE_LOADOUT].size()
	
	if current_quantity == 0:
		loadout_button.disabled = true
		loadout_button.text = "Locked"
		loadout_button.modulate = Color(1, 1, 1)
	elif is_in_loadout:
		loadout_button.disabled = false
		loadout_button.text = "Equipped"
		loadout_button.modulate = Color(1, 0.9, 0.5)
	elif loadout_count >= Constants.MAX_LOADOUT_SLOTS:
		loadout_button.disabled = true
		loadout_button.text = "Slots Full"
		loadout_button.modulate = Color(1, 1, 1)
	else:
		loadout_button.disabled = false
		loadout_button.text = "Equip"
		loadout_button.modulate = Color(1, 1, 1)


func select_card():
	$AnimationPlayer.play("selected")


func on_purchase_pressed():
	if upgrade == null:
		return
	MetaProgression.add_meta_upgrade(upgrade)
	MetaProgression.save_data[Constants.SAVE_KEY_META_UPGRADE_CURRENCY] -= upgrade.experience_cost
	MetaProgression.save()
	get_tree().call_group(Constants.GROUP_META_UPGRADE_CARD, "update_progress")
	$AnimationPlayer.play("selected")


func on_loadout_pressed():
	if upgrade == null:
		return
	MetaProgression.toggle_loadout_upgrade(upgrade.id)
	get_tree().call_group(Constants.GROUP_META_UPGRADE_CARD, "update_loadout_button")
	get_tree().call_group(Constants.GROUP_META_MENU, "update_loadout_label")
	$AnimationPlayer.play("selected")
