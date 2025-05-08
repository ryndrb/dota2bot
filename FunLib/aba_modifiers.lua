local X = {}


-- other stun sources uses modifier_stunned
X['stunned'] = {
    ['modifier_stunned'] = true,
}

-- less 'ministuns' or displacement stuns
X['stunned_unique'] = {
    ['modifier_ancientapparition_coldfeet_freeze'] = true,
    ['modifier_bane_nightmare'] = true,
    ['modifier_bane_fiends_grip'] = true,
    ['modifier_batrider_flaming_lasso	'] = true,
    ['modifier_earthshaker_fissure_stun'] = true,
    ['modifier_elder_titan_echo_stomp'] = true,
    ['modifier_enigma_black_hole_pull'] = true,
    ['modifier_enigma_black_hole_pull_scepter'] = true,
    ['modifier_faceless_void_chronosphere_freeze'] = true,
    ['modifier_hoodwink_bushwhack_trap'] = true,
    ['modifier_jakiro_ice_path_stun'] = true,
    ['modifier_kunkka_torrent'] = true,
    ['modifier_lion_impale'] = true,
    ['modifier_medusa_stone_gaze_stone'] = true,
    ['modifier_monkey_king_boundless_strike_stun'] = true,
    ['modifier_morphling_adaptive_strike'] = true,
    ['modifier_nyx_assassin_impale'] = true,
    ['modifier_pudge_dismember'] = true,
    ['modifier_sandking_impale'] = true,
    ['modifier_shadow_shaman_shackles'] = true,
    ['modifier_storm_spirit_electric_vortex_pull'] = true,
    ['modifier_tidehunter_ravage'] = true,
    ['modifier_tiny_avalanche_stun'] = true,
    ['modifier_tusk_walrus_punch_air_time'] = true,
    ['modifier_windrunner_shackle_shot'] = true,
    ['modifier_winter_wyvern_cold_embrace'] = true,

    ['modifier_teleporting'] = true,
}

X['stunned_unique_invulnerable'] = {
    ['modifier_eul_cyclone'] = true,
    ['modifier_invoker_tornado'] = true,
    ['modifier_shadow_demon_disruption'] = true,
    ['modifier_naga_siren_song_of_the_siren'] = true,
    ['modifier_brewmaster_storm_cyclone'] = true,
    ['modifier_obsidian_destroyer_astral_imprisonment_prison'] = true,
    ['modifier_wind_waker'] = true,
}

X['hexed'] = {
    ['modifier_sheepstick_debuff'] = true,
    ['modifier_lion_voodoo'] = true,
    ['modifier_shadow_shaman_voodoo'] = true,
    ['modifier_item_unstable_wand_critter'] = true,

    -- kinda
    ['modifier_tidehunter_dead_in_the_water'] = true,
}

X['rooted'] = {
    ['modifier_crystal_maiden_frostbite'] = true,
    ['modifier_ember_spirit_searing_chains'] = true,
    ['modifier_gungir_debuff'] = true,
    ['modifier_dark_troll_warlord_ensnare'] = true,
    ['modifier_meepo_earthbind'] = true,
    ['modifier_naga_siren_ensnare'] = true,
    ['modifier_furion_sprout_entangle'] = true,
    ['modifier_oracle_fortunes_end_purge'] = true,
    ['modifier_rod_of_atos_debuff'] = true,
    ['modifier_lone_druid_spirit_bear_entangle_effect'] = true,
    ['modifier_treant_natures_guise_root'] = true,
    ['modifier_treant_overgrowth'] = true,
    ['modifier_troll_warlord_berserkers_rage_ensnare'] = true,
    ['modifier_abyssal_underlord_pit_of_malice_ensare'] = true,
    ['modifier_dark_willow_bramble_maze'] = true,
    ['modifier_root'] = true,
    ['modifier_rooted'] = true,
}

return X