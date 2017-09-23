


/*
					Feed Progress Log!


		Basically this file is to keep track of the changes and whatnot that we make so that we can remember exactly what was done and by who and when.
	This is also important because if something were to break or horribly fuck up the game, we can see a list of everything that was touched as a reference
	for finding what change got made that caused the issue. I manage this and keep it updated myself typically but you're welcome to update this directly!
------------------------------------------------------------------------------------------------------------------------------------------------------

			: PATCH TO-DO LIST:		//// just a list of stuff that is top priority for the current patch iteration.

- new ice element to parallel fire; will freeze and disable affected mobs briefly
- fire will be able to melt or "free" frozen mobs but burning /fire based targets will be 50% resistant to the ice attack
- freeze/ice gun
- grenade launcher
- ice grenade
- portals casted at mobs/objects will tele enemies away without leaving a portal and unlinked portals will have an iconstate to indicate that it's "closed"
- nerf blazes and aliens.
- tako launcher - launches explosive tacos
   - STREAK: smaller tacos, bigger explosions
- slime gun - shoots slime that lowers movement speed
   - STREAK: ??
- finish options menus
- add sound to menus and Orojoro
------------------------------------------------------------------------------------------------

				: DONE THIS PATCH :	//// list of everything that has been completed in the current patch.

- cut and cleaned some of the projectile handling
- cleaned up gun vendor.  re-centered x offset and re positioned guns
- added TAKOS gun -- shoots explosive tacos. no streak combo finished yet
- added a new class ability for Tank class: Rhino Charge
---- basically just charges in the player's direction and does heavy damage to all mobs hit.
- increased the firerate of the gherkin
- damage hit effects now reflect the namecolor of who dealt the damage.
- Medic hp regens twice as fast as normal.
- only 5 enemies can respawn at once now.
- medcrate deployment is done for now!
- made highlights with the mouse perform differently than before
- gave the UI its seizure medication
- retooled keyboard / controller highlighting.  it looks 100% less shitty now!
- took a second pass over Orojoro's AI -- cleaned up old code, tightened up animations for transformation and death, and added bamboozle technique
- added new oil hazard -- when exposed to fire will also light on fire and ignite all oil connected to a trail of oil.
- Added vendor icons for The Gherkin and Jabberjaw
- expanded Streetside a little.
- F will now use whatever the player's class special ability is, instead of defaulting to portal casting.
- move_delay will decrease 0.1 every level (when applicable).
- move_delay, base_defense, and class, are all now saved/loaded player traits.
- added class selection (temp presentation).
--- portal master class is done.
--- medic and tank class just need their class specials.
--- all three classes have unique base stats for health, damage_modifier, base_defense, and move_delay
- character creation and vendor menus are now much more functional and pretty (U4M!)
- fixed scoreboard updating; was still reading waves instead of kills.
- worked on new spawning stuff some moree!!
- removed sound effects for fired casings dropping
- rewrote enemy spawning
- added vertical hedges
- critical kills now cause enemies to gib.
- raised enemy cap on streetside to 50
- fixed overlay layering on the base preview in vendors.
- corrected all the overlay offsets in the game. We need to stay more ontop of this, lol
- Chargers no longer explode upon dying unless it's their self-triggered suicide explosion.
- auto reviving is disabled during deathmatch waves now (and bosses).
---- you can disable auto revivine easily by setting active_game.no_auto_rev to 1
- if the combined level of all participants is greater than 10, games will start on wave 5
- base preview in vendor menus now display offsets properly.
- added the Bandito Supremo outfit set to vendors.
- knockback now works on a much smaller scale.
- projectiles that collide with a p rojectile of the same type from a different owner now cancel eachother out
- added a gravity proc alongside the below. uses knockback but might make a separate gravity proc to parallel knockback.
- created gravity grenades(garavades) ----------------WIPP
- created The Gherkin
---- slowfire auto weapon that  fires pickles. low damage, but hitting a mob of the same type will recover their health
- cash can now be found as drops
- enemies now fluctuate in size normally
- fade trails now have a variable that determines how long the trail will persist
- fade trails added health bars to mobs that didn't have them
- smoke is now marginally less dense
- expanded Streetside some.
- added brute bleeders -- blown up brutes can spawn off into giant bleeders!
- added eyeliner and blue eyes to the face vendor.
- removed evacuate from the map lists temporarily
- cleaned up the debug window.
- added a new admin command - shutdown.
- added a new admin command - reboot.
---- this will help a lot when testing.. lol
- implemented automatic bounds scaling library by Unwanted4Murder
---- already plugged in everywhere and renamed from Bounds_Scale() to bounds_scale()
- added a straddled legs state for mounts.
- nerfed krossbow's pierce rate
- fadetrail() is called to make a fading trail image of a mob.
- crawler brutes can now spawn.
- lowered the maximum ambient lighting
- significantly lowered the frequency that enemies will growl/make noise
---- during late games they were flooding the sound channels and causing certain sound effects to not play.
- Orojoro is functioning -- still a lot of work to do on it's ai behavior. Runs on wave 20(change to 1 in matchmaking.dm to test)
- reduced the speed cap on enemies. It's still fast, it was just ridiculously fast before.
- did some prelim expansion on evacuate.
- nerfed giants a little and lowered their base spawn rate while making them spawn more often on higher waves
- started goliath bboss
- added new giant feeder enemy variants
- nerfed blazes a bit!
- started working on prototyping spawn-in effects for players.
- fixed Micke's Moose Mask
- jabberjaw recieved some tweaks
- added a new freeze() debuff;
---- WIP! disables movement AND weapons temporarily.
- misc. fixes to vendor entries.
- minor changes to menu stuff
- fps balanced a bit more
- vendor ai was tweaked.
---- still some work to do but they're MUCH less sporatic now.
- added pimp outfit
- a few misc. tweaks.
- gibs now have splat sound ef


/*
					Feed Progress Log!


		Basically this file is to keep track of the changes and whatnot that we make so that we can remember exactly what was done and by who and when.
	This is also important because if something were to break or horribly fuck up the game, we can see a list of everything that was touched as a reference
	for finding what change got made that caused the issue. I manage this and keep it updated myself typically but you're welcome to update this directly!
------------------------------------------------------------------------------------------------------------------------------------------------------

			: PATCH TO-DO LIST:		//// just a list of stuff that is top priority for the current patch iteration.

- new ice element to parallel fire; will freeze and disable affected mobs briefly
- fire will be able to melt or "free" frozen mobs but burning /fire based targets will be 50% resistant to the ice attack
- freeze/ice gun
- grenade launcher
- ice grenade
- portals casted at mobs/objects will tele enemies away without leaving a portal and unlinked portals will have an iconstate to indicate that it's "closed"
- nerf blazes and aliens.
- finish menus
    [x] Play
        [ ] Character selection
   	[ ] Options
   	[x] Credits
   	[ ] Quit
- new gun type: Tako Launcher
	shoots a large, exploding taco -- each hit landed makes the tacos smaller and the blast more powerful
------------------------------------------------------------------------------------------------

				: DONE THIS PATCH :	//// list of everything that has been completed in the current patch.

- Mounts are prototyped!
- new shotty; Jabberjaw
- all audio files are now .ogg
- puppet masters probably work!
- gibs got lots of love!  they make a lot more sense now overall
- a few misc. tweaks.
- gibs now have splat sound effects.
- fixed the layering of smudges
- Weapons are all much more responsive and fire rates are more accurately timed now.
- Wicked One got some hella buffs
- feed now runs at 60fps
- fixed a rare bug with doppelgangers not respawning properly.
- smudges are now on an appropriate layer.
- added credits
- added a fancy new main menu
- drop_shell is now a waitfor=0 proc so it won't bog down firing weapons.
- Wicked one damage and fire rate was buffed; also increased clip size to 15
- krossbow damage was buffed
- shortened cooldown for hopping in place.
- fixed the pants positioning for Deppelgangers.
- el verde now has a vendor icon.
- pause wouldn't pause intermission countdowns.
- new login bg.
- fixed the blank descriptions for certain vendor entrys.
- shirtless option no longer defaults to hoodies
- reload indicator now reflects the reloading progress
- new bullet visual variant for some guns(bullet2)
- new sound effects and music.
- all audio is now handled with the new audio handling.
- dashing now has a slight depth illusion now.
- rewrote the audio mechanics and got everything integrated with volume settings; just need to add the volume toggle.
---- see ( audio/audio_handling.dm ) for the new stuff.
- the color of ambient darkness is now determined by ambient_color
---- ambient_color is now randomly set every wave.
- day/night now supports tinted ambient darkness
- fixed a sound issue (NOTE: sound handling needs an overhaul)
- fixed the overlay offsets for vanity glasses
- clouds now vary in size
- splattering blood now makes a splat sound.
- broken shields now have a sound effect.
- nerfed alien movement speed a little and also lowered alien health pools.
- Rewrote how target arrows are handled. They now manage and remove themselves when appropriate. Simply add targets when you need to!
---- this was SOOOOO much more work than i was expecting lol
- Wicked One's burst rounds are now more tightly timed together.
- fixed the fullscreen offset for kills and cash.
- barrels now have a timer before detonating when detonated via explosion.
- shields now make you immune to smudges and stun
- smudges are now cleaned properly!


-----------------------------------------------------------------------------------------------------------------------------------------------------

				: old patch logs : //// list of ALLLLL the previous/old patch notes/changes. newest on top.


///////////////////////////////////////////////////////////////////////		comment breaks show where each patch started/ended.
 - fire now flickers
 - aliens are now back in the fray
 - smoke is a little more transcluscent.
 - non-boss Doppelgangars no longer stop game progression.
 - arrows that hit enemies now stay stuck to them
 - new weapon; wicked one - burst fire weapon
 - shields now glow
 - added new functionality to spotlights; edit_spotlight() will edit the provided variables of an existing spotlight in realtime
 - shields now extend your spotlight radius marginally with each upgrade.
 - New combat hit effects.
 - screenshake mechanic replaced with Yutty's
 - barricades now have a rolls var that will make them roll a little further when pushed.
 - shortened the time it takes to be portal'd.
 - fixed the bug where the fireproof buff animation would persist foreverrr.
 - revamped numerous stat/HUD icons.
 - Player healthbars now fade out when full.
 - El Verde finally has a weapon drop and can be aquired by players.
 - cap speed fro enemies is slower
 - medkits now heal players of burning debuffs.
 - smoke persists even longer now!
 - Portal casting is now bound to F
 - smoke now gets drawn over light; smoke effectively blots out light now.
 - portals now match the namecolor of whoever created it.
 - new portalling/teleportation animation
 - portals now knockback anything thats sitting in the receiving portal before sending something through.
 - added a depth effect to all thrown specials.
 - finished portal casting; shift+space to cast a portal.
 - added gibs for brutes, pukers, abstract1s, crawlers, and yeah
 - fire can now be put out by rain weather effects
 - explosions now have a larger spotlight.
 - fire spawning is a little more organic now.
 - fire now has a larger spotlight and fire now persists longer.
 - adjusted the spotlight positioning for a couple enemies.
 - added a new variable hit_streak(game/streaks.dm) that tracks the number of consecutive shots that hit a target.
  ---- this resets every game and whenever a bullet expires or hits a wall.
  ---- Can only get 1 kill streak point per projectile!
 - Spotlights now have adjustable sizes and intensity(alpha)
 - Krossbow now has a shorter reload time.
 - player step_size is now a saved variable.
 - player speed is now determined by their weapon.
 - everything is pixel scale'd now.
 - disabled the borked hitlag stuff (was causing the weird fps dips)
 - removed the bullet "whiz" sound effect.
 - vendor npcs now walk around
 - basic pistol now fires quicker.// NEED TO DO FOR THE REST oops caps
 - made a tweak to en_spawn() to help cutback on CPU load.
 - Flamethrower now spawns fire hazards.
 - Uzi now looses accuracy and increases fire rate the longer you hold the trigger.
 - last half of the red baron's clip now ignites enemies on fire.
 - critical_chance rate for players is now 5%
 - in-game chat is now a collapsable on-screen pane.
 - airstrikes are now sticky
 - explosions now sometimes drop fire hazards
 - flamethrowers now drop fire hazards
 - Feeder step size is now variable.
 - smoke clouds now persist longer
 - Enemy speed progression is now twice as slow.
 - Enemy respawn range was pushed back a little bit more.
 - Lysergia and Stalker both got substantial price increases.
 - trails for fire projectiles no longer get the owner's namecolor blending.
 - the last half of the Red Baron's clip now sets enemies ablaze.
 - fixed a rare runtime in misc/gengeneraldir.dm
 - more work on trumpen0r
 ---- shield of russia is causing issues; might just treat the shield of russia like a normal shield but let trump regenerate it through his AI.
 - added mr.trump the boss! still a wip!
 - added shield of russia; a new regen shield buff. (currently only for Trump boss)
 - fixed a bug where auto guns took two from the clip per shot
 - added a buncha new colorzzz
 - added a del marker for target arrows
 - temp disabled suport ai
 - Fixed a bug where kill counts would sometimes carry over between games.
 - Fixed a bug where some automatic weapons wouldn't asign owners to the projectiles they fired.
 - Projectile trails now match the color of their owner's name.
 - Doppel AI got a little improvement.
 - fixed a bug where non-boss doppels wouldn't subtract from the 'enemies_left' var when killed.
 - tweaked spawning mechanics a little.
 - fixed a rare minor runtime with weather effects.
 - gibs work again!
 - you can now hold to use autofire manual weapons with a slow wait.
 - removed the bounce effect from the UI elements
 - projectiles can no longer stack hits.
 - lowered the max speed for enemies
 - fixed an infinite loop in return_vspawn()
 --- This was the cause of the bug that prevented vendor intermissions from progressing!
 - Made improvements to the intermission handling in init_wave() (matchmaking.dm); now handles vendor intermissions natively!
 - Target arrows no longer point towards enemies on separate z levels.
 - Evacuate has destroyable chainlink fences!
 - Theatre now has hidden areas.
 - added new breakable environment pieces ( see environment/breakables.dm )
 - re-enabled the vendor intermissions.
 - Enemies can no longer target mobs on different z levels.
 - Evacuate now has building interiors.
 - added path waypoints so maps now have more flexibility.
 - fixed some overlays on objects in Theatre.
 - Northward edge spikes now hurt and knockback players properly.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 91. added a new special; Green smokebomb.
 90. added a new gun; El Verde
 89. added an alien only wave variant.
 88. added alien enemies.
 87. fixed a bug with puppet masters.
 86. Finished the arms for alien skin. Works in-game now. Just needs to be added via easter egg somehow.
 85. Made a new directory for boss enemies in enemies/bosses.
 ---- each boss type gets it's own .dm file with all relevant procs and definitions for ai and match handling stuff. (ex. see enemies/bosses/doppelganger.dm)
 84. Fixed the Doppelganger's teleport spawning so that he doesn't spawn far away from players anymore.
 83. ported in the Puppet Master enemy from Unwanted.
 ---- now spawns as a normal random wave spawn.
 82. added a stun mechanic.
 ---- players and enemies cxan be stunned when knockback'd into something dense or when taking heavy damage.
 81. added new variables for tracking other players and support ai on the screen
 	------   still need to remove arrows in some instances.
 80. support ai are now back in the fray and use a new awareness mechanic.
 79. more stuff use pixel_scale (weather and target arrows notably)
 78. chargers now get their variables reset at death.
 77. can now break crates by dashing into them.
 76. vendors are DONE!
 75. added a new gore variant for feeders
 74. enemies now have a slightly faster minimum movement speed.
 73. plugged in the fixes for ui_highlighting
 72. dying during intermission could sometimes cause negative revive totals. (fixed)
 71. boom markers stick around longer now.
 70. vanity and special vendors are added.
 69. closing vendors with the ui highlighting now sets the macros and move vars back to normal.
 68. face vendors now work.
 67. enemies now respawn when more than 15 tiles away from the closest player
 66. created an alient skin for players; still need to do arms and implement.
 65. hair vendor now has names and descriptions for all 26 options.
 64. Vendors and character creation now support controller input.
 63. Vendors now have their own spawn point lists.
 62. Hair options in the vendors now have prices.
 61. added a hair vendor, Winston
 60. Made a few new hair overlays.
 59. Made a bunch of new face overlays.
 58. Added Red Baron and Uzis to the weapon vendor.
 57. Player arms no longer show diagonal states when moving; only when shooting diagonally.
 56. Added Stalker and Lysergia to the weapon vendors.
 55. moved players/_Guns.dmi to game/vendors/guns.dmi
 54. added new weapons to the weapon vendor.
 53. deleted player/_Arms.dmi as player/arms.dmi replaced it.
 52. disabled support npcs.
 51. Added a new var for players, hair_lock.  If true, the player will not be able to customize their hair from the current settings.
 50. Micke now has a custom icon <------------------ if_hair_lock is true, the player cannot customize their hair.
 49. finished up more work on float text
 48. Loot can now be dropped on any movable atom; not just npcs.
 47. Doppelgangers now get recycled.
 46. Non-boss Doppels should now be fixed. ** hopefully **
 45. wooden crates that get broken have a chance to drop loot.
 44. Shopping Carts are now moveable barricades
 43. float text was rewritten and now behaves much differently.
 42. kett recieved some tweaks.
 41. players now gain cash.
 40. Every fifth wave is a long intermission now.
 39. added vendors to the game
 38. added new vanity items to the vanity vendor.
 37. Fixed the layering of player overlays.
 36. The Wave indicator now says "Intermission" during intermissions.
 35. made a few tweaks to Streetside.
 34. added a handful of new clothes and vanity affects.
 33. support npcs now have a chance to spawn at the start of every wave. they'll stay until they die.
 32. Enemies no longer spawn in view of players.
 31. Dashing no longer uses trigger_dir for steering (bug)
 30. Doppelgangers are back in the fray
 29. Doppelgangers can now be encountered during normal waves.
 28. Doppelgangers now use object recycling.
 27. added a pause mechanic for solo players.
 26. rewrote how the doppelganger's wave gets handled.
 25. fixed a rare runtime with sticky grenades.
 24. sprint goes further now
 23. bleeders no longer become immune after being culled.
 22. tick_lag now 0.25 and fps is now 40 to improve online performance/input response.
 21. added more to the pre recycle and pre recycle preloads 50 of everything now instead of 100.
 20. Started on stage 2 of Streetside.
 19. Revamped portal mechanics; still need to finish portal spawning and player portal skill================================================================
 18. Decreased the liklihood of creating Bleeders.
 17. added the new macro lists.
 16. removed the spectate toggle inject from the interact command. (finally!!)
 15. all macros are now broken into four separate lists; play; textinput; spectate; lobby
 14. fixed a bug where green smoke would sometimes spawn in place of normal smoke.
 13. Brutes received a HP buff.
 12. sticky bombs/grenades no longer lose their density when collected.
 11. scanlines now get drawn early.
 10. created player/overlay effects.dm
 17. revives tracker overlay is now under mob/var instead of a global var
 16. fixed macros for screenshots and gamepad setup
 15. fixed offsets for HUD elements.
 14. the lobby player list doesn't make blank fields for connecting players anymore.
 13. removed all maps except Streetside and Evacuate from map rotation.
 12. player preview icon when creating a character would have fucky arm offsets.
 11. item drops are now 32x32 states
 10. arms are now 64x64 states
 9. added a new gun; stalker
 8. Faces are now a unique overlay slot.
 7. ported a bunch of new interface and char creation stuff from Unwanted's build.
 6. designed a new reloading indicator.
 --- i'd like to eventually make this indicator a meter display that actually shows progress of reloading instead of a visual representation
 5. green sticky bombs now also create green smoke upon detonation!
 4. Improved the spread of the Lysergia.
 3. rewrote and condensed a bit of code pertaining to enemy spawning.
 2. enemy spawn progression is now randomized and the code in the spawnlist return proc was vastly condensed and improved.
 --- every five waves a random new enemy type is added to the spawnlist.
 1. enemies now have a spawn_rate variable that determines the liklihood of that enemy being included in a round's spawn mix.
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 - enemies gained every round is lower
 - created new legendary weapon, Lysergia.
 - added more blood/gore overlay variants for Feeders.
 - added a chance for the Wilhelm Scream to play when a player dies
 - blown up feeders now have a chance to become bleeders.
 - Bleeders no longer spawn on their own.
 - added a new enemy variant called a bleeder.-----------WIP!!
 - players now all have their movement frozen by default when not in-game.
 - fixed an issue with points and kills not updating (requires a wipe of old saves)
 - fixed an issue where sometimes spectators would get added before participants, resulting in spectators watching nobody.
 - SFX volume defaults to 70 now.
 - fixed character creation (Unwanted)
 - fixed a bug that wrecked havoc on everything(trying to parse /game through pl_spawn() )
 - fixed bug where censored wave modifiers would persist indefinitely.
 - spotlight alpha value is no longer effected by parent object's alpha. (mainly applies to phantom enemies getting almost invis spotlights)
 - F2 can now be used to take in-game screenshots.
 - new spawn progression setup is done.
 - Wave screen splashes are now condensed into a single proc to simplify code.
 - updated special weapons to be better organized and up-to-date with the new trigger setup.
 - player points at the end of a game now get transferred over to their career score.
 - players now gain points for killing enemies. (player/point handling.dm)
 - added explosive mines.
 - removed the flashing color wave modifier.
 - added a secret dev test map.
 - fixed the issue with E not spectating a new player fo first time clients.
 - died_already now defaults to 1 and should be 1 WHENEVER the player is not alive in-game.
 --- this includes when in lobby, logging in, etc.
 - removed all instances of ANIMATION_PARALLEL
 - client.fps is now set to world.fps
 - made a tweak to speed_modi()
 - enemies get faster/stronger over 10 waves instead of 5 now.
 - projectiles now move faster.
 - deathmatches happen on wave 15 and waves after now.
 - dopple spawns on wave 10 now.
 - removed the ak66 altogether.
 - made a new controls folder.
 - all guns now work with the new gun.
 - controller input is now filtered through the same trigger tracking as keyboard input.
 --- if controller_dir isn't null, the game will prioritize controller input and ignore keyboard triggers.
 - strafe movement is now a feature for all weapons(not just automatic) and is determined by trigger_dir.
 - trigger input has been completely rewritten and now supports dynamic input.
 - gamepad can now take custom control inputs (F5)
 - added gamepad support (Unwanted)
 - blue flash from blue fire now goes away when it's done.
 - fixed an issue that would cause player z_offsets to get fucked up.
 - Weapons can now be used diagonally.
 - New map, Evacuate is finally done.
 - Added a new boomerang variant; Kaboomerang.
 --- Causes an explosion on every enemy it hits.
 - Boomerangs now have a proper drop icon.
 - AI now stop running as soon as the game ends
 --- hopefully will fix the infamous random Dopple crash.
 - fixed a bug where the player's base would sometimes get drawn twice.
 - fixed an issue where loading hairstyles with offsets wouldn't apply the offsets
 - sticky grenades now have a throwing animation
 - boomerangs now have 0 density when returning to their thrower to avoid getting caugh up on obstacles.
 - bullet whiz sound effect now only plays for players that are 2px away instead of 5px
 - enemies that explode now also bloat in size before exploding.
 - added an animation effect for when players level up.
 - explosions now have a limit to how many gore particles they can drop.
 - the hurtflash effect is now drawn via client.color rather than screen objects.
 - removed the autofocus mechanism for toggling chat focus.
 - re-enabled score submission.
 - fixed a potential infinite loop in player spawning (Kaiochao)
 - enemy spawning has been cleaned up and improved.
 - playering spawning now gets handled the same across all spawning instances.
 --- spawn_pl(ref) handles this now.
 - draw_base() wasn't getting called when existing players logged in.
 - Support NPCs have been removed for the time being.
 - Brutes are a smidge faster.
 - Crawlers move a smidge slower.
 - vote to skip now requires majority vote.
 - players can no longer spawn ontop of eachother.
 - added a new list players that tracks ALL the players connected to the game. Only used for tracking!!!
 - rewrote and cleaned up a bit of code in matchmaking.dm
 - The UI/BaseObject now has the KEEP_TOGETHER appearance_flag.
 - made a small fix to the Expandable UI stuff.
 --- line 121, character creation.dm
 --- you didn't reset the expanded var to 0 when closing via the done button so if you reopened a section it would derp out.
 - added a new proc: speed_modifier()
 --- Enemies now have their speed derived from the matches' progression.
 - character creation has been implemented. (Unwanted4murder)
 - fixed a small bug for players that disconnect with a wave completion/starting overlay still on their screen.
 - fixed a bug where if a beholder or blaze only wave happened on wave 1, no enemies would spawn.
 - finished up savefile handling (see "player/savefiles.dm")
 - did a few adjustments to the pacing and intensity of the game. Enemies move a bit slower.
 - streetside map got a balancing adjustment,
 - buffed flamethrower a little. (FKI)
 - Improved the way NPCs handle weapons.
 - Dopplegangers can now dopple NPCs.
 -- need to set can_dopple = 1;  requires hair, shirt, pants, vanity variables.
 - Players who survive a Dopple round now get a third tier shield and 50exp.
 - buffed most enemies' health and adjusted some step delays.
 - POSSIBLY fixed the (bug) in the need to do section below.
 - Doppleganger no longer uses spawn before using weapons; seems to help with performance a little!
 -- should look into adding a hook for npcs in gun loops that lets them strafe a little.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 - added a new wave modifier for super dark waves: blackout.
 - players now gain 5 hp per level.
 - min/max lighting levels fluctuate every round now.
 - player nametag now updates when leveling up to reflect the new level.
 - players now gain experience from kills
 -- call give_exp(exp_to_give) to give exp to a player.
 - cleaned up a few old and outdated variables.
 - players no longer have a delay before taking explosive damage
 - adjusted the overlay color for player's level display.
 - fixed strafe-fire for automatic weapons.
 - basic shotgun now shoots 5 projectiles
 - enemy health now scales with waves. (formula = base_health+round(current_round*3))
 - projectiles now have a chance to pierce through enemies.
 - finished the flamethrower.
 - made a few graphic tweaks.
 - game settings now has a PvP variable. Will be used more in coming features.
 -- this variable also made the deathmatch variable obsolete so it was replaced.
 - player bullets now ignore support npcs unless the match is set to PvP.
 - added a few new clothing variants (unwanted4murder)
 - added new support NPCs: Steve and Blue (unwanted4murder)
 - improved the revive overlay indicator
 - added an overlay when getting health or a revive
 - blood drops significantly faster.
 - in rare cases targetting arrows wouldn't get drawn for the last five enemies of a wave.
 - blood drops faster now.
 - shotguns now spread evenly in a cone pattern.
 - more blood!
 - weather is dynamic again.
 - made an optimization tweak with weather animations.
 - cowbells now attract enemies instead of making them ignore the user.
 - support npcs no longer hurt players with their explosions.
 - GMs now have an indicator on their nametag.
 - Item pickup text is now colored!
 - Removed the safe time after recieving damage for players and enemies.
 - added a new wave modifier; trippy_mane
 - fixed a performance hiccup in health loops.
 - fixed a memory leak where projectiles wouldn't stop stepping even after being collected.
 - world tick_lag is now 2 instead of 0.2
 - fixed issue where target arrows wouldn't be removed from Dopples or players.
 - fixed issue where changing who you spectate caused blackscreens.
 - fixed a misplaced var ref in Charger's explosions that was causing havoc everywhere.
 - when playing alone on a server, disconnecting before a wave started would cause the game to idle in its current state with no players.
 - fixed a typo that would cause players not to be removed from the proper lists when they would disconnect.
 - fixed an issue where enemies wouldn't be able to respawn.
 - fixed an issue with top_player stuff not getting removed.
 - portals no longer close
 - Being killed by the Dopple would not remove the target arrows.
 - grenades no longer remain dense after being thrown.
 - doppleganger now mimics vanity items
 - added framework for friendly support npcs.
 - Kett is the first of the support NPCs
 - removed buffer_x/y from screen scaling caluclations as it wasn't used.
 - disabled map scale to fit.
 - improved friendly ai.
 - support ai now get revived each wave.
 - rewrote how enemy spawn types are chosen; the old format had a very slow memory leak where mobs could get left outside of the garbage list.
 - fixed how NPCs navigate around obstacles.
 - thrown projectiles are no longer dense after being thrown.
 - Doppleganger can now target support npcs.
 - fixed how NPCs navigate around obstacles.
 - enemies can now target support npcs after initially spawning
 - tweaked shot_lineup()
 - enemies can no longer spawn on dense atoms.
 - enemies now have a death animation
 - enemies now move faster in later rounds.
 - clientside now renders at a silky smooth 100fps.
 - added more misc sound effects.
 - sound effects can now vary in frequency.
 - added screen effect when recieving damage.
 - bullets now have a sound effect when wizzing by a player.
 - Screen scaling added for resizable window.
 - Added support for fullscreen play.
 - Disabled reviving for deathmatch rounds.
 - Enabled wave variants again.
 - shotgun was buffed.
 - added a limit to how much blood can pool ontop of eachother.
 - lightning now has thunder to go with it
 - crossbow got buffed.
 - Dopple has a unique sound now.
 - Buffed the Uzi's fire rate
 - Cowbell makes a return
 - Glowsticks make a return
 - AK66 now doesn't suck. It's an automatic 3 round burst now.
 - Overhauled shield mechanics.
 - Laser Madness wave modifier returns
 - Nyan Madness wave modifier returns
 - Added a new weapon; SPAS-12
 - Fire overlays aren't effected by mob transformations anymore.
 - Descresed the maximum alpha for phantom enemies.
 - Fixed an issue where the spectate button would get stuck on disabled.
 - Added Fire Madness wave modifer; all projectiles are firebullets.
 - Vanity slot added to player overlays for further customization.
 - Added snow weather type.
 - Weather is dynamicly changed each wave.
 - Cleaned up the old vanity overlays.
 - Added an overlay indicator to show how many revives a player has.
 - Added a new map; Hallowed
 - Bosses now have tracking arrows.
 - added blue feeders
 - added petite feeders
 - fixed explosions
 - players with the most kills now get a crown overlay.
 - can now toggle who you're spectating with E.
 - projectiles no longer go hyperspeed when crossing d_ignore objects.
 - Blaze enemy added.
 - Shade enemy added.
 - improved the loot drop system.
 - Added a blaze_only wave modifier.
 - fixed an issue that would make only Abstracts spawn late-game.
 - added sudden death mode to pvp deathmatches.( missiles will consistently come down on a player's location.)
 - added missile_strike(turf) proc.
 - added hud display for the current wave.
 - added a fireblast special ability.
 - added bloodrain weather condition.
 - added slammer enemy (yut put)
 - shields now cap at 3 hits instead of 9.
 - dashing while idle will now make players jump in place.
 - added a few new vanity items.
 - finished the batman costume.

*/fects.
- fixed the layering of smudges
- Weapons are all much more responsive and fire rates are more accurately timed now.
- Wicked One got some hella buffs
- feed now runs at 60fps
- fixed a rare bug with doppelgangers not respawning properly.
- smudges are now on an appropriate layer.
- added credits
- added a fancy new main menu
- drop_shell is now a waitfor=0 proc so it won't bog down firing weapons.
- Wicked one damage and fire rate was buffed; also increased clip size to 15
- krossbow damage was buffed
- shortened cooldown for hopping in place.
- fixed the pants positioning for Deppelgangers.
- el verde now has a vendor icon.
- pause wouldn't pause intermission countdowns.
- new login bg.
- fixed the blank descriptions for certain vendor entrys.
- shirtless option no longer defaults to hoodies
- reload indicator now reflects the reloading progress
- new bullet visual variant for some guns(bullet2)
- new sound effects and music.
- all audio is now handled with the new audio handling.
- dashing now has a slight depth illusion now.
- rewrote the audio mechanics and got everything integrated with volume settings; just need to add the volume toggle.
---- see ( audio/audio_handling.dm ) for the new stuff.
- the color of ambient darkness is now determined by ambient_color
---- ambient_color is now randomly set every wave.
- day/night now supports tinted ambient darkness
- fixed a sound issue (NOTE: sound handling needs an overhaul)
- fixed the overlay offsets for vanity glasses
- clouds now vary in size
- splattering blood now makes a splat sound.
- broken shields now have a sound effect.
- nerfed alien movement speed a little and also lowered alien health pools.
- Rewrote how target arrows are handled. They now manage and remove themselves when appropriate. Simply add targets when you need to!
---- this was SOOOOO much more work than i was expecting lol
- Wicked One's burst rounds are now more tightly timed together.
- fixed the fullscreen offset for kills and cash.
- barrels now have a timer before detonating when detonated via explosion.
- shields now make you immune to smudges and stun
- smudges are now cleaned properly!


-----------------------------------------------------------------------------------------------------------------------------------------------------

				: old patch logs : //// list of ALLLLL the previous/old patch notes/changes. newest on top.


///////////////////////////////////////////////////////////////////////		comment breaks show where each patch started/ended.
 - fire now flickers
 - aliens are now back in the fray
 - smoke is a little more transcluscent.
 - non-boss Doppelgangars no longer stop game progression.
 - arrows that hit enemies now stay stuck to them
 - new weapon; wicked one - burst fire weapon
 - shields now glow
 - added new functionality to spotlights; edit_spotlight() will edit the provided variables of an existing spotlight in realtime
 - shields now extend your spotlight radius marginally with each upgrade.
 - New combat hit effects.
 - screenshake mechanic replaced with Yutty's
 - barricades now have a rolls var that will make them roll a little further when pushed.
 - shortened the time it takes to be portal'd.
 - fixed the bug where the fireproof buff animation would persist foreverrr.
 - revamped numerous stat/HUD icons.
 - Player healthbars now fade out when full.
 - El Verde finally has a weapon drop and can be aquired by players.
 - cap speed fro enemies is slower
 - medkits now heal players of burning debuffs.
 - smoke persists even longer now!
 - Portal casting is now bound to F
 - smoke now gets drawn over light; smoke effectively blots out light now.
 - portals now match the namecolor of whoever created it.
 - new portalling/teleportation animation
 - portals now knockback anything thats sitting in the receiving portal before sending something through.
 - added a depth effect to all thrown specials.
 - finished portal casting; shift+space to cast a portal.
 - added gibs for brutes, pukers, abstract1s, crawlers, and yeah
 - fire can now be put out by rain weather effects
 - explosions now have a larger spotlight.
 - fire spawning is a little more organic now.
 - fire now has a larger spotlight and fire now persists longer.
 - adjusted the spotlight positioning for a couple enemies.
 - added a new variable hit_streak(game/streaks.dm) that tracks the number of consecutive shots that hit a target.
  ---- this resets every game and whenever a bullet expires or hits a wall.
  ---- Can only get 1 kill streak point per projectile!
 - Spotlights now have adjustable sizes and intensity(alpha)
 - Krossbow now has a shorter reload time.
 - player step_size is now a saved variable.
 - player speed is now determined by their weapon.
 - everything is pixel scale'd now.
 - disabled the borked hitlag stuff (was causing the weird fps dips)
 - removed the bullet "whiz" sound effect.
 - vendor npcs now walk around
 - basic pistol now fires quicker.// NEED TO DO FOR THE REST oops caps
 - made a tweak to en_spawn() to help cutback on CPU load.
 - Flamethrower now spawns fire hazards.
 - Uzi now looses accuracy and increases fire rate the longer you hold the trigger.
 - last half of the red baron's clip now ignites enemies on fire.
 - critical_chance rate for players is now 5%
 - in-game chat is now a collapsable on-screen pane.
 - airstrikes are now sticky
 - explosions now sometimes drop fire hazards
 - flamethrowers now drop fire hazards
 - Feeder step size is now variable.
 - smoke clouds now persist longer
 - Enemy speed progression is now twice as slow.
 - Enemy respawn range was pushed back a little bit more.
 - Lysergia and Stalker both got substantial price increases.
 - trails for fire projectiles no longer get the owner's namecolor blending.
 - the last half of the Red Baron's clip now sets enemies ablaze.
 - fixed a rare runtime in misc/gengeneraldir.dm
 - more work on trumpen0r
 ---- shield of russia is causing issues; might just treat the shield of russia like a normal shield but let trump regenerate it through his AI.
 - added mr.trump the boss! still a wip!
 - added shield of russia; a new regen shield buff. (currently only for Trump boss)
 - fixed a bug where auto guns took two from the clip per shot
 - added a buncha new colorzzz
 - added a del marker for target arrows
 - temp disabled suport ai
 - Fixed a bug where kill counts would sometimes carry over between games.
 - Fixed a bug where some automatic weapons wouldn't asign owners to the projectiles they fired.
 - Projectile trails now match the color of their owner's name.
 - Doppel AI got a little improvement.
 - fixed a bug where non-boss doppels wouldn't subtract from the 'enemies_left' var when killed.
 - tweaked spawning mechanics a little.
 - fixed a rare minor runtime with weather effects.
 - gibs work again!
 - you can now hold to use autofire manual weapons with a slow wait.
 - removed the bounce effect from the UI elements
 - projectiles can no longer stack hits.
 - lowered the max speed for enemies
 - fixed an infinite loop in return_vspawn()
 --- This was the cause of the bug that prevented vendor intermissions from progressing!
 - Made improvements to the intermission handling in init_wave() (matchmaking.dm); now handles vendor intermissions natively!
 - Target arrows no longer point towards enemies on separate z levels.
 - Evacuate has destroyable chainlink fences!
 - Theatre now has hidden areas.
 - added new breakable environment pieces ( see environment/breakables.dm )
 - re-enabled the vendor intermissions.
 - Enemies can no longer target mobs on different z levels.
 - Evacuate now has building interiors.
 - added path waypoints so maps now have more flexibility.
 - fixed some overlays on objects in Theatre.
 - Northward edge spikes now hurt and knockback players properly.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 91. added a new special; Green smokebomb.
 90. added a new gun; El Verde
 89. added an alien only wave variant.
 88. added alien enemies.
 87. fixed a bug with puppet masters.
 86. Finished the arms for alien skin. Works in-game now. Just needs to be added via easter egg somehow.
 85. Made a new directory for boss enemies in enemies/bosses.
 ---- each boss type gets it's own .dm file with all relevant procs and definitions for ai and match handling stuff. (ex. see enemies/bosses/doppelganger.dm)
 84. Fixed the Doppelganger's teleport spawning so that he doesn't spawn far away from players anymore.
 83. ported in the Puppet Master enemy from Unwanted.
 ---- now spawns as a normal random wave spawn.
 82. added a stun mechanic.
 ---- players and enemies cxan be stunned when knockback'd into something dense or when taking heavy damage.
 81. added new variables for tracking other players and support ai on the screen
 	------   still need to remove arrows in some instances.
 80. support ai are now back in the fray and use a new awareness mechanic.
 79. more stuff use pixel_scale (weather and target arrows notably)
 78. chargers now get their variables reset at death.
 77. can now break crates by dashing into them.
 76. vendors are DONE!
 75. added a new gore variant for feeders
 74. enemies now have a slightly faster minimum movement speed.
 73. plugged in the fixes for ui_highlighting
 72. dying during intermission could sometimes cause negative revive totals. (fixed)
 71. boom markers stick around longer now.
 70. vanity and special vendors are added.
 69. closing vendors with the ui highlighting now sets the macros and move vars back to normal.
 68. face vendors now work.
 67. enemies now respawn when more than 15 tiles away from the closest player
 66. created an alient skin for players; still need to do arms and implement.
 65. hair vendor now has names and descriptions for all 26 options.
 64. Vendors and character creation now support controller input.
 63. Vendors now have their own spawn point lists.
 62. Hair options in the vendors now have prices.
 61. added a hair vendor, Winston
 60. Made a few new hair overlays.
 59. Made a bunch of new face overlays.
 58. Added Red Baron and Uzis to the weapon vendor.
 57. Player arms no longer show diagonal states when moving; only when shooting diagonally.
 56. Added Stalker and Lysergia to the weapon vendors.
 55. moved players/_Guns.dmi to game/vendors/guns.dmi
 54. added new weapons to the weapon vendor.
 53. deleted player/_Arms.dmi as player/arms.dmi replaced it.
 52. disabled support npcs.
 51. Added a new var for players, hair_lock.  If true, the player will not be able to customize their hair from the current settings.
 50. Micke now has a custom icon <------------------ if_hair_lock is true, the player cannot customize their hair.
 49. finished up more work on float text
 48. Loot can now be dropped on any movable atom; not just npcs.
 47. Doppelgangers now get recycled.
 46. Non-boss Doppels should now be fixed. ** hopefully **
 45. wooden crates that get broken have a chance to drop loot.
 44. Shopping Carts are now moveable barricades
 43. float text was rewritten and now behaves much differently.
 42. kett recieved some tweaks.
 41. players now gain cash.
 40. Every fifth wave is a long intermission now.
 39. added vendors to the game
 38. added new vanity items to the vanity vendor.
 37. Fixed the layering of player overlays.
 36. The Wave indicator now says "Intermission" during intermissions.
 35. made a few tweaks to Streetside.
 34. added a handful of new clothes and vanity affects.
 33. support npcs now have a chance to spawn at the start of every wave. they'll stay until they die.
 32. Enemies no longer spawn in view of players.
 31. Dashing no longer uses trigger_dir for steering (bug)
 30. Doppelgangers are back in the fray
 29. Doppelgangers can now be encountered during normal waves.
 28. Doppelgangers now use object recycling.
 27. added a pause mechanic for solo players.
 26. rewrote how the doppelganger's wave gets handled.
 25. fixed a rare runtime with sticky grenades.
 24. sprint goes further now
 23. bleeders no longer become immune after being culled.
 22. tick_lag now 0.25 and fps is now 40 to improve online performance/input response.
 21. added more to the pre recycle and pre recycle preloads 50 of everything now instead of 100.
 20. Started on stage 2 of Streetside.
 19. Revamped portal mechanics; still need to finish portal spawning and player portal skill================================================================
 18. Decreased the liklihood of creating Bleeders.
 17. added the new macro lists.
 16. removed the spectate toggle inject from the interact command. (finally!!)
 15. all macros are now broken into four separate lists; play; textinput; spectate; lobby
 14. fixed a bug where green smoke would sometimes spawn in place of normal smoke.
 13. Brutes received a HP buff.
 12. sticky bombs/grenades no longer lose their density when collected.
 11. scanlines now get drawn early.
 10. created player/overlay effects.dm
 17. revives tracker overlay is now under mob/var instead of a global var
 16. fixed macros for screenshots and gamepad setup
 15. fixed offsets for HUD elements.
 14. the lobby player list doesn't make blank fields for connecting players anymore.
 13. removed all maps except Streetside and Evacuate from map rotation.
 12. player preview icon when creating a character would have fucky arm offsets.
 11. item drops are now 32x32 states
 10. arms are now 64x64 states
 9. added a new gun; stalker
 8. Faces are now a unique overlay slot.
 7. ported a bunch of new interface and char creation stuff from Unwanted's build.
 6. designed a new reloading indicator.
 --- i'd like to eventually make this indicator a meter display that actually shows progress of reloading instead of a visual representation
 5. green sticky bombs now also create green smoke upon detonation!
 4. Improved the spread of the Lysergia.
 3. rewrote and condensed a bit of code pertaining to enemy spawning.
 2. enemy spawn progression is now randomized and the code in the spawnlist return proc was vastly condensed and improved.
 --- every five waves a random new enemy type is added to the spawnlist.
 1. enemies now have a spawn_rate variable that determines the liklihood of that enemy being included in a round's spawn mix.
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 - enemies gained every round is lower
 - created new legendary weapon, Lysergia.
 - added more blood/gore overlay variants for Feeders.
 - added a chance for the Wilhelm Scream to play when a player dies
 - blown up feeders now have a chance to become bleeders.
 - Bleeders no longer spawn on their own.
 - added a new enemy variant called a bleeder.-----------WIP!!
 - players now all have their movement frozen by default when not in-game.
 - fixed an issue with points and kills not updating (requires a wipe of old saves)
 - fixed an issue where sometimes spectators would get added before participants, resulting in spectators watching nobody.
 - SFX volume defaults to 70 now.
 - fixed character creation (Unwanted)
 - fixed a bug that wrecked havoc on everything(trying to parse /game through pl_spawn() )
 - fixed bug where censored wave modifiers would persist indefinitely.
 - spotlight alpha value is no longer effected by parent object's alpha. (mainly applies to phantom enemies getting almost invis spotlights)
 - F2 can now be used to take in-game screenshots.
 - new spawn progression setup is done.
 - Wave screen splashes are now condensed into a single proc to simplify code.
 - updated special weapons to be better organized and up-to-date with the new trigger setup.
 - player points at the end of a game now get transferred over to their career score.
 - players now gain points for killing enemies. (player/point handling.dm)
 - added explosive mines.
 - removed the flashing color wave modifier.
 - added a secret dev test map.
 - fixed the issue with E not spectating a new player fo first time clients.
 - died_already now defaults to 1 and should be 1 WHENEVER the player is not alive in-game.
 --- this includes when in lobby, logging in, etc.
 - removed all instances of ANIMATION_PARALLEL
 - client.fps is now set to world.fps
 - made a tweak to speed_modi()
 - enemies get faster/stronger over 10 waves instead of 5 now.
 - projectiles now move faster.
 - deathmatches happen on wave 15 and waves after now.
 - dopple spawns on wave 10 now.
 - removed the ak66 altogether.
 - made a new controls folder.
 - all guns now work with the new gun.
 - controller input is now filtered through the same trigger tracking as keyboard input.
 --- if controller_dir isn't null, the game will prioritize controller input and ignore keyboard triggers.
 - strafe movement is now a feature for all weapons(not just automatic) and is determined by trigger_dir.
 - trigger input has been completely rewritten and now supports dynamic input.
 - gamepad can now take custom control inputs (F5)
 - added gamepad support (Unwanted)
 - blue flash from blue fire now goes away when it's done.
 - fixed an issue that would cause player z_offsets to get fucked up.
 - Weapons can now be used diagonally.
 - New map, Evacuate is finally done.
 - Added a new boomerang variant; Kaboomerang.
 --- Causes an explosion on every enemy it hits.
 - Boomerangs now have a proper drop icon.
 - AI now stop running as soon as the game ends
 --- hopefully will fix the infamous random Dopple crash.
 - fixed a bug where the player's base would sometimes get drawn twice.
 - fixed an issue where loading hairstyles with offsets wouldn't apply the offsets
 - sticky grenades now have a throwing animation
 - boomerangs now have 0 density when returning to their thrower to avoid getting caugh up on obstacles.
 - bullet whiz sound effect now only plays for players that are 2px away instead of 5px
 - enemies that explode now also bloat in size before exploding.
 - added an animation effect for when players level up.
 - explosions now have a limit to how many gore particles they can drop.
 - the hurtflash effect is now drawn via client.color rather than screen objects.
 - removed the autofocus mechanism for toggling chat focus.
 - re-enabled score submission.
 - fixed a potential infinite loop in player spawning (Kaiochao)
 - enemy spawning has been cleaned up and improved.
 - playering spawning now gets handled the same across all spawning instances.
 --- spawn_pl(ref) handles this now.
 - draw_base() wasn't getting called when existing players logged in.
 - Support NPCs have been removed for the time being.
 - Brutes are a smidge faster.
 - Crawlers move a smidge slower.
 - vote to skip now requires majority vote.
 - players can no longer spawn ontop of eachother.
 - added a new list players that tracks ALL the players connected to the game. Only used for tracking!!!
 - rewrote and cleaned up a bit of code in matchmaking.dm
 - The UI/BaseObject now has the KEEP_TOGETHER appearance_flag.
 - made a small fix to the Expandable UI stuff.
 --- line 121, character creation.dm
 --- you didn't reset the expanded var to 0 when closing via the done button so if you reopened a section it would derp out.
 - added a new proc: speed_modifier()
 --- Enemies now have their speed derived from the matches' progression.
 - character creation has been implemented. (Unwanted4murder)
 - fixed a small bug for players that disconnect with a wave completion/starting overlay still on their screen.
 - fixed a bug where if a beholder or blaze only wave happened on wave 1, no enemies would spawn.
 - finished up savefile handling (see "player/savefiles.dm")
 - did a few adjustments to the pacing and intensity of the game. Enemies move a bit slower.
 - streetside map got a balancing adjustment,
 - buffed flamethrower a little. (FKI)
 - Improved the way NPCs handle weapons.
 - Dopplegangers can now dopple NPCs.
 -- need to set can_dopple = 1;  requires hair, shirt, pants, vanity variables.
 - Players who survive a Dopple round now get a third tier shield and 50exp.
 - buffed most enemies' health and adjusted some step delays.
 - POSSIBLY fixed the (bug) in the need to do section below.
 - Doppleganger no longer uses spawn before using weapons; seems to help with performance a little!
 -- should look into adding a hook for npcs in gun loops that lets them strafe a little.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 - added a new wave modifier for super dark waves: blackout.
 - players now gain 5 hp per level.
 - min/max lighting levels fluctuate every round now.
 - player nametag now updates when leveling up to reflect the new level.
 - players now gain experience from kills
 -- call give_exp(exp_to_give) to give exp to a player.
 - cleaned up a few old and outdated variables.
 - players no longer have a delay before taking explosive damage
 - adjusted the overlay color for player's level display.
 - fixed strafe-fire for automatic weapons.
 - basic shotgun now shoots 5 projectiles
 - enemy health now scales with waves. (formula = base_health+round(current_round*3))
 - projectiles now have a chance to pierce through enemies.
 - finished the flamethrower.
 - made a few graphic tweaks.
 - game settings now has a PvP variable. Will be used more in coming features.
 -- this variable also made the deathmatch variable obsolete so it was replaced.
 - player bullets now ignore support npcs unless the match is set to PvP.
 - added a few new clothing variants (unwanted4murder)
 - added new support NPCs: Steve and Blue (unwanted4murder)
 - improved the revive overlay indicator
 - added an overlay when getting health or a revive
 - blood drops significantly faster.
 - in rare cases targetting arrows wouldn't get drawn for the last five enemies of a wave.
 - blood drops faster now.
 - shotguns now spread evenly in a cone pattern.
 - more blood!
 - weather is dynamic again.
 - made an optimization tweak with weather animations.
 - cowbells now attract enemies instead of making them ignore the user.
 - support npcs no longer hurt players with their explosions.
 - GMs now have an indicator on their nametag.
 - Item pickup text is now colored!
 - Removed the safe time after recieving damage for players and enemies.
 - added a new wave modifier; trippy_mane
 - fixed a performance hiccup in health loops.
 - fixed a memory leak where projectiles wouldn't stop stepping even after being collected.
 - world tick_lag is now 2 instead of 0.2
 - fixed issue where target arrows wouldn't be removed from Dopples or players.
 - fixed issue where changing who you spectate caused blackscreens.
 - fixed a misplaced var ref in Charger's explosions that was causing havoc everywhere.
 - when playing alone on a server, disconnecting before a wave started would cause the game to idle in its current state with no players.
 - fixed a typo that would cause players not to be removed from the proper lists when they would disconnect.
 - fixed an issue where enemies wouldn't be able to respawn.
 - fixed an issue with top_player stuff not getting removed.
 - portals no longer close
 - Being killed by the Dopple would not remove the target arrows.
 - grenades no longer remain dense after being thrown.
 - doppleganger now mimics vanity items
 - added framework for friendly support npcs.
 - Kett is the first of the support NPCs
 - removed buffer_x/y from screen scaling caluclations as it wasn't used.
 - disabled map scale to fit.
 - improved friendly ai.
 - support ai now get revived each wave.
 - rewrote how enemy spawn types are chosen; the old format had a very slow memory leak where mobs could get left outside of the garbage list.
 - fixed how NPCs navigate around obstacles.
 - thrown projectiles are no longer dense after being thrown.
 - Doppleganger can now target support npcs.
 - fixed how NPCs navigate around obstacles.
 - enemies can now target support npcs after initially spawning
 - tweaked shot_lineup()
 - enemies can no longer spawn on dense atoms.
 - enemies now have a death animation
 - enemies now move faster in later rounds.
 - clientside now renders at a silky smooth 100fps.
 - added more misc sound effects.
 - sound effects can now vary in frequency.
 - added screen effect when recieving damage.
 - bullets now have a sound effect when wizzing by a player.
 - Screen scaling added for resizable window.
 - Added support for fullscreen play.
 - Disabled reviving for deathmatch rounds.
 - Enabled wave variants again.
 - shotgun was buffed.
 - added a limit to how much blood can pool ontop of eachother.
 - lightning now has thunder to go with it
 - crossbow got buffed.
 - Dopple has a unique sound now.
 - Buffed the Uzi's fire rate
 - Cowbell makes a return
 - Glowsticks make a return
 - AK66 now doesn't suck. It's an automatic 3 round burst now.
 - Overhauled shield mechanics.
 - Laser Madness wave modifier returns
 - Nyan Madness wave modifier returns
 - Added a new weapon; SPAS-12
 - Fire overlays aren't effected by mob transformations anymore.
 - Descresed the maximum alpha for phantom enemies.
 - Fixed an issue where the spectate button would get stuck on disabled.
 - Added Fire Madness wave modifer; all projectiles are firebullets.
 - Vanity slot added to player overlays for further customization.
 - Added snow weather type.
 - Weather is dynamicly changed each wave.
 - Cleaned up the old vanity overlays.
 - Added an overlay indicator to show how many revives a player has.
 - Added a new map; Hallowed
 - Bosses now have tracking arrows.
 - added blue feeders
 - added petite feeders
 - fixed explosions
 - players with the most kills now get a crown overlay.
 - can now toggle who you're spectating with E.
 - projectiles no longer go hyperspeed when crossing d_ignore objects.
 - Blaze enemy added.
 - Shade enemy added.
 - improved the loot drop system.
 - Added a blaze_only wave modifier.
 - fixed an issue that would make only Abstracts spawn late-game.
 - added sudden death mode to pvp deathmatches.( missiles will consistently come down on a player's location.)
 - added missile_strike(turf) proc.
 - added hud display for the current wave.
 - added a fireblast special ability.
 - added bloodrain weather condition.
 - added slammer enemy (yut put)
 - shields now cap at 3 hits instead of 9.
 - dashing while idle will now make players jump in place.
 - added a few new vanity items.
 - finished the batman costume.

*/