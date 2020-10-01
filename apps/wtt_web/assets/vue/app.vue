<template>
    <div class="container-fluid">
        <div v-for="row in boardSize" class="row">
            <div v-for="col in boardSize" class="col">
                    T
            </div>
        </div>
    </div>
</template>
<script>
const BOARD_SIZE = 10

export default {
    data: () => ({
        boardSize: BOARD_SIZE,
        tiles: new Array(BOARD_SIZE * BOARD_SIZE).fill({
            players: [],
            wall: false
        })
    }),
    mounted() {
    }

}
</script>