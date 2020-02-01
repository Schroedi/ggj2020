GODOT="/Applications/Godot.app/Contents/MacOS/Godot"
USERNAME := $(shell echo $$USERNAME)
UsNAME:= Rico
ifeq ($(USERNAME),$(UsNAME))
	GODOT=/c/Tools/Godot_v3.2-stable_mono_win64/Godot_v3.2-stable_mono_win64.exe
endif

#EXPORT=--export
EXPORT=--export-debug

.PHONY: all screen controller serve publish

all: screen

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
	cd Exported && python -m http.server 8000

te:
	
publish:
	rsync -c Exported/* keksdev.de:/var/www/html/keksdev/acgodot/
