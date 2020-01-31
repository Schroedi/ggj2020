GODOT=/Applications/Godot.app/Contents/MacOS/Godot
#EXPORT=--export
EXPORT=--export-debug

.PHONY: all screen controller serve publish

all: screen controller

screen:
	$(GODOT) $(EXPORT) Game Exported/screen.html

controller:
	cp project.godot project.godot.orig
	sed  's|run/main_scene="res://Game/GameScene.tscn"|run/main_scene="res://Controller/Controller.tscn"|' project.godot.orig > project.godot
	# the minus makes make continue even if the export fails
	# we use this to make sure that the main scene replacement is reverted
	-$(GODOT) $(EXPORT) Controller Exported/controller.html
	mv project.godot.orig project.godot
serve:
	cd Exported && python3 -m http.server 8000

publish:
	rsync -c Exported/* keksdev.de:/var/www/html/keksdev/acgodot/
