local X = {}

X['spells'] = {
    ['abaddon_death_coil'] = {weight = 0.8},
    ['abaddon_aphotic_shield'] = {weight = 0.8},

    ['abyssal_underlord_firestorm'] = {weight = 0.5},
    ['abyssal_underlord_pit_of_malice'] = {weight = 0.5},
    ['abyssal_underlord_dark_portal'] = {weight = 0.9},

    ['alchemist_acid_spray'] = {weight = 0.6},
    ['alchemist_unstable_concoction'] = {weight = 0.8},
    ['alchemist_unstable_concoction_throw'] = {weight = 0.8},
    ['alchemist_berserk_potion'] = {weight = 0.8},
    ['alchemist_chemical_rage'] = {weight = 0.9},

    ['ancient_apparition_cold_feet'] = {weight = 0.7},
    ['ancient_apparition_ice_vortex'] = {weight = 0.6},
    ['ancient_apparition_chilling_touch'] = {weight = 1},
    ['ancient_apparition_ice_blast'] = {weight = 0.3},
    ['ancient_apparition_ice_blast_release'] = {weight = 0.3},

    ['antimage_blink'] = {weight = 0.5},
    ['antimage_counterspell'] = {weight = 0.8},
    ['antimage_counterspell_ally'] = {weight = 0.9},
    ['antimage_mana_overload'] = {weight = 1},
    ['antimage_mana_void'] = {weight = 0.5},

    ['arc_warden_flux'] = {weight = 0.6},
    ['arc_warden_magnetic_field'] = {weight = 0.9},
    ['arc_warden_spark_wraith'] = {weight = 0.9},
    ['arc_warden_tempest_double'] = {weight = 1},

    ['axe_berserkers_call'] = {weight = 1},
    ['axe_battle_hunger'] = {weight = 0.8},
    ['axe_culling_blade'] = {weight = 0.2},

    ['bane_enfeeble'] = {weight = 0.5},
    ['bane_brain_sap'] = {weight = 0.5},
    ['bane_nightmare'] = {weight = 0.2},
    ['bane_fiends_grip'] = {weight = 0},

    ['batrider_sticky_napalm'] = {weight = 1},
    ['batrider_flamebreak'] = {weight = 0.9},
    ['batrider_firefly'] = {weight = 0.9},
    ['batrider_flaming_lasso'] = {weight = 0.1},

    ['beastmaster_wild_axes'] = {weight = 0.4},
    ['beastmaster_call_of_the_wild_boar'] = {weight = 1},
    ['beastmaster_call_of_the_wild_hawk'] = {weight = 1},
    ['beastmaster_primal_roar'] = {weight = 0},

    ['bloodseeker_bloodrage'] = {weight = 1},
    ['bloodseeker_blood_bath'] = {weight = 0.9},
    ['bloodseeker_blood_mist'] = {weight = 1},
    ['bloodseeker_rupture'] = {weight = 0.3},

    ['bounty_hunter_shuriken_toss'] = {weight = 0.7},
    ['bounty_hunter_jinada'] = {weight = 1},
    ['bounty_hunter_wind_walk'] = {weight = 0.5},
    ['bounty_hunter_wind_walk_ally'] = {weight = 6},
    ['bounty_hunter_track'] = {weight = 1},

    ['brewmaster_thunder_clap'] = {weight = 0.7},
    ['brewmaster_cinder_brew'] = {weight = 0.7},
    ['brewmaster_drunken_brawler'] = {weight = 1},
    ['brewmaster_primal_companion'] = {weight = 1},
    ['brewmaster_primal_split'] = {weight = 1},

    ['bristleback_viscous_nasal_goo'] = {weight = 0.6},
    ['bristleback_quill_spray'] = {weight = 1},
    ['bristleback_bristleback'] = {weight = 0.9},
    ['bristleback_hairball'] = {weight = 0.5},

    ['broodmother_insatiable_hunger'] = {weight = 0.8},
    ['broodmother_spin_web'] = {weight = 1},
    ['broodmother_silken_bola'] = {weight = 0.5},
    ['broodmother_sticky_snare'] = {weight = 1},
    ['broodmother_spawn_spiderlings'] = {weight = 1},

    ['centaur_hoof_stomp'] = {weight = 0.7},
    ['centaur_double_edge'] = {weight = 1},
    ['centaur_mount'] = {weight = 1},
    ['centaur_work_horse'] = {weight = 0.2},
    ['centaur_stampede'] = {weight = 0.1},

    ['chaos_knight_chaos_bolt'] = {weight = 0.4},
    ['chaos_knight_reality_rift'] = {weight = 0.8},
    ['chaos_knight_phantasm'] = {weight = 1},

    ['chen_penitence'] = {weight = 0.1},
    ['chen_holy_persuasion'] = {weight = 1},
    ['chen_divine_favor'] = {weight = 0.1},
    ['chen_summon_convert'] = {weight = 1},
    ['chen_hand_of_god'] = {weight = 0.2},

    ['clinkz_strafe'] = {weight = 0.9},
    ['clinkz_tar_bomb'] = {weight = 0.8},
    ['clinkz_death_pact'] = {weight = 0.9},
    ['clinkz_burning_barrage'] = {weight = 0.9},
    ['clinkz_burning_army'] = {weight = 0.9},
    ['clinkz_wind_walk'] = {weight = 0.7},

    ['crystal_maiden_crystal_nova'] = {weight = 0.6},
    ['crystal_maiden_frostbite'] = {weight = 0.5},
    ['crystal_maiden_crystal_clone'] = {weight = 1},
    ['crystal_maiden_freezing_field'] = {weight = 0.1},

    ['dark_seer_vacuum'] = {weight = 0.3},
    ['dark_seer_ion_shell'] = {weight = 0.8},
    ['dark_seer_surge'] = {weight = 0.5},
    ['dark_seer_wall_of_replica'] = {weight = 0.1},

    ['dawnbreaker_fire_wreath'] = {weight = 0.8},
    ['dawnbreaker_celestial_hammer'] = {weight = 0.4},
    ['dawnbreaker_converge'] = {weight = 1},
    ['dawnbreaker_solar_guardian'] = {weight = 0.7},

    ['dazzle_poison_touch'] = {weight = 0.7},
    ['dazzle_shallow_grave'] = {weight = 0.1},
    ['dazzle_shadow_wave'] = {weight = 0.6},
    ['dazzle_bad_juju'] = {weight = 0.8},

    ['death_prophet_carrion_swarm'] = {weight = 0.7},
    ['death_prophet_silence'] = {weight = 0.2},
    ['death_prophet_spirit_siphon'] = {weight = 0.8},
    ['death_prophet_exorcism'] = {weight = 0.4},

    ['disruptor_thunder_strike'] = {weight = 0.6},
    ['disruptor_glimpse'] = {weight = 0.3},
    ['disruptor_kinetic_field'] = {weight = 0.3},
    ['disruptor_static_storm'] = {weight = 0.1},

    ['doom_bringer_devour'] = {weight = 0.9},
    ['doom_bringer_scorched_earth'] = {weight = 0.8},
    ['doom_bringer_infernal_blade'] = {weight = 0.9},
    ['doom_bringer_doom'] = {weight = 0.2},

    ['dragon_knight_breathe_fire'] = {weight = 0.7},
    ['dragon_knight_dragon_tail'] = {weight = 0.5},
    ['dragon_knight_fireball'] = {weight = 0.7},
    ['dragon_knight_elder_dragon_form'] = {weight = 0.5},

    ['drow_ranger_frost_arrows'] = {weight = 1},
    ['drow_ranger_wave_of_silence'] = {weight = 0.3},
    ['drow_ranger_multishot'] = {weight = 0.9},
    ['drow_ranger_glacier'] = {weight = 0.7},

    ['earth_spirit_boulder_smash'] = {weight = 0.6},
    ['earth_spirit_rolling_boulder'] = {weight = 0.3},
    ['earth_spirit_geomagnetic_grip'] = {weight = 1},
    ['earth_spirit_petrify'] = {weight = 1},
    ['earth_spirit_stone_caller'] = {weight = 0.9},
    ['earth_spirit_magnetize'] = {weight = 0.2},

    ['earthshaker_fissure'] = {weight = 0},
    ['earthshaker_enchant_totem'] = {weight = 1},
    ['earthshaker_echo_slam'] = {weight = 0.1},

    ['ember_spirit_searing_chains'] = {weight = 0.7},
    ['ember_spirit_sleight_of_fist'] = {weight = 0.9},
    ['ember_spirit_flame_guard'] = {weight = 0.8},
    ['ember_spirit_activate_fire_remnant'] = {weight = 1},
    ['ember_spirit_fire_remnant'] = {weight = 1},

    ['enchantress_impetus'] = {weight = 1},
    ['enchantress_enchant'] = {weight = 1},
    ['enchantress_natures_attendants'] = {weight = 0.5},
    ['enchantress_bunny_hop'] = {weight = 0.9},
    ['enchantress_little_friends'] = {weight = 1},

    ['enigma_malefice'] = {weight = 0.8},
    ['enigma_demonic_conversion'] = {weight = 1},
    ['enigma_midnight_pulse'] = {weight = 0.6},
    ['enigma_black_hole'] = {weight = 0.1},

    ['faceless_void_time_walk'] = {weight = 0.5},
    ['faceless_void_time_dilation'] = {weight = 0.8},
    ['faceless_void_time_walk_reverse'] = {weight = 1},
    ['faceless_void_chronosphere'] = {weight = 0.1},

    ['furion_sprout'] = {weight = 0.1},
    ['furion_teleportation'] = {weight = 0.5},
    ['furion_force_of_nature'] = {weight = 0.8},
    ['furion_curse_of_the_forest'] = {weight = 0.3},
    ['furion_wrath_of_nature'] = {weight = 0.7},

    --[[1]] ['grimstroke_dark_artistry'] = {weight = 0.5},
    --[[2]] ['grimstroke_ink_creature'] = {weight = 0.3},
    --[[3]] ['grimstroke_spirit_walk'] = {weight = 0.5},
    --[[4]] ['grimstroke_dark_portrait'] = {weight = 0.2},
    --[[5]] ['grimstroke_return'] = {weight = 1},
    --[[6]] ['grimstroke_soul_chain'] = {weight = 0.2},

    --[[1]] ['gyrocopter_rocket_barrage'] = {weight = 0.8},
    --[[2]] ['gyrocopter_homing_missile'] = {weight = 0.3},
    --[[3]] ['gyrocopter_flak_cannon'] = {weight = 0.9},
    --[[6]] ['gyrocopter_call_down'] = {weight = 0.6},

    --[[1]] ['huskar_inner_fire'] = {weight = 0.5},
    --[[2]] ['huskar_burning_spear'] = {weight = 1},
    --[[6]] ['huskar_life_break'] = {weight = 1},



    --[[1]] ['muerta_dead_shot'] = {weight = 0.8},
    --[[2]] ['muerta_the_calling'] = {weight = 0.5},
    --[[3]] ['muerta_gunslinger'] = {weight = 1},
    --[[4]] ['muerta_parting_shot'] = {weight = 0.5},
    --[[6]] ['muerta_pierce_the_veil'] = {weight = 0.9},

    --[[4]] ['rubick_empty1'] = {weight = 1},
    --[[5]] ['rubick_empty2'] = {weight = 1},
}

function X.GetSpellReplaceWeight(ability)
    if X['spells'][ability] == nil then return 1 end
    return X['spells'][ability].weight
end

return X