<template>
    <div class="container-fluid">
        <div v-for="row in boardSize" class="row border-left border-top border-dark" :class="row === boardSize ? 'border-bottom' : ''">
            <div v-for="col in boardSize" 
                 class=" col border-right border-dark text-break"
                 :class="tileClasses(col, row)">
            </div>
        </div>
    </div>
</template>
<script>
const BOARD_SIZE = 10
const boardIndex = (x, y) => (y - 1) * BOARD_SIZE + x - 1

export default {
    data: () => ({
        boardSize: BOARD_SIZE,
        board: new Array(BOARD_SIZE * BOARD_SIZE).fill({
            players: [],
            wall: false
        })
    }),
    mounted() {
        this.updateBoard()
    },
    methods: {
        tileClasses(x, y) {
            const tile = this.tile(x, y)
            return tile.wall ? 'bg-danger' : ''
        },
        tile(x, y) {
            return this.board[boardIndex(x, y)]
        },
        async updateBoard() {
            const response = await this.axios.get("/board")

            for (let board_el of response.data) {
                const {tile: [x, y]} = board_el
                this.$set(this.board, boardIndex(x, y), board_el)
            }
        }
    }
}
</script>