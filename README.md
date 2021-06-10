## Slingshot for Minetest

### Description:

Adds a slingshot that can throw inventory items as ammunition.

The original code was extracted from [hook](https://forum.minetest.net/viewtopic.php?t=13634) mod by [AiTechEye](https://forum.minetest.net/memberlist.php?mode=viewprofile&u=16172).

![Screenshot](screenshot.png)

### Licensing:

- Code
	- Original code by AiTechEye: [CC0][lic.cc0]
	- Code by Jordan Irwin (AntumDeluge): [MIT][lic.mit]
- Textures: [CC0][lic.cc0]

### Requirements:

- Minimum Minetest version: 5.0.0
- Depends: [default](https://github.com/minetest/minetest_game/tree/master/mods/default)
- Optional depends:
	- [technic](https://content.minetest.net/packages/RealBadAngel/technic/)
	- [xdecor](https://content.minetest.net/packages/jp/xdecor/)
	- [workbench](https://github.com/AntumMT/mod-xdecor/tree/workbench)

### Usage:

- *Left-click*: Throws items from slot right of slingshot.

#### Crafting:

<details><summary>Spoiler</summary>

**Legend:**

* `SI` = default:steel_ingot
* `ST` = default:stick
* `RB` = slingshot:rubber_band
* `TR` = technic:rubber
* `TL` = technic:raw_latex

**Recipes:**

wooden slingshot:

    ╔════╦════╦════╗
    ║ ST ║    ║ ST ║
    ╠════╬════╬════╣
    ║    ║ ST ║    ║
    ╠════╬════╬════╣
    ║    ║ ST ║    ║
    ╚════╩════╩════╝

wooden slingshot (rubber band required with technic):

    ╔════╦════╦════╗
    ║ ST ║ RB ║ ST ║
    ╠════╬════╬════╣
    ║    ║ ST ║    ║
    ╠════╬════╬════╣
    ║    ║ ST ║    ║
    ╚════╩════╩════╝

iron slingshot:

    ╔════╦════╦════╗
    ║ SI ║    ║ SI ║
    ╠════╬════╬════╣
    ║    ║ SI ║    ║
    ╠════╬════╬════╣
    ║    ║ SI ║    ║
    ╚════╩════╩════╝

iron slingshot (rubber band required with technic):

    ╔════╦════╦════╗
    ║ SI ║ RB ║ SI ║
    ╠════╬════╬════╣
    ║    ║ SI ║    ║
    ╠════╬════╬════╣
    ║    ║ SI ║    ║
    ╚════╩════╩════╝

rubber band:

    ╔════╦════╦════╗
    ║ TL ║ TL ║    ║
    ╠════╬════╬════╣
    ║ TL ║    ║ TL ║
    ╠════╬════╬════╣
    ║    ║ TL ║ TL ║
    ╚════╩════╩════╝

rubber band (shapeless):

    ╔════╗
    ║ TR ║
    ╚════╝

</details>

### Links:

- [Forum](https://forum.minetest.net/viewtopic.php?t=18315)
- [Git repo](https://github.com/AntumMT/mod-slingshot)
- [API](https://antummt.github.io/mod-slingshot/docs/api.html)
- [Changelog](changelog.txt)
- [TODO](TODO.txt)


[lic.cc0]: LICENSE-cc0.txt
[lic.mit]: LICENSE.txt
