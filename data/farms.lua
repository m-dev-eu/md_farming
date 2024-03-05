return {
    Water = {
        label = 'Water Farming',
        range = 5.0,
        position = vec3(1988.3424, 500.6478, 162.8061),
        blip = {
            sprite = 487, colour = 3, scale = 0.9
        }, marker = {
            type = 1, colour = vec4(255, 165, 0, 190)
        }, action = {
            duration = 5000,
            animation = {
                dict = 'anim@mp_snowball',
                clip = 'pickup_snowball',
                flag = 1
            },
            sourceItems = {
                name = 'empty_bottle', count = 1
            },
            productItems = {
                name = 'water', count = 1
            }
        }
    }
}