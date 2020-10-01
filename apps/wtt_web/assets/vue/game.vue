<template>
    <div class="container-fluid">
        <div v-for="row in boardSize" class="row border-left border-top  border-bottom border-dark">
            <div v-for="col in boardSize" class=" col border-right border-dark text-break">
                
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
        this.axios.get("/board")
    }

}
</script>