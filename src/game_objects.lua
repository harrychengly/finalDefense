GAME_OBJECT_DEFS = {
    ['fire'] = {
        type = 'fire',
        texture = 'fire',
        frame = 14,
        width = 16,
        height = 16,
        solid = true,
        animations = {
            ['fire-ball'] = {
                frames = {2, 3, 4, 5},
                interval = 10,
                texture = 'fire',
                looping = false
            }
        }
    }
}
