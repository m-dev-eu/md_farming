return {
    Oranges = {
        position = vec3(0, 0, 0),
        animation = {
            dict = 'anim@mp_snowball',
            clip = 'pickup_snowball',
        },
        processingProcess = {
            duration = 3000,
            requiredItems = {
                { name = 'water', count = 1 }
            },
            resultItems = {
                { name = 'scrapmetal', count = 1 }
            }
        },
        range = 5.0,
        blip = {
            sprite = 267, colour = 64, name = 'Orange Processing'
        },
        marker = {
            type = 1, colour = vec4(0, 255, 0, 125)
        }
    }
}