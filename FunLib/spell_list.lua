local X = {}

X['spells'] = {
    ['abaddon_death_coil'] = {weight = 0.8, hero = 'npc_dota_hero_abaddon'},
    ['abaddon_aphotic_shield'] = {weight = 0.8, hero = 'npc_dota_hero_abaddon'},

    ['abyssal_underlord_firestorm'] = {weight = 0.5, hero = 'npc_dota_hero_abyssal_underlord'},
    ['abyssal_underlord_pit_of_malice'] = {weight = 0.5, hero = 'npc_dota_hero_abyssal_underlord'},
    ['abyssal_underlord_dark_portal'] = {weight = 0.9, hero = 'npc_dota_hero_abyssal_underlord'},

    ['alchemist_acid_spray'] = {weight = 0.6, hero = 'npc_dota_hero_alchemist'},
    ['alchemist_unstable_concoction'] = {weight = 0.8, hero = 'npc_dota_hero_alchemist'},
    ['alchemist_unstable_concoction_throw'] = {weight = 0.8, hero = 'npc_dota_hero_alchemist'},
    ['alchemist_berserk_potion'] = {weight = 0.8, hero = 'npc_dota_hero_alchemist'},
    ['alchemist_chemical_rage'] = {weight = 0.9, hero = 'npc_dota_hero_alchemist'},

    ['ancient_apparition_cold_feet'] = {weight = 0.7, hero = 'npc_dota_hero_ancient_apparition'},
    ['ancient_apparition_ice_vortex'] = {weight = 0.6, hero = 'npc_dota_hero_ancient_apparition'},
    ['ancient_apparition_chilling_touch'] = {weight = 1, hero = 'npc_dota_hero_ancient_apparition'},
    ['ancient_apparition_ice_blast'] = {weight = 0.3, hero = 'npc_dota_hero_ancient_apparition'},
    ['ancient_apparition_ice_blast_release'] = {weight = 0.3, hero = 'npc_dota_hero_ancient_apparition'},

    ['antimage_blink'] = {weight = 0.5, hero = 'npc_dota_hero_antimage'},
    ['antimage_counterspell'] = {weight = 0.8, hero = 'npc_dota_hero_antimage'},
    ['antimage_counterspell_ally'] = {weight = 0.9, hero = 'npc_dota_hero_antimage'},
    -- ['antimage_mana_overload'] = {weight = 1, hero = 'npc_dota_hero_antimage'},
    ['antimage_mana_void'] = {weight = 0.5, hero = 'npc_dota_hero_antimage'},

    ['arc_warden_flux'] = {weight = 0.6, hero = 'npc_dota_hero_arc_warden'},
    ['arc_warden_magnetic_field'] = {weight = 0.9, hero = 'npc_dota_hero_arc_warden'},
    ['arc_warden_spark_wraith'] = {weight = 0.9, hero = 'npc_dota_hero_arc_warden'},
    ['arc_warden_tempest_double'] = {weight = 1, hero = 'npc_dota_hero_arc_warden'},

    ['axe_berserkers_call'] = {weight = 1, hero = 'npc_dota_hero_axe'},
    ['axe_battle_hunger'] = {weight = 0.8, hero = 'npc_dota_hero_axe'},
    ['axe_culling_blade'] = {weight = 0.2, hero = 'npc_dota_hero_axe'},

    ['bane_enfeeble'] = {weight = 0.5, hero = 'npc_dota_hero_bane'},
    ['bane_brain_sap'] = {weight = 0.5, hero = 'npc_dota_hero_bane'},
    ['bane_nightmare'] = {weight = 0.2, hero = 'npc_dota_hero_bane'},
    ['bane_fiends_grip'] = {weight = 0, hero = 'npc_dota_hero_bane'},

    ['batrider_sticky_napalm'] = {weight = 1, hero = 'npc_dota_hero_batrider'},
    ['batrider_flamebreak'] = {weight = 0.9, hero = 'npc_dota_hero_batrider'},
    ['batrider_firefly'] = {weight = 0.9, hero = 'npc_dota_hero_batrider'},
    ['batrider_flaming_lasso'] = {weight = 0.1, hero = 'npc_dota_hero_batrider'},

    ['beastmaster_wild_axes'] = {weight = 0.4, hero = 'npc_dota_hero_beastmaster'},
    ['beastmaster_call_of_the_wild_boar'] = {weight = 1, hero = 'npc_dota_hero_beastmaster'},
    ['beastmaster_call_of_the_wild_hawk'] = {weight = 1, hero = 'npc_dota_hero_beastmaster'},
    ['beastmaster_primal_roar'] = {weight = 0},

    ['bloodseeker_bloodrage'] = {weight = 1, hero = 'npc_dota_hero_bloodseeker'},
    ['bloodseeker_blood_bath'] = {weight = 0.9, hero = 'npc_dota_hero_bloodseeker'},
    ['bloodseeker_blood_mist'] = {weight = 1, hero = 'npc_dota_hero_bloodseeker'},
    ['bloodseeker_rupture'] = {weight = 0.3, hero = 'npc_dota_hero_bloodseeker'},

    ['bounty_hunter_shuriken_toss'] = {weight = 0.7, hero = 'npc_dota_hero_bounty_hunter'},
    ['bounty_hunter_jinada'] = {weight = 1, hero = 'npc_dota_hero_bounty_hunter'},
    ['bounty_hunter_wind_walk'] = {weight = 0.5, hero = 'npc_dota_hero_bounty_hunter'},
    ['bounty_hunter_wind_walk_ally'] = {weight = 6, hero = 'npc_dota_hero_bounty_hunter'},
    ['bounty_hunter_track'] = {weight = 1, hero = 'npc_dota_hero_bounty_hunter'},

    ['brewmaster_thunder_clap'] = {weight = 0.7, hero = 'npc_dota_hero_brewmaster'},
    ['brewmaster_cinder_brew'] = {weight = 0.7, hero = 'npc_dota_hero_brewmaster'},
    ['brewmaster_drunken_brawler'] = {weight = 1, hero = 'npc_dota_hero_brewmaster'},
    ['brewmaster_primal_companion'] = {weight = 1, hero = 'npc_dota_hero_brewmaster'},
    ['brewmaster_primal_split'] = {weight = 1, hero = 'npc_dota_hero_brewmaster'},

    ['bristleback_viscous_nasal_goo'] = {weight = 0.6, hero = 'npc_dota_hero_bristleback'},
    ['bristleback_quill_spray'] = {weight = 1, hero = 'npc_dota_hero_bristleback'},
    ['bristleback_bristleback'] = {weight = 0.9, hero = 'npc_dota_hero_bristleback'},
    ['bristleback_hairball'] = {weight = 0.5, hero = 'npc_dota_hero_bristleback'},

    ['broodmother_insatiable_hunger'] = {weight = 0.8, hero = 'npc_dota_hero_broodmother'},
    ['broodmother_spin_web'] = {weight = 1, hero = 'npc_dota_hero_broodmother'},
    ['broodmother_silken_bola'] = {weight = 0.5, hero = 'npc_dota_hero_broodmother'},
    ['broodmother_sticky_snare'] = {weight = 1, hero = 'npc_dota_hero_broodmother'},
    ['broodmother_spawn_spiderlings'] = {weight = 1, hero = 'npc_dota_hero_broodmother'},

    ['centaur_hoof_stomp'] = {weight = 0.7, hero = 'npc_dota_hero_centaur'},
    ['centaur_double_edge'] = {weight = 1, hero = 'npc_dota_hero_centaur'},
    ['centaur_mount'] = {weight = 1, hero = 'npc_dota_hero_centaur'},
    ['centaur_work_horse'] = {weight = 0.2, hero = 'npc_dota_hero_centaur'},
    ['centaur_stampede'] = {weight = 0.1, hero = 'npc_dota_hero_centaur'},

    ['chaos_knight_chaos_bolt'] = {weight = 0.4, hero = 'npc_dota_hero_chaos_knight'},
    ['chaos_knight_reality_rift'] = {weight = 0.8, hero = 'npc_dota_hero_chaos_knight'},
    ['chaos_knight_phantasm'] = {weight = 1, hero = 'npc_dota_hero_chaos_knight'},

    ['chen_penitence'] = {weight = 0.1, hero = 'npc_dota_hero_chen'},
    ['chen_holy_persuasion'] = {weight = 1, hero = 'npc_dota_hero_chen'},
    ['chen_divine_favor'] = {weight = 0.1, hero = 'npc_dota_hero_chen'},
    ['chen_summon_convert'] = {weight = 1, hero = 'npc_dota_hero_chen'},
    ['chen_hand_of_god'] = {weight = 0.2, hero = 'npc_dota_hero_chen'},

    ['clinkz_strafe'] = {weight = 0.9, hero = 'npc_dota_hero_clinkz'},
    ['clinkz_tar_bomb'] = {weight = 0.8, hero = 'npc_dota_hero_clinkz'},
    ['clinkz_death_pact'] = {weight = 0.9, hero = 'npc_dota_hero_clinkz'},
    ['clinkz_burning_barrage'] = {weight = 0.9, hero = 'npc_dota_hero_clinkz'},
    ['clinkz_burning_army'] = {weight = 0.9, hero = 'npc_dota_hero_clinkz'},
    ['clinkz_wind_walk'] = {weight = 0.7, hero = 'npc_dota_hero_clinkz'},

    ['crystal_maiden_crystal_nova'] = {weight = 0.6, hero = 'npc_dota_hero_crystal_maiden'},
    ['crystal_maiden_frostbite'] = {weight = 0.5, hero = 'npc_dota_hero_crystal_maiden'},
    ['crystal_maiden_crystal_clone'] = {weight = 1, hero = 'npc_dota_hero_crystal_maiden'},
    ['crystal_maiden_freezing_field'] = {weight = 0.1, hero = 'npc_dota_hero_crystal_maiden'},

    ['dark_seer_vacuum'] = {weight = 0.3, hero = 'npc_dota_hero_dark_seer'},
    ['dark_seer_ion_shell'] = {weight = 0.8, hero = 'npc_dota_hero_dark_seer'},
    ['dark_seer_surge'] = {weight = 0.5, hero = 'npc_dota_hero_dark_seer'},
    ['dark_seer_wall_of_replica'] = {weight = 0.1, hero = 'npc_dota_hero_dark_seer'},

    ['dawnbreaker_fire_wreath'] = {weight = 0.8, hero = 'npc_dota_hero_dawnbreaker'},
    ['dawnbreaker_celestial_hammer'] = {weight = 0.4, hero = 'npc_dota_hero_dawnbreaker'},
    ['dawnbreaker_converge'] = {weight = 1, hero = 'npc_dota_hero_dawnbreaker'},
    ['dawnbreaker_solar_guardian'] = {weight = 0.7, hero = 'npc_dota_hero_dawnbreaker'},

    ['dazzle_poison_touch'] = {weight = 0.7, hero = 'npc_dota_hero_dazzle'},
    ['dazzle_shallow_grave'] = {weight = 0.1, hero = 'npc_dota_hero_dazzle'},
    ['dazzle_shadow_wave'] = {weight = 0.6, hero = 'npc_dota_hero_dazzle'},
    ['dazzle_bad_juju'] = {weight = 0.8, hero = 'npc_dota_hero_dazzle'},

    ['death_prophet_carrion_swarm'] = {weight = 0.7, hero = 'npc_dota_hero_death_prophet'},
    ['death_prophet_silence'] = {weight = 0.2, hero = 'npc_dota_hero_death_prophet'},
    ['death_prophet_spirit_siphon'] = {weight = 0.8, hero = 'npc_dota_hero_death_prophet'},
    ['death_prophet_exorcism'] = {weight = 0.4, hero = 'npc_dota_hero_death_prophet'},

    ['disruptor_thunder_strike'] = {weight = 0.6, hero = 'npc_dota_hero_disruptor'},
    ['disruptor_glimpse'] = {weight = 0.3, hero = 'npc_dota_hero_disruptor'},
    ['disruptor_kinetic_field'] = {weight = 0.3, hero = 'npc_dota_hero_disruptor'},
    ['disruptor_static_storm'] = {weight = 0.1, hero = 'npc_dota_hero_disruptor'},

    ['doom_bringer_devour'] = {weight = 0.9, hero = 'npc_dota_hero_doom_bringer'},
    ['doom_bringer_scorched_earth'] = {weight = 0.8, hero = 'npc_dota_hero_doom_bringer'},
    ['doom_bringer_infernal_blade'] = {weight = 0.9, hero = 'npc_dota_hero_doom_bringer'},
    ['doom_bringer_doom'] = {weight = 0.2, hero = 'npc_dota_hero_doom_bringer'},

    ['dragon_knight_breathe_fire'] = {weight = 0.7, hero = 'npc_dota_hero_dragon_knight'},
    ['dragon_knight_dragon_tail'] = {weight = 0.5, hero = 'npc_dota_hero_dragon_knight'},
    ['dragon_knight_fireball'] = {weight = 0.7, hero = 'npc_dota_hero_dragon_knight'},
    ['dragon_knight_elder_dragon_form'] = {weight = 0.5, hero = 'npc_dota_hero_dragon_knight'},

    ['drow_ranger_frost_arrows'] = {weight = 1, hero = 'npc_dota_hero_drow_ranger'},
    ['drow_ranger_wave_of_silence'] = {weight = 0.3, hero = 'npc_dota_hero_drow_ranger'},
    ['drow_ranger_multishot'] = {weight = 0.9, hero = 'npc_dota_hero_drow_ranger'},
    ['drow_ranger_glacier'] = {weight = 0.7, hero = 'npc_dota_hero_drow_ranger'},

    ['earth_spirit_boulder_smash'] = {weight = 0.6, hero = 'npc_dota_hero_earth_spirit'},
    ['earth_spirit_rolling_boulder'] = {weight = 0.3, hero = 'npc_dota_hero_earth_spirit'},
    ['earth_spirit_geomagnetic_grip'] = {weight = 1, hero = 'npc_dota_hero_earth_spirit'},
    ['earth_spirit_petrify'] = {weight = 1, hero = 'npc_dota_hero_earth_spirit'},
    ['earth_spirit_stone_caller'] = {weight = 0.9, hero = 'npc_dota_hero_earth_spirit'},
    ['earth_spirit_magnetize'] = {weight = 0.2, hero = 'npc_dota_hero_earth_spirit'},

    ['earthshaker_fissure'] = {weight = 0, hero = 'npc_dota_hero_earthshaker'},
    ['earthshaker_enchant_totem'] = {weight = 1, hero = 'npc_dota_hero_earthshaker'},
    ['earthshaker_echo_slam'] = {weight = 0.1, hero = 'npc_dota_hero_earthshaker'},

    ['ember_spirit_searing_chains'] = {weight = 0.7, hero = 'npc_dota_hero_ember_spirit'},
    ['ember_spirit_sleight_of_fist'] = {weight = 0.9, hero = 'npc_dota_hero_ember_spirit'},
    ['ember_spirit_flame_guard'] = {weight = 0.8, hero = 'npc_dota_hero_ember_spirit'},
    ['ember_spirit_activate_fire_remnant'] = {weight = 1, hero = 'npc_dota_hero_ember_spirit'},
    ['ember_spirit_fire_remnant'] = {weight = 1, hero = 'npc_dota_hero_ember_spirit'},

    ['enchantress_impetus'] = {weight = 1, hero = 'npc_dota_hero_enchantress'},
    ['enchantress_enchant'] = {weight = 1, hero = 'npc_dota_hero_enchantress'},
    ['enchantress_natures_attendants'] = {weight = 0.5, hero = 'npc_dota_hero_enchantress'},
    ['enchantress_bunny_hop'] = {weight = 0.9, hero = 'npc_dota_hero_enchantress'},
    ['enchantress_little_friends'] = {weight = 1, hero = 'npc_dota_hero_enchantress'},

    ['enigma_malefice'] = {weight = 0.8, hero = 'npc_dota_hero_enigma'},
    ['enigma_demonic_conversion'] = {weight = 1, hero = 'npc_dota_hero_enigma'},
    ['enigma_midnight_pulse'] = {weight = 0.6, hero = 'npc_dota_hero_enigma'},
    ['enigma_black_hole'] = {weight = 0.1, hero = 'npc_dota_hero_enigma'},

    ['faceless_void_time_walk'] = {weight = 0.5, hero = 'npc_dota_hero_faceless_void'},
    ['faceless_void_time_dilation'] = {weight = 0.8, hero = 'npc_dota_hero_faceless_void'},
    ['faceless_void_time_walk_reverse'] = {weight = 1, hero = 'npc_dota_hero_faceless_void'},
    ['faceless_void_chronosphere'] = {weight = 0.1, hero = 'npc_dota_hero_faceless_void'},

    ['furion_sprout'] = {weight = 0.1, hero = 'npc_dota_hero_furion'},
    ['furion_teleportation'] = {weight = 0.5, hero = 'npc_dota_hero_furion'},
    ['furion_force_of_nature'] = {weight = 0.8, hero = 'npc_dota_hero_furion'},
    ['furion_curse_of_the_forest'] = {weight = 0.3, hero = 'npc_dota_hero_furion'},
    ['furion_wrath_of_nature'] = {weight = 0.7, hero = 'npc_dota_hero_furion'},

    --[[1]] ['grimstroke_dark_artistry'] = {weight = 0.5, hero = 'npc_dota_hero_grimstroke'},
    --[[2]] ['grimstroke_ink_creature'] = {weight = 0.3, hero = 'npc_dota_hero_grimstroke'},
    --[[3]] ['grimstroke_spirit_walk'] = {weight = 0.5, hero = 'npc_dota_hero_grimstroke'},
    --[[4]] ['grimstroke_dark_portrait'] = {weight = 0.2, hero = 'npc_dota_hero_grimstroke'},
    --[[5]] ['grimstroke_return'] = {weight = 1, hero = 'npc_dota_hero_grimstroke'},
    --[[6]] ['grimstroke_soul_chain'] = {weight = 0.2, hero = 'npc_dota_hero_grimstroke'},

    --[[1]] ['gyrocopter_rocket_barrage'] = {weight = 0.8, hero = 'npc_dota_hero_gyrocopter'},
    --[[2]] ['gyrocopter_homing_missile'] = {weight = 0.3, hero = 'npc_dota_hero_gyrocopter'},
    --[[3]] ['gyrocopter_flak_cannon'] = {weight = 0.9, hero = 'npc_dota_hero_gyrocopter'},
    --[[6]] ['gyrocopter_call_down'] = {weight = 0.6, hero = 'npc_dota_hero_gyrocopter'},

    --[[1]] ['huskar_inner_fire'] = {weight = 0.5, hero = 'npc_dota_hero_huskar'},
    --[[2]] ['huskar_burning_spear'] = {weight = 1, hero = 'npc_dota_hero_huskar'},
    --[[6]] ['huskar_life_break'] = {weight = 1, hero = 'npc_dota_hero_huskar'},



    --[[1]] ['mars_spear'] = {weight = 0.1, hero = 'npc_dota_hero_mars'},
    --[[2]] ['mars_gods_rebuke'] = {weight = 0.8, hero = 'npc_dota_hero_mars'},
    --[[3]] ['mars_bulwark'] = {weight = 1, hero = 'npc_dota_hero_mars'},
    --[[6]] ['mars_arena_of_blood'] = {weight = 0.2, hero = 'npc_dota_hero_mars'},

    --[[1]] ['muerta_dead_shot'] = {weight = 0.8, hero = 'npc_dota_hero_muerta'},
    --[[2]] ['muerta_the_calling'] = {weight = 0.5, hero = 'npc_dota_hero_muerta'},
    --[[3]] ['muerta_gunslinger'] = {weight = 1, hero = 'npc_dota_hero_muerta'},
    --[[4]] ['muerta_parting_shot'] = {weight = 0.5, hero = 'npc_dota_hero_muerta'},
    --[[6]] ['muerta_pierce_the_veil'] = {weight = 0.9, hero = 'npc_dota_hero_muerta'},

    -- --[[4]] ['rubick_empty1'] = {weight = 1},
    -- --[[5]] ['rubick_empty2'] = {weight = 1},
}

function X.GetSpellReplaceWeight(ability)
    if X['spells'][ability] == nil then return 1 end
    return X['spells'][ability].weight
end

function X.GetSpellHeroName(ability)
    if X['spells'][ability] == nil then return nil end
    return X['spells'][ability].hero
end

return X