--[[ ═══════════════════════════════════════════════════════════════════════════
     🐺 LXR-SPAWN — Locale: English (canonical)
     Developer   : iBoss21 | Brand : LXRCore | https://www.lxrcore.com
     © 2026 iBoss21 / LXRCore — All Rights Reserved
     ═══════════════════════════════════════════════════════════════════════════ ]]

Locale.Register('en', {
    ui = {
        hint_pick     = 'pick',
        hint_go       = 'ride out',
        kind_last     = 'where you were',
        kind_random   = 'the open range',
        kind_town     = 'town',
        title         = 'Where do you ride from?',
        subtitle      = 'Pick a place to begin',
        last_position = 'Where you left off',
        random        = 'Somewhere out there',
        spawn         = 'Ride out',
        new_character = 'Your story begins here',
        card_last     = 'Last seen',
        near          = '%{miles} miles from %{town}',
        ago_minutes   = '%{n} min ago',
        ago_hours     = '%{n} h ago',
        ago_days      = '%{n} days ago',
        random_note   = 'The server picks a town for you. Nobody knows where you will turn up, you included.',
        last_note     = 'Back where you left the world. Your horse, if it lived, is nearby.',
        protection    = 'Untouchable for %{s} s after you arrive',
        services      = 'In town',
        svc_doctor    = 'doctor', svc_law = 'law', svc_store = 'store', svc_train = 'train',
        svc_stable    = 'stable', svc_bank = 'bank', svc_post = 'post', svc_saloon = 'saloon',
    },
    place = {
        valentine  = 'Cattle town on the river; loud, muddy, everything for sale.',
        rhodes     = 'Old money and old grudges between two plantations.',
        saintdenis = 'The city. Trams, factories, the biggest market in the state.',
        blackwater = 'Lakeside town with a long memory for outlaws.',
        strawberry = 'A logging town the mayor wants to make a resort.',
        annesburg  = 'Coal, smoke and the mine that owns the town.',
        tumbleweed = 'What is left of a boom town, and a sheriff who keeps it.',
        armadillo  = 'Half empty since the sickness; cheap rooms, few questions.',
        emerald    = 'A ranch that takes anyone who can work. Start small.',
    },
    info = {
        protected   = 'You are untouchable for %{s} seconds.',
        protect_end = 'The world can touch you again.',
    },
})
