return {
    Water = {
        label = 'Water Packing Station',
        range = 5.0,
        position = vec3(1917.2328, 581.4487, 176.3673),
        blip = {
            sprite = 487, colour = 3, scale = 0.9
        }, marker = {
            type = 1, colour = vec4(255, 165, 0, 190)
        }, action = {
            duration = 3500,
            animation = {
                dict = 'anim@mp_snowball',
                clip = 'pickup_snowball',
                flag = 1
            },
            sourceItems = {
                name = 'water', count = 6
            },
            productItems = {
                name = 'six_pack_water', count = 1
            }
        }
    }
}