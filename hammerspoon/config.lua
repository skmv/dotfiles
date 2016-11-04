local config = {}

config.modules = {
   "arrangement",
   "arrows",
   "monitors",
   "fullscreen",
   "reload",
   "app_selector",
}

-- Maps monitor id -> screen index.
config.monitors = {
    autodiscover = true,
    rows = 1
}

-- Window arrangements.
config.arrangements = {
    fuzzy_search = {
        mash = {"cmd", "ctrl", "alt"},
        key = "Z"
    },
    {
        name = "zen",
        alert = true,
        mash = { "cmd", "ctrl", "alt" },
        key = "A",
        arrangement = {
            {
                app_title = "^Franz",
                monitor = 3,
                position = "full"
            },
            {
                app_title = "^Emacs",
                monitor = 2,
                position = "full",
            },
            {
               app_title = "^iTerm2",
               monitor = 2,
               position = "full",
            },
            {
                app_title = "^Dash",
                monitor = 1,
                position = "full",
            },
            {
               app_title = "^Chrome",
               monitor = 2,
               position = "full",
            }
        }
    }
}

return config
