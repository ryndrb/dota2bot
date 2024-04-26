local X = {}

function X.GetSpellReplaceWeight(ability)
    -- Might take into account cooldowns later
    local SpellList = {
        ['abaddon_death_coil'] = 0.8,
        ['abaddon_aphotic_shield'] = 0.8,

        ['abyssal_underlord_firestorm'] = 0.5,
        ['abyssal_underlord_pit_of_malice'] = 0.5,
        ['abyssal_underlord_dark_portal'] = 0.9,

        ['alchemist_acid_spray'] = 0.6,
        ['alchemist_unstable_concoction'] = 0.8,
        ['alchemist_berserk_potion'] = 0.8,
        ['alchemist_chemical_rage'] = 0.9,

        ['ancient_apparition_cold_feet'] = 0.7,
        ['ancient_apparition_ice_vortex'] = 0.6,
        ['ancient_apparition_chilling_touch'] = 1,
        ['ancient_apparition_ice_blast'] = 0.3,

        ['antimage_blink'] = 0.5,
        ['antimage_counterspell'] = 0.8,
        ['antimage_counterspell_ally'] = 0.9,
        ['antimage_mana_overload'] = 1,
        ['antimage_mana_void'] = 0.5,

        ['arc_warden_flux'] = 0.6,
        ['arc_warden_magnetic_field'] = 0.9,
        ['arc_warden_spark_wraith'] = 0.9,
        ['arc_warden_tempest_double'] = 1,

        ['axe_berserkers_call'] = 1,
        ['axe_battle_hunger'] = 0.8,
        ['axe_culling_blade'] = 0.2,

        ['bane_enfeeble'] = 0.5,
        ['bane_brain_sap'] = 0.5,
        ['bane_nightmare'] = 0.2,
        ['bane_fiends_grip'] = 0,

        ['batrider_sticky_napalm'] = 1,
        ['batrider_flamebreak'] = 0.9,
        ['batrider_firefly'] = 0.9,
        ['batrider_flaming_lasso'] = 0.1,

        ['beastmaster_wild_axes'] = 0.4,
        ['beastmaster_call_of_the_wild_boar'] = 1,
        ['beastmaster_call_of_the_wild_hawk'] = 1,
        ['beastmaster_primal_roar'] = 0,

        ['bloodseeker_bloodrage'] = 1,
        ['bloodseeker_blood_bath'] = 0.9,
        ['bloodseeker_blood_mist'] = 1,
        ['bloodseeker_rupture'] = 0.3,

        ['bounty_hunter_shuriken_toss'] = 0.7,
        ['bounty_hunter_wind_walk'] = 0.5,
        ['bounty_hunter_wind_walk_ally'] = 0.6,
        ['bounty_hunter_track'] = 1,

        ['brewmaster_thunder_clap'] = 0.7,
        ['brewmaster_cinder_brew'] = 0.7,
        ['brewmaster_drunken_brawler'] = 1,
        ['brewmaster_primal_companion'] = 1,
        ['brewmaster_primal_split'] = 1,

        ['bristleback_viscous_nasal_goo'] = 0.6,
        ['bristleback_quill_spray'] = 1,
        ['bristleback_bristleback'] = 0.9,
        ['bristleback_hairball'] = 0.5,

        ['broodmother_insatiable_hunger'] = 0.8,
        ['broodmother_spin_web'] = 1,
        ['broodmother_silken_bola'] = 0.5,
        ['broodmother_sticky_snare'] = 1,
        ['broodmother_spawn_spiderlings'] = 1,

        ['rubick_empty1'] = 1,
        ['rubick_empty2'] = 1,
    }

    if SpellList[ability] == nil then return 1 end

    return SpellList[ability]
end

return X