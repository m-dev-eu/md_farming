return {
    Water = {
        label = "Water Selling Station",
        range = 5.0,
        position = vec3(208.9, -919, 30.7),
        blip = {
            sprite = 487, colour = 3, scale = 0.9
        }, ped = {
            model = 'a_m_m_prolhost_01', position = vec4(208.9, -919, 29.7, 60.9), scenario = 'WORLD_HUMAN_SMOKING'
        }, action = {
            sourceItems = {
                { name = 'six_pack_water', count = 1 },
                { name = 'plastic', count = 3 }
            },
            productItems = {
                name = 'money', count = 10
            }

        }
    }
}