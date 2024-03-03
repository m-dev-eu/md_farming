return {
    Oranges = {
        position = vec3(325.5929, -210.0867, 53.0863),
        textUI = {
            icon = 'fas fa-apple-alt',
            placeholder = 'Oranges'
        },
        animation = {
            dict = 'anim@mp_snowball',
            clip = 'pickup_snowball',
        },
        farmProcess = {
            duration = 5000
        },
        range = 5.0,
        blip = {
            sprite = 354, colour = 64, name = 'Orange Farm'
        },
        marker = {
            type = 1, colour = vec4(255, 0, 0, 125)
        }
    }
}