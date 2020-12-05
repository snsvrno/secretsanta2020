/*
 * Copyright (c) 2020 snsvrno
 * 
 * Magic, i have no idea realy what its doing. But i got it from the `castledb` page
 * and it loads the castledb data into haxe with types and allows vscode to intellisense
 * it.
 */
 private typedef Init = haxe.macro.MacroType<[cdb.Module.build("res/data.cdb")]>;