extends StaticBody3D

var rng = RandomNumberGenerator.new()

var player

@onready var model_19 = $model_19
@onready var model_19_blue = $model_19_blue
@onready var model_19_orange = $model_19_orange

@onready var guns = [model_19, model_19_blue, model_19_orange] #tablica w playerze i tutaj musi byc taka sama moze ktos wie jak to exportowac czy cos xpp

@onready var lottery_available = true
@onready var lottery_ended = false
var random_number

func lottery():
	lottery_available = false
	print(lottery_available)
	random_number = rng.randi_range(0, (guns.size() - 1)) #Losuje index z tablicy bron ktora dostanie gracz
	
	for i in range(5): #Iluzja losowosci xd
		for j in range(3):
			print(guns[j])
			guns[j].show()
			await get_tree().create_timer(0.2).timeout
			guns[j].hide()
			
	lottery_ended = true
	guns[random_number].show() #Pokazuje finalna bron
	
func take_gun(): #jezli gracz kliknie w skrzynke po wylosowaniu chowa mu obecna bron ustala ze nowa bron to ta wylosowana i ukrywa bron nad skrzynka
	if lottery_ended:
		player.gun.hide()
		player.gun = player.guns[random_number]
		player.gun.show()
		guns[random_number].hide()
		lottery_ended = false
		await get_tree().create_timer(5).timeout #5 sekundowy cooldown miedzy losowaniami
		lottery_available = true
