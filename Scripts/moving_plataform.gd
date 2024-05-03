extends Node2D

const WAIT_DURATION := 1.0 #constante para criar um delay para plataforma voltar

@onready var plataform := $Plataform as AnimatableBody2D #guardamos uma referência para a plataforma
@export var move_speed := 3.0 #variaveis do tipo @export podem ser editadas pelo espetor
@export var distance := 192
@export var move_horizontal := true 
@export var time_delay := 1

var follow := Vector2.ZERO #vai seguir a plataforma para que não fique trepidando
var plataform_center := 16 #vai calcular o centro do nosso title


# Called when the node enters the scene tree for the first time.
func _ready():
	move_plataform()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	plataform.position = plataform.position.lerp(follow, 0.5)

func move_plataform():
	var move_direction = Vector2.RIGHT * distance if move_horizontal else Vector2.UP * distance  #mover da esquerda para direita caso movement_horizontal for true, caso contrario se move para cima
	var duration = move_direction.length() / float(move_speed * plataform_center) #duração = distancia / velocidade
	
	var plataform_tween = create_tween().set_loops().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT) #criando nosso tween para animação de movimentação
	plataform_tween.tween_property(self, "follow", move_direction, duration).set_delay(WAIT_DURATION * time_delay) #mover da direita para esquerda
	plataform_tween.tween_property(self, "follow", Vector2.ZERO, duration).set_delay(WAIT_DURATION * time_delay) #voltar ao vetor zero
	
